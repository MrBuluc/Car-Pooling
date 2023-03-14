import math
from google.cloud.firestore import GeoPoint
from typing import List


def match_routes(route1: List[GeoPoint], route2: List[GeoPoint], threshold=0.05):
    shorter_route = route1 if len(route1) <= len(route2) else route2
    longer_route = route2 if len(route1) <= len(route2) else route1
    match = 0

    for geoPoint1 in shorter_route:
        for geoPoint2 in longer_route:
            if haversine_distance(geoPoint1.latitude, geoPoint1.longitude, geoPoint2.latitude,
                                  geoPoint2.longitude) <= threshold:
                match += 1
                break
    match_rate = match / len(shorter_route)
    return match_rate


def haversine_distance(lat1, long1, lat2, long2):
    lat1, long1, lat2, long2 = map(math.radians, [lat1, long1, lat2, long2])

    dlat = lat2 - lat1
    dlong = long2 - long1
    a = math.sin(dlat / 2)**2 + math.cos(lat1) * \
        math.cos(lat2) * math.sin(dlong / 2)**2
    c = 2 * math.asin(math.sqrt(a))
    r = 6371 # Radius of the earth in km
    return c * r
