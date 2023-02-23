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

  @override
  String toString() {
    return 'NominatimPlace{lat: $lat, lon: $lon, displayName: $displayName}';
  }
}
