class OSRMRoute {
  List? coordinates;

  OSRMRoute.fromJson(Map<String, dynamic> json) {
    coordinates = json["routes"][0]["geometry"]["coordinates"];
  }

  @override
  String toString() {
    return 'OSRMRoute{coordinates: $coordinates}';
  }
}
