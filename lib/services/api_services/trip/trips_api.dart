import 'dart:convert';

import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class TripsApi {
  Future<List<Trip>> getMyTrips(String userId) async {
    Map<String, dynamic> myTripsMap = await getMyTripsMap(userId);
    List<Trip> myTrips = [];
    for (Map<String, dynamic> tripJson in myTripsMap["trips"]) {
      myTrips.add(Trip.fromJson(tripJson));
    }
    return myTrips;
  }

  Future<Map<String, dynamic>> getMyTripsMap(String userId) async {
    Uri uri = API(path: "trips/$userId").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw API.getError(uri, response);
  }

  Future<GetMatchResponse> getTripDetail(String userId, String tripId) async {
    Uri uri = API(path: "trips/$userId/$tripId").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return GetMatchResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw API.getError(uri, response);
  }
}
