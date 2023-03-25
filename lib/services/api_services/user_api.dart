import 'dart:convert';

import 'package:car_pooling/models/user.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

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
}
