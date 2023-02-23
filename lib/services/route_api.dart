import 'dart:convert';

import 'package:car_pooling/models/osrm_route.dart';
import 'package:car_pooling/services/api.dart';
import 'package:http/http.dart' as http;

class RouteApi {
  Future<OSRMRoute> getRoute(
      String startLon, String startLat, String endLon, String endLat) async {
    Uri uri = API(
        host: "router.project-osrm.org",
        path: "route/v1/driving/$startLon,$startLat;$endLon,$endLat",
        queryParameters: {"geometries": "geojson"}).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return OSRMRoute.fromJson(jsonDecode(response.body));
    }
    throw API.getError(uri, response);
  }
}
