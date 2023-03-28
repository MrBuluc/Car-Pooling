# uvicorn views:app --reload
from fastapi import FastAPI, Body, Response, status
import firebase_admin
from firebase_admin import credentials, firestore
import uvicorn
from models import Status, Trip, Role
from utils import match_routes
from typing import List
from google.cloud.firestore import GeoPoint, ArrayUnion, Query, ArrayRemove
import json
from uuid import uuid4

app = FastAPI()


@app.get("/")
def root():
    return "Bu API Views Apidır"


@app.post("/match/passenger")
def post_match_passenger(body: str = Body()):
    trip = Trip.from_dict(json.loads(body))
    trip.role = Role.driver
    trips_col_ref = firestore.client().collection(u'Trips')
    cancel_former_trips(trips_col_ref, trip.user_id)
    save(trips_col_ref, trip.id, trip.to_dict())
    matches = find_matches(trips_col_ref, Role.passenger, trip.route)
    return {"result": matches, "id": trip.id}


@app.post("/match/driver")
def post_match_driver(body: str = Body()):
    trip = Trip.from_dict(json.loads(body))
    trip.role = Role.passenger
    trips_col_ref = firestore.client().collection(u'Trips')
    cancel_former_trips(trips_col_ref, trip.user_id)
    save(trips_col_ref, trip.id, trip.to_dict())
    matches = find_matches(trips_col_ref, Role.driver, trip.route)
    return {"result": matches, "id": trip.id}


@app.get("/match")
def match(user_id, trip_id, match_id):
    trips_col_ref = firestore.client().collection(u'Trips')
    update(trips_col_ref, match_id, {
        u'requests': ArrayUnion([f'{trip_id}'])})
    return trip_detail(user_id, trip_id)


@app.get("/trips/{user_id}/{trip_id}")
def trip_detail(user_id, trip_id):
    trips_col_ref = firestore.client().collection(u'Trips')
    trip = Trip.from_dict(get(trips_col_ref, trip_id))
    matched = []
    matches = []
    requests = []
    min_match_rate = 0.4
    if trip.role == Role.driver:
        trips = trips_col_ref.where(u'role', u'==', Role.passenger).where(
            u'status', u'==', Status.pending).where(u'user_id', u'!=', f'{user_id}').stream()
        for passenger_trip_id in trip.passengers:
            passenger_trip = Trip.from_dict(
                get(trips_col_ref, passenger_trip_id))
            passenger_trip.username = get_username(passenger_trip.user_id)
            matched.append(passenger_trip)
    else:
        trips = trips_col_ref.where(u'role', u'==', Role.driver).where(
            u'status', u'!=', Status.ended).stream()
        if trip.driver_trip_id:
            driver_trip = Trip.from_dict(
                get(trips_col_ref, trip.driver_trip_id))
            driver_trip.username = get_username(driver_trip.user_id)
            matched.append(driver_trip)

    if trip.status != Status.ended:
        for mtrip_dict in trips:
            mtrip = Trip.from_dict(mtrip_dict.to_dict())
            if mtrip.user_id != user_id:

                if trip.role == Role.passenger:
                    flag = trip.driver_trip_id != mtrip.id
                else:
                    flag = mtrip.id not in trip.passengers and mtrip.id not in trip.requests
                if flag:
                    match_rate = match_routes(trip.route, mtrip.route)
                    if match_rate >= min_match_rate:
                        mtrip.match_rate = match_rate * 100
                        mtrip.username = get_username(mtrip.user_id)
                        matches.append(mtrip)

    for request_trip_id in trip.requests:
        request_trip = Trip.from_dict(get(trips_col_ref, request_trip_id))
        request_trip.username = get_username(request_trip.user_id)
        requests.append(request_trip)

    return {"trip": trip.to_dict(), "matched": matched, "matches": matches,
            "requests": requests}


@app.get("/end-trip/{trip_id}")
def end_trip(trip_id):
    update(firestore.client().collection(u'Trips'),
           trip_id, {u'status': Status.ended})


@app.get("/trips/{user_id}")
def trips(user_id):
    trips_list = []
    trips_stream = firestore.client().collection(u'Trips').where(
        u'user_id', u'==', f'{user_id}').order_by(u'created_at',
                                                  direction=Query.DESCENDING)\
        .stream()
    for trip_dict in trips_stream:
        trip = Trip.from_dict(trip_dict.to_dict())
        trips_list.append({"id": trip.id, "destination": trip.destination,
                           "origin": trip.origin, "status": trip.status,
                           "driver": trip.driver, "created_at": trip.created_at})
    return {"trips": trips_list}


