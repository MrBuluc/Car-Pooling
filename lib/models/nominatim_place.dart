import 'dart:math';

class NominatimPlace {
  String? lat;
  String? lon;
  String? displayName;
  double? d;

  NominatimPlace.fromJson(Map<String, dynamic> json) {
    lat = json["lat"];
    lon = json["lon"];
    displayName = json["display_name"];
  }

  distance(String lat1, String lon1) {
    double lat1Double = double.parse(lat1);
    double lat2Double = double.parse(lat!);
    // radius of the earth in km
    int R = 6371;
    double dLat = (lat2Double - lat1Double) * (pi / 180);
    double dLon = (double.parse(lon!) - double.parse(lon1)) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Double * (pi / 180)) *
            cos(lat2Double * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    d = R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  @override
  String toString() {
    return 'NominatimPlace{lat: $lat, lon: $lon, displayName: $displayName}';
  }
}
