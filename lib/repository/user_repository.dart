import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/end_trip_api.dart';
import 'package:car_pooling/services/api_services/match_api.dart';
import 'package:car_pooling/services/api_services/my_trips_api.dart';

import '../models/match/get_match_response.dart';
import '../models/match/post_match_response.dart';
import '../services/api_services/nominatim_api.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();
  final MatchApi _matchApi = locator<MatchApi>();
  final EndTripApi _endTripApi = locator<EndTripApi>();
  final MyTripsApi _myTripsApi = locator<MyTripsApi>();

  Future<List<NominatimPlace>> getNominatimPlaces(String search, double west,
      double south, double east, double north) async {
    return await _nominatimApi.getNominatimPlaces(
        search, west, south, east, north);
  }

  Future<NominatimPlace> getStartNominatimPlace(double lat, double lon) async {
    return await _nominatimApi.getStartNominatimPlace(lat, lon);
  }

  Future<PostMatchResponse> postMatch(Role role, Trip trip) async {
    return await _matchApi.postMatch(role, trip.toJson());
  }

  Future<GetMatchResponse> getMatch(
      Role role, String userId, String tripId, String matchId) async {
    return await _matchApi.getMatch(role, userId, tripId, matchId);
  }

  Future<bool> endTrip(String tripId) async {
    return await _endTripApi.endTrip(tripId);
  }

  Future<List<Trip>> getMyTrips(String userId) async {
    return await _myTripsApi.getMyTrips(userId);
  }
}
