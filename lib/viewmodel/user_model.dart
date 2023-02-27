import 'package:car_pooling/locator.dart';
import 'package:car_pooling/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

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

  printError(String funcName, Object e) {
    print("Usermodel $funcName hata: $e");
  }
}