@app.get("/accept-trip")
def accept_trip(user_id, trip_id, match_id):
    trips_col_ref = firestore.client().collection(u'Trips')
    trip = Trip.from_dict(get(trips_col_ref, trip_id))

    if trip.role == Role.passenger:
        update(trips_col_ref, trip_id, {u'driver_trip_id': match_id})
        update(trips_col_ref, match_id, {
            u'passengers': ArrayUnion([f'{trip_id}'])})
    else:
        update(trips_col_ref, trip_id, {
            u'passengers': ArrayUnion([f'{match_id}'])})
        update(trips_col_ref, match_id, {u'driver_trip_id': trip_id})

    update(trips_col_ref, trip_id, {
        u'status': Status.started, u'requests': ArrayRemove([f'{match_id}'])})
    update(trips_col_ref, match_id, {u'status': Status.started})

    return trip_detail(user_id, trip_id)


@app.get("/get-user/{user_id}")
def get_user(user_id, response: Response):
    user_dict = get(firestore.client().collection(u'Users'), user_id)
    if user_dict:
        return user_dict
    else:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "User Not Found"}


@app.get("/get-vehicle")
def get_vehicle(user_id):
    vehicles_stream = firestore.client().collection(
        u'Vehicles').where(u"user_id", u"==", user_id).stream()
    vehicle = {}
    for vehicle_dict in vehicles_stream:
        vehicle = vehicle_dict.to_dict()

    return vehicle


@app.get("/profile/{user_id}")
def get_profile(user_id):
    pass


@app.get("/reviews")
def get_reviews(user_id):
    pass


@app.post("/create-review")
def create_review(body: str = Body()):
    pass


@app.post("/update-user/{user_id}")
def update_user(user_id, body: str = Body()):
    update(firestore.client().collection(u'Users'), user_id, json.loads(body))


@app.put("/add-vehicle")
def add_vehicle(body: str = Body()):
    vehicle_dict = json.loads(body)
    vehicle_dict["id"] = str(uuid4())
    save(firestore.client().collection(u'Vehicles'),
         vehicle_dict["id"], vehicle_dict)


@app.post("/update-vehicle/{vehicle_id}")
def update_vehicle(vehicle_id, body: str = Body()):
    update(firestore.client().collection(
        u'Vehicles'), vehicle_id, json.loads(body))


def cancel_former_trips(trips_col_ref, user_id):
    trips = trips_col_ref.where(u'user_id', u'==', f'{user_id}').where(
        u'status', u'!=', Status.ended).stream()

    for trip_dict in trips:
        trip = Trip.from_dict(trip_dict.to_dict())
        update(trips_col_ref, trip.id, {u'status': Status.ended})


def update(col_ref, doc_id, update_fields):
    col_ref.document(f'{doc_id}').update(update_fields)


def save(col_ref, doc_id, doc_dict):
    col_ref.document(f'{doc_id}').set(doc_dict)


def find_matches(trips_col_ref, role: Role, route: List[GeoPoint]):
    min_match_rate = 0.4
    matches = []
    if role == Role.driver:
        trips = trips_col_ref.where(u'role', u'==', f'{role}').where(
            u'status', u'!=', Status.ended).stream()
    else:
        trips = trips_col_ref.where(u'role', u'==', f'{role}').where(
            u'status', u'==', Status.pending).stream()

    for tripDict in trips:
        trip = Trip.from_dict(tripDict.to_dict())
        match_rate = match_routes(route, trip.route)
        if match_rate >= min_match_rate:
            username = get_username(trip.user_id)

            matches.append({"id": trip.id, "username": username,
                            "driver": trip.driver,
                            "destination": trip.destination,
                            "origin": trip.origin, "origin_lat": trip.origin_lat,
                            "origin_lon": trip.origin_lon,
                            "match_rate": match_rate * 100})
    return matches


def get(col_ref, doc_id):
    return col_ref.document(f'{doc_id}').get().to_dict()


def get_username(id):
    user_dict = firestore.client().collection(
        u'Users').document(f'{id}').get().to_dict()
    username = user_dict[u'name']
    if u'surname' in user_dict:
        username += " " + user_dict[u'surname']
    return username


def initializeFirebase():
    firebase_admin.initialize_app(credentials.Certificate(
        ".\secrets\car-pooling-f0ddf-firebase-adminsdk-2xqeg-21a0254d83.json"))


if __name__ == '__main__':
    initializeFirebase()
    uvicorn.run("views:app")
