import 'package:car_pooling/models/trip.dart';

class MatchResponse {
  List<Trip> result = [];
  String? newTripId;

  MatchResponse.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> resultList = json["result"];
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
