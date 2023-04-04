import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/services/api_services/trip/end_trip_api.dart';
import 'package:car_pooling/services/api_services/trip/match_api.dart';
import 'package:car_pooling/services/api_services/user/review_api.dart';
import 'package:car_pooling/services/api_services/user/vehicle_api.dart';

import '../models/match/get_match_response.dart';
import '../models/match/post_match_response.dart';
import '../models/user/user.dart';
import '../models/user/vehicle.dart';
import '../services/api_services/nominatim_api.dart';
import '../services/api_services/trip/trips_api.dart';
import '../services/api_services/user/user_api.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();
  final MatchApi _matchApi = locator<MatchApi>();
  final EndTripApi _endTripApi = locator<EndTripApi>();
  final TripsApi _tripsApi = locator<TripsApi>();
  final UserApi _userApi = locator<UserApi>();
  final ReviewApi _reviewApi = locator<ReviewApi>();
  final VehicleApi _vehicleApi = locator<VehicleApi>();

  Future<List<NominatimPlace>> getNominatimPlaces(
      String search, String originLat, String originLon) async {
    return await _nominatimApi.getNominatimPlaces(search, originLat, originLon);
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

  Future<bool> postEndTrip(Review review) async {
    return await _endTripApi.postEndTrip(review.toJson());
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

  Future<bool> updateUser(String userId, User user) async {
    return await _userApi.updateUser(userId, user.toJson());
  }

  Future<List> getProfile(String userId) async {
    return await _userApi.getProfile(userId);
  }

  Future<bool> createReview(Review review) async {
    return await _reviewApi.createReview(review.toJson());
  }

  Future<List<Review>> getReviews(String userId) async {
    return await _reviewApi.getReviews(userId);
  }

  Future<bool> addVehicle(Vehicle vehicle) async {
    return await _vehicleApi.add(vehicle.toJson());
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    return await _vehicleApi.update(vehicle.id!, vehicle.toJson());
  }

  Future<Vehicle> getVehicle(String userId) async {
    return await _vehicleApi.get(userId);
  }
}
