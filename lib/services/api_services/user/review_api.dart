import 'dart:convert';

import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class ReviewApi {
  Future<bool> createReview(Map<String, dynamic> reviewMap) async {
    Uri uri = API(path: "create-review").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(reviewMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }
}
