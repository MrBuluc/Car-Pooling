from pydantic import BaseModel
from typing import Optional, List
from uuid import uuid4
from datetime import datetime
from enum import Enum
import pytz
from google.cloud.firestore import GeoPoint


class Role(str, Enum):
    driver = "driver"
    passenger = "passenger"


class Status(str, Enum):
    active = "active"
    inactive = "ended"


class Trip(object):
    def __init__(self, id=str(uuid4()), created_at=datetime.now(pytz.timezone("Asia/Istanbul")),
                 status=Status.active, destination="", route=[], origin="", origin_lat=0,
                 origin_lon=0, destination_lat=0, destination_lon=0, user_id="", username="",
                 driver="", match_rate=0.0, role="", matches=[]):
        self.id = id
        self.destination = destination
        self.route = route
        self.origin = origin
        self.origin_lat = origin_lat
        self.origin_lon = origin_lon
        self.destination_lat = destination_lat
        self.destination_lon = destination_lon
        self.user_id = user_id
        self.username = username
        self.driver = driver
        self.match_rate = match_rate
        self.created_at = created_at
        self.role = role
        self.status = status
        self.matches = matches

    @staticmethod
    def from_dict(source):
        trip = Trip()
        trip.id = str(uuid4())

        if u'id' in source:
            trip.id = source[u'id']
        if u'destination' in source:
            trip.destination = source[u'destination']
        if u'route' in source:
            routeList = source[u'route']
            if type(routeList[0]) == list:
                geo_point_list = []
                for i in range(len(routeList)):
                    geo_point_list.append(
                        GeoPoint(routeList[i][0], routeList[i][1]))
                trip.route = geo_point_list
            else:
                trip.route = source[u'route']
        if u'origin' in source:
            trip.origin = source[u'origin']
        if u'origin_lat' in source:
            origin_lat = source[u'origin_lat']
            if type(origin_lat) == str:
                trip.origin_lat = float(origin_lat)
            else:
                trip.origin_lat = source[u'origin_lat']
        if u'origin_lon' in source:
            origin_lon = source[u'origin_lon']
            if type(origin_lon) == str:
                trip.origin_lon = float(origin_lon)
            else:
                trip.origin_lon = source[u'origin_lon']
        if u'destination_lat' in source:
            trip.destination_lat = source[u'destination_lat']
        if u'destination_lon' in source:
            trip.destination_lon = source[u'destination_lon']
        if u'user_id' in source:
            trip.user_id = source[u'user_id']
        if u'username' in source:
            trip.username = source[u'username']
        if u'driver' in source:
            trip.driver = source[u'driver']
        if u'match_rate' in source:
            trip.match_rate = source[u'match_rate']
        if u'created_at' in source:
            trip.created_at = source[u'created_at']
        if u'role' in source:
            trip.role = source[u'role']
        if u'status' in source:
            trip.status = source[u'status']
        if u'matches' in source:
            trip.matches = source[u'matches']

        return trip

    def to_dict(self):
        dest = {}

        if self.id:
            dest[u'id'] = self.id
        if self.destination:
            dest[u'destination'] = self.destination
        if self.route:
            dest[u'route'] = self.route
        if self.origin:
            dest[u'origin'] = self.origin
        if self.origin_lat:
            dest[u'origin_lat'] = self.origin_lat
        if self.origin_lon:
            dest[u'origin_lon'] = self.origin_lon
        if self.destination_lat:
            dest[u'destination_lat'] = self.destination_lat
        if self.destination_lon:
            dest[u'destination_lon'] = self.destination_lon
        if self.user_id:
            dest[u'user_id'] = self.user_id
        if self.username:
            dest[u'username'] = self.username
        if self.driver:
            dest[u'driver'] = self.driver
        if self.match_rate:
            dest[u'match_rate'] = self.match_rate
        if self.created_at:
            dest[u'created_at'] = self.created_at
        if self.role:
            dest[u'role'] = self.role
        if self.status:
            dest[u'status'] = self.status
        if self.matches:
            dest[u'matches'] = self.matches

        return dest

    def __repr__(self):
        return (f'Trip(id={self.id}, destination={self.destination}, route={self.route}, ' +
                f'origin={self.origin}, origin_lat={self.origin_lat}, ' +
                f'origin_lon={self.origin_lon}, destination_lat={self.destination_lat}, ' +
                f'destination_lon={self.destination_lon}, user_id={self.user_id}, ' +
                f'username={self.username}, driver={self.driver}, match_rate={self.match_rate}, ' +
                f'created_at={self.created_at}, role={self.role}, status={self.status}, ' +
                f'matches={self.matches})')
