import 'dart:convert';

import 'package:car_pooling/models/user/vehicle.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

import '../../../models/user/user.dart';

class UserApi {
  Future<User?> getUser(String userId) async {
    Uri uri = API(path: "get-user/$userId").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw API.getError(uri, response);
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> userMap) async {
    Uri uri = API(path: "update-user/$userId").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(userMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }

  Future<List> getProfile(String userId) async {
    Uri uri = API(path: "/profile/$userId").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return [User.fromJson(body["user"]), Vehicle.fromJson(body["vehicle"])];
    }
    throw API.getError(uri, response);
  }
}
