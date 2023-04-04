class NominatimPlace {
  String? lat;
  String? lon;
  String? displayName;
  double? distance;

  NominatimPlace({this.lat, this.lon, this.displayName, this.distance});

  NominatimPlace.fromJson(Map<String, dynamic> json)
      : this(
            lat: json["lat"],
            lon: json["lon"],
            displayName: json["display_name"],
            distance: json["distance"]);

  @override
  String toString() {
    return 'NominatimPlace{lat: $lat, lon: $lon, displayName: $displayName}';
  }
}
