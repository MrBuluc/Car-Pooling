# uvicorn views:app --reload
from fastapi import FastAPI, Body, Response, status
import firebase_admin
from firebase_admin import credentials, firestore
import uvicorn
from models import Status, Trip, Role
from utils import match_routes, haversine_distance
from typing import List
from google.cloud.firestore import GeoPoint, ArrayUnion, Query, ArrayRemove
import json
from uuid import uuid4
from datetime import datetime
import pytz
import requests

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
            driver_trip.username = driver_trip.driver
            matched.append(driver_trip)
            trip.driver = driver_trip.driver

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


@app.post("/end-trip")
def post_end_trip(body: str = Body()):
    create_review(body)
    end_trip(json.loads(body)["trip_id"])


@app.get("/trips/{user_id}")
def trips(user_id):
    trips_list = []
    trips_col_ref = firestore.client().collection(u'Trips')
    trips_stream = trips_col_ref.where(u'user_id', u'==', f'{user_id}').order_by(
        u'created_at', direction=Query.DESCENDING).stream()
    for trip_dict in trips_stream:
        trip = Trip.from_dict(trip_dict.to_dict())
        if trip.role == Role.passenger and trip.driver_trip_id:
            driver = get(trips_col_ref, trip.driver_trip_id)["driver"]
        else:
            driver = trip.driver
        trips_list.append({"id": trip.id, "destination": trip.destination,
                           "origin": trip.origin, "status": trip.status,
                           "driver": driver, "created_at": trip.created_at})
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
        match_trip = Trip.from_dict(get(trips_col_ref, match_id))
        for passsenger_trip_id in trip.passengers:
            passenger_trip = Trip.from_dict(
                get(trips_col_ref, passsenger_trip_id))
            if (match_trip.user_id == passenger_trip.user_id):
                update(trips_col_ref, trip_id, {
                       u"passengers": ArrayRemove([passsenger_trip_id])})
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
def get_profile(user_id, response: Response):
    return {"user": get_user(user_id, response), "vehicle": get_vehicle(user_id)}


@app.get("/reviews")
def get_reviews(user_id):
    reviews_stream = firestore.client().collection(u"Reviews").where(u"user_id", "==", user_id)\
        .order_by(u"created_at", direction=Query.DESCENDING).stream()
    reviews = []
    for review_stream_dict in reviews_stream:
        review_dict = review_stream_dict.to_dict()
        reviews.append({"review": review_dict["review"], "reviewer_username": get_username(
            review_dict["reviewer_id"]), "created_at": review_dict["created_at"],
            "reviewer_id": review_dict["reviewer_id"]})

    return reviews


@app.post("/create-review")
def create_review(body: str = Body()):
    review_dict = json.loads(body)
    review_dict["id"] = str(uuid4())
    review_dict["created_at"] = datetime.now(pytz.timezone("Asia/Istanbul"))
    client = firestore.client()
    if "driver_trip_id" in review_dict:
        review_dict["user_id"] = get(client.collection(
            u"Trips"), review_dict["driver_trip_id"])["user_id"]
        review_dict.pop("driver_trip_id")
    save(client.collection(u"Reviews"),
         review_dict["id"], review_dict)


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


@app.get("/nominatim-search")
def get_nominatim_place_list(search, origin_lat, origin_lon):
    west, south, east, north = 27.045, 35.93, 29.87, 37.928
    nominatim_place_list = get_request("https://nominatim.openstreetmap.org/search", params={
        "q": search, "format": "json", "bounded": "1",
        "viewbox": f"{west},{south},{east},{north}"})
    nominatim_place_list_filtered = []
    for nominatim_place in nominatim_place_list:
        lat2, long2 = nominatim_place["lat"], nominatim_place["lon"]
        distance = haversine_distance(
            float(origin_lat), float(origin_lon), float(lat2), float(long2))
        nominatim_place_list_filtered.append({"lat": lat2, "lon": long2,
                                              "display_name": nominatim_place["display_name"],
                                              "distance": distance})
    return nominatim_place_list_filtered


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
                            "match_rate": match_rate * 100, "user_id": trip.user_id})
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


def get_request(url, params: dict = {}):
    response = requests.get(url, params)
    if (response.status_code == 200):
        return response.json()
    return response.raise_for_status()


def initializeFirebase():
    firebase_admin.initialize_app(credentials.Certificate(
        ".\secrets\car-pooling-f0ddf-firebase-adminsdk-2xqeg-21a0254d83.json"))


if __name__ == '__main__':
    initializeFirebase()
    uvicorn.run("views:app")
