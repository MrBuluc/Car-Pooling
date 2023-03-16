import 'dart:convert';

import 'package:car_pooling/models/match/get_match_response.dart';
import 'package:car_pooling/models/match/post_match_response.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class MatchApi {
  Future<PostMatchResponse> postMatch(
      Role role, Map<String, dynamic> tripMap) async {
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
    http.Response response = await http.post(uri, body: jsonEncode(tripMap));
    if (response.statusCode == 200) {
      return PostMatchResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw API.getError(uri, response);
  }

  Future<GetMatchResponse> getMatch(
      Role role, String userId, String tripId, String matchId) async {
    Uri uri = API(port: 8000, path: "match/driver", queryParameters: {
      "user_id": userId,
      "trip_id": tripId,
      "match_id": matchId
    }).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return GetMatchResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw API.getError(uri, response);
  }
}
