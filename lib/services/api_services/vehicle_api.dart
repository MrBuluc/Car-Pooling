import 'dart:convert';

import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

import '../../models/user/vehicle.dart';

class VehicleApi {
  Future<bool> add(Map<String, dynamic> vehicleMap) async {
    Uri uri = API(path: "add-vehicle").tokenUri();
    http.Response response = await http.put(uri, body: jsonEncode(vehicleMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }

  Future<bool> update(String id, Map<String, dynamic> vehicleMap) async {
    Uri uri = API(path: "update-vehicle/$id").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(vehicleMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }

  Future<Vehicle> get(String userId) async {
    Uri uri = API(path: "get-vehicle", queryParameters: {"user_id": userId})
        .tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw API.getError(uri, response);
  }
}
