import 'package:car_pooling/models/trip.dart';

class PostMatchResponse {
  List<Trip> result = [];
  String? newTripId;

  PostMatchResponse.fromJson(Map<String, dynamic> json) {
    List resultList = json["result"];
    for (Map<String, dynamic> tripJson in resultList) {
      result.add(Trip.fromJson(tripJson));
    }
    newTripId = json["id"];
  }

  @override
  String toString() {
    return 'MatchResponse{result: $result, newTripId: $newTripId}';
  }
}
