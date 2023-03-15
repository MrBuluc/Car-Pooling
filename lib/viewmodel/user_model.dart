import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

import '../models/match/get_match_response.dart';
import '../models/match/post_match_response.dart';
import '../models/nominatim_place.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  String? userId;

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
      trip.userId = userId;
      trip.driver = role == Role.driver ? "Hakkıcan Bülüç" : null;
      return await _userRepository.postMatch(role, trip);
    } catch (e) {
      printError("postMatch", e);
      rethrow;
    }
  }

  Future<GetMatchResponse> getMatch(
      Role role, String tripId, String matchId) async {
    try {
      return await _userRepository.getMatch(role, userId!, tripId, matchId);
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

  printError(String funcName, Object e) {
    print("Usermodel $funcName hata: $e");
  }
}
