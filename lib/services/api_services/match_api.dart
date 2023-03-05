import 'dart:convert';

import 'package:car_pooling/models/match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class MatchApi {
  Future<MatchResponse> match(Role role, Map<String, dynamic> tripMap) async {
    String path = "match/";
    switch (role) {
      case Role.driver:
        path += "passenger";
        break;
      case Role.passenger:
        path += "driver";
        break;
    }
    Uri uri = API(path: path, port: 8000).tokenUri();
    http.Response response = await http.post(uri, body: tripMap);
    if (response.statusCode == 200) {
      return MatchResponse.fromJson(jsonDecode(response.body));
    }
    throw API.getError(uri, response);
  }
}
