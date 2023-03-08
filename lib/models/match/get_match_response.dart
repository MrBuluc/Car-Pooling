import 'package:car_pooling/models/trip.dart';

class GetMatchResponse {
  Trip? trip;
  List<Trip> matched = [];
  List<Trip> matches = [];

  GetMatchResponse.fromJson(Map<String, dynamic> json) {
    trip = Trip.fromJson(json["trip"]);
    List matchedList = json["matched"], matchesList = json["matches"];
    for (Map<String, dynamic> tripJson in matchedList) {
      matched.add(Trip.fromJson(tripJson));
    }
    for (Map<String, dynamic> tripJson in matchesList) {
      matches.add(Trip.fromJson(tripJson));
    }
  }

  @override
  String toString() {
    return 'GetMatchResponse{trip: $trip, matched: $matched, matches: $matches}';
  }
}
