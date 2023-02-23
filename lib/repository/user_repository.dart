import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/services/nominatim_api.dart';
import 'package:car_pooling/services/route_api.dart';

import '../models/osrm_route.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();
  final RouteApi _routeApi = locator<RouteApi>();

  Future<List<NominatimPlace>> getNominatimPlaces(String search) async {
    return await _nominatimApi.getNominatimPlaces(search);
  }

  Future<OSRMRoute> getRoute(
      String startLon, String startLat, String endLon, String endLat) async {
    return await _routeApi.getRoute(startLon, startLat, endLon, endLat);
  }
}
