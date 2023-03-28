import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

import '../models/match/get_match_response.dart';
import '../models/match/post_match_response.dart';
import '../models/nominatim_place.dart';
import '../models/user/user.dart';
import '../models/user/vehicle.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  User? user;

  Future<List<NominatimPlace>> getNominatimPlaces(String search, double west,
      double south, double east, double north) async {
    try {
      return await _userRepository.getNominatimPlaces(
          search, west, south, east, north);
    } catch (e) {
      printError("getNominatimPlaces", e);
      rethrow;
    }
  }

  Future<NominatimPlace> getStartNominatimPlace(double lat, double lon) async {
    try {
      return await _userRepository.getStartNominatimPlace(lat, lon);
    } catch (e) {
      printError("getStartNominatimPlace", e);
      rethrow;
    }
  }

  Future<PostMatchResponse> postMatch(Role role, Trip trip) async {
    try {
      trip.userId = user!.id;
      trip.driver = role == Role.driver ? user!.username : null;
      trip.username = role == Role.passenger ? user!.username : null;
      return await _userRepository.postMatch(role, trip);
    } catch (e) {
      printError("postMatch", e);
      rethrow;
    }
  }

  Future<GetMatchResponse> getMatch(String tripId, String matchId) async {
    try {
      return await _userRepository.getMatch(user!.id!, tripId, matchId);
    } catch (e) {
      printError("getMatch", e);
      rethrow;
    }
  }

  Future<bool> endTrip(String tripId) async {
    try {
      return await _userRepository.endTrip(tripId);
    } catch (e) {
      printError("endTrip", e);
      rethrow;
    }
  }

  Future<List<Trip>> getMyTrips() async {
    try {
      return await _userRepository.getMyTrips(user!.id!);
    } catch (e) {
      printError("getMyTrips", e);
      rethrow;
    }
  }

  Future<GetMatchResponse> getTripDetail(String tripId) async {
    try {
      return await _userRepository.getTripDetail(user!.id!, tripId);
    } catch (e) {
      printError("getTripDetail", e);
      rethrow;
    }
  }

  Future<GetMatchResponse> acceptTrip(String tripId, String matchId) async {
    try {
      return await _userRepository.acceptTrip(user!.id!, tripId, matchId);
    } catch (e) {
      printError("acceptTrip", e);
      rethrow;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      user = await _userRepository.getUser(userId);
      return user;
    } catch (e) {
      printError("getUser", e);
      rethrow;
    }
  }

  Future<bool> updateUser(User updateUser) async {
    try {
      return await _userRepository.updateUser(user!.id!, updateUser);
    } catch (e) {
      printError("updateUser", e);
      rethrow;
    }
  }

  Future<List> getProfile(String userId) async {
    try {
      return await _userRepository.getProfile(userId);
    } catch (e) {
      printError("getProfile", e);
      rethrow;
    }
  }

  Future<bool> createReview(Review review) async {
    try {
      return await _userRepository.createReview(review);
    } catch (e) {
      printError("createReview", e);
      rethrow;
    }
  }

  Future<bool> addVehicle(Vehicle vehicle) async {
    try {
      vehicle.userId = user!.id!;
      return await _userRepository.addVehicle(vehicle);
    } catch (e) {
      printError("addVehicle", e);
      rethrow;
    }
  }

  Future<bool> updateVehicle(Vehicle vehicle) async {
    try {
      return await _userRepository.updateVehicle(vehicle);
    } catch (e) {
      printError("updateVehicle", e);
      rethrow;
    }
  }

  Future<Vehicle> getVehicle() async {
    try {
      return await _userRepository.getVehicle(user!.id!);
    } catch (e) {
      printError("getVehicle", e);
      rethrow;
    }
  }

  printError(String funcName, Object e) {
    print("Usermodel $funcName Error: $e");
  }
}
