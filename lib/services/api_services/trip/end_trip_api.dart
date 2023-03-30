import 'dart:convert';

import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class EndTripApi {
  Future<bool> endTrip(String tripId) async {
    Uri uri = API(path: "/end-trip/$tripId").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }

  Future<bool> postEndTrip(Map<String, dynamic> reviewMap) async {
    Uri uri = API(path: "/end-trip").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(reviewMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }
}
