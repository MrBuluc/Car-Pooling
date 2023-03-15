# uvicorn views:app --reload
from fastapi import FastAPI, Body
import firebase_admin
from firebase_admin import credentials, firestore
import uvicorn
from models import Status, Trip, Role
from utils import match_routes
from typing import List
from google.cloud.firestore import GeoPoint, ArrayUnion
import json

app = FastAPI()


@app.get("/")
def root():
    return "Bu API Views Apidır"


@app.post("/match/passenger")
def match_passenger(body: str = Body()):
    trip = Trip.from_dict(json.loads(body))
    trip.role = Role.driver
    trips_col_ref = firestore.client().collection(u'Trips')
    cancel_former_trips(trips_col_ref, trip.user_id)
    save_trip(trips_col_ref, trip)
    matches = find_matches(trips_col_ref, Role.passenger, trip.route)
    return {"result": matches, "id": trip.id}


@app.get("/match/driver")
def match_driver(user_id, trip_id, match_id):
    trips_col_ref = firestore.client().collection(u'Trips')
    update_trip(trips_col_ref, match_id, {
                u'matches': ArrayUnion([f'{trip_id}'])})
    update_trip(trips_col_ref, trip_id, {u'matches': [match_id]})
    return trip_detail(user_id, trip_id)


@app.get("/trips/{user_id}/{trip_id}")
def trip_detail(user_id, trip_id):
    trips_col_ref = firestore.client().collection(u'Trips')
    trip = get_trip(trips_col_ref, trip_id)
    matched = []
    matches = []
    min_match_rate = 0.4
    if trip.role == Role.driver:
        trips = trips_col_ref.where(u'role', u'==', Role.passenger).where(
            u'status', u'==', Status.active).where(u'user_id', u'!=', f'{user_id}').stream()
        if trip.matches:
            for match_id in trip.matches:
                mtrip = get_trip(trips_col_ref, match_id)
                mtrip.username = get_username(mtrip.user_id)
                matched.append(mtrip)
        if trip.status == Status.active:
            for mtrip_dict in trips:
                mtrip = Trip.from_dict(mtrip_dict.to_dict())
                if check_trip_in_trips(matched, mtrip.id) == False:
                    match_rate = match_routes(trip.route, mtrip.route)
                    if match_rate >= min_match_rate:
                        mtrip.match_rate = match_rate * 100
                        matches.append(mtrip)
    # else:
    return {"trip": trip.to_dict(), "matched": matched, "matches": matches}


@app.get("/end-trip/{trip_id}")
def end_trip(trip_id):
    update_trip(firestore.client().collection(u'Trips'),
                trip_id, {u'status': Status.inactive})


def cancel_former_trips(trips_col_ref, user_id):
    trips = trips_col_ref.where(u'user_id', u'==', f'{user_id}').where(
        u'status', u'==', Status.active).stream()

    for trip_dict in trips:
        trip = Trip.from_dict(trip_dict.to_dict())
        update_trip(trips_col_ref, trip.id, {u'status': Status.inactive})


def update_trip(trips_col_ref, id, update_fields):
    trips_col_ref.document(f'{id}').update(update_fields)


def save_trip(trips_col_ref, trip: Trip):
    trips_col_ref.document(f'{trip.id}').set(trip.to_dict())


def find_matches(trips_col_ref, role: Role, route: List[GeoPoint]):
    min_match_rate = 0.4
    matches = []
    trips = trips_col_ref.where(u'role', u'==', f'{role}').where(
        u'status', u'==', Status.active).stream()

    for tripDict in trips:
        trip = Trip.from_dict(tripDict.to_dict())
        match_rate = match_routes(route, trip.route)
        if match_rate >= min_match_rate:
            if role == Role.passenger:
                username = get_username(trip.user_id)

            matches.append({"id": trip.id, "username": username, "driver": trip.driver,
                            "destination": trip.destination, "origin": trip.origin,
                            "origin_lat": trip.origin_lat, "origin_lon": trip.origin_lon,
                            "match_rate": match_rate * 100})
    return matches


def get_trip(trips_col_ref, id):
    return Trip.from_dict(trips_col_ref.document(f'{id}').get().to_dict())


def get_username(id):
    user_dict = firestore.client().collection(
        u'Users').document(f'{id}').get().to_dict()
    username = user_dict[u'name']
    if u'surname' in user_dict:
        username += " " + user_dict[u'surname']
    return username


def check_trip_in_trips(trips: list[Trip], trip_id):
    for trip in trips:
        if trip.id == trip_id:
            return True
    return False


def initializeFirebase():
    firebase_admin.initialize_app(credentials.Certificate(
        ".\secrets\city-fiores-global-firebase-adminsdk-2i2ar-706d6148dd.json"))


if __name__ == '__main__':
    initializeFirebase()
    uvicorn.run("views:app")
