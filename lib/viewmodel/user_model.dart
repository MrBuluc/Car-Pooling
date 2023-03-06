import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

import '../models/match_response.dart';
import '../models/nominatim_place.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();

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

  Future<MatchResponse> match(Role role, Trip trip) async {
    try {
      trip.userId = "KGd2I6yOP8Vo6hwU6gj7DuvuZpO2";
      trip.driver = role == Role.driver ? "Hakkıcan Bülüç" : null;
      return await _userRepository.match(role, trip);
    } catch (e) {
      printError("match", e);
      rethrow;
    }
  }

  printError(String funcName, Object e) {
    print("Usermodel $funcName hata: $e");
  }
}
