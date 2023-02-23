import 'package:car_pooling/locator.dart';
import 'package:car_pooling/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

import '../models/nominatim_place.dart';
import '../models/osrm_route.dart';

class UserModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();

  Future<List<NominatimPlace>> getNominatimPlaces(String search) async {
    try {
      return await _userRepository.getNominatimPlaces(search);
    } catch (e) {
      printError("getNominatimPlaces", e);
      rethrow;
    }
  }

  Future<OSRMRoute> getRoute(
      String startLon, String startLat, String endLon, String endLat) async {
    try {
      return await _userRepository.getRoute(startLon, startLat, endLon, endLat);
    } catch (e) {
      printError("getRoute", e);
      rethrow;
    }
  }

  printError(String funcName, Object e) {
    print("Usermodel $funcName hata: $e");
  }
}
