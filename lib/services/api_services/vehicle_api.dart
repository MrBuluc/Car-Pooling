import 'dart:convert';

import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class VehicleApi {
  Future<bool> addVehicle(Map<String, dynamic> vehicleMap) async {
    Uri uri = API(path: "add-vehicle").tokenUri();
    http.Response response = await http.put(uri, body: jsonEncode(vehicleMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }
}
