import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/trip/end_trip_api.dart';
import 'package:car_pooling/services/api_services/trip/match_api.dart';
import 'package:car_pooling/services/api_services/user_api.dart';

import '../models/match/get_match_response.dart';
import '../models/match/post_match_response.dart';
import '../models/user.dart';
import '../services/api_services/nominatim_api.dart';
import '../services/api_services/trip/trips_api.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();
  final MatchApi _matchApi = locator<MatchApi>();
  final EndTripApi _endTripApi = locator<EndTripApi>();
  final TripsApi _tripsApi = locator<TripsApi>();
  final UserApi _userApi = locator<UserApi>();

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
      String userId, String tripId, String matchId) async {
    return await _matchApi.getMatch(userId, tripId, matchId);
  }

  Future<bool> endTrip(String tripId) async {
    return await _endTripApi.endTrip(tripId);
  }

  Future<List<Trip>> getMyTrips(String userId) async {
    return await _tripsApi.getMyTrips(userId);
  }

  Future<GetMatchResponse> getTripDetail(String userId, String tripId) async {
    return await _tripsApi.getTripDetail(userId, tripId);
  }

  Future<GetMatchResponse> acceptTrip(
      String userId, String tripId, String matchId) async {
    return await _matchApi.acceptTrip(userId, tripId, matchId);
  }

  Future<User?> getUser(String userId) async {
    return await _userApi.getUser(userId);
  }
}
