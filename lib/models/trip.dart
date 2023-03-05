enum Role { driver, passenger }

class Trip {
  String? id;
  String? destination;
  List<List<double>>? route;
  String? origin;
  double? originLat;
  double? originLon;
  String? destinationLat;
  String? destinationLon;
  String? userId;
  String? driver;
  double? matchRate;
  DateTime? createdAt;
  Role? role;

  Trip(
      {this.id,
      this.destination,
      this.route,
      this.origin,
      this.originLat,
      this.originLon,
      this.destinationLat,
      this.destinationLon,
      this.userId,
      this.driver,
      this.matchRate,
      this.role});

  Trip.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            driver: json["driver"],
            destination: json["destination"],
            origin: json["origin"],
            originLon: json["origin_lon"],
            originLat: json["origin_lat"],
            matchRate: json["match_rate"]);

  Map<String, dynamic> toJson() => {
        if (route != null) "route": route,
        if (destination != null) "destination": destination,
        if (origin != null) "origin": origin,
        if (originLat != null) "origin_lat": originLat,
        if (originLon != null) "origin_lon": originLon,
        if (destinationLat != null) "destination_lat": destinationLat,
        if (destinationLon != null) "destination_lon": destinationLon,
        if (userId != null) "user_id": userId,
        if (driver != null) "driver": driver
      };

  @override
  String toString() {
    return 'Trip{id: $id, destination: $destination, '
        'route: ${route != null ? route![0] : null}, origin: $origin, '
        'originLat: $originLat, originLon: $originLon, '
        'destinationLat: $destinationLat, destinationLon: $destinationLon, '
        'userId: $userId, driver: $driver, matchRate: $matchRate, role: $role}';
  }
}
