import 'dart:convert';

import 'package:car_pooling/models/user/review.dart';
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

  Future<List<Review>> getReviews(String userId) async {
    List reviewsList = await _getReviewsList(userId);
    List<Review> reviews = [];
    for (Map<String, dynamic> reviewMap in reviewsList) {
      reviews.add(Review.fromJson(reviewMap));
    }
    return reviews;
  }

  Future<List> _getReviewsList(String userId) async {
    Uri uri =
        API(path: "/reviews", queryParameters: {"user_id": userId}).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw API.getError(uri, response);
  }
}
