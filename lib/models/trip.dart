enum Role { driver, passenger }

enum Status { started, pending, ended }

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
  String? username;
  String? driver;
  double? matchRate;
  DateTime? createdAt;
  Role? role;
  Status? status;

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
      this.username,
      this.driver,
      this.matchRate,
      this.role});

  Trip.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    destination = json["destination"];
    origin = json["origin"];
    originLat = json["origin_lat"];
    originLon = json["origin_lon"];
    destinationLat = json["destination_lat"] is double
        ? (json["destination_lat"] as double).toString()
        : json["destination_lat"];
    destinationLon = json["destination_lon"] is double
        ? (json["destination_lon"] as double).toString()
        : json["destination_lon"];
    username = json["username"];
    driver = json["driver"];
    matchRate = json["match_rate"];
    createdAt = json["created_at"] != null
        ? (DateTime.parse(json["created_at"])).add(const Duration(hours: 3))
        : null;
    role = json["role"] != null ? convertStringToRole(json["role"]) : null;
    status =
        json["status"] != null ? convertStringToStatus(json["status"]) : null;
  }

  Role convertStringToRole(String roleStr) {
    if (roleStr == "passenger") {
      return Role.passenger;
    } else {
      return Role.driver;
    }
  }

  Status convertStringToStatus(String statusStr) {
    if (statusStr == "started") {
      return Status.started;
    } else if (statusStr == "ended") {
      return Status.ended;
    } else {
      return Status.pending;
    }
  }

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

  String createdAtToString() {
    return "${convertMonth(createdAt!.month)} ${createdAt!.day}, "
        "${createdAt!.year}, ${createdAt!.hour}:${createdAt!.minute}";
  }

  String convertMonth(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      default:
        return "December";
    }
  }

  @override
  String toString() {
    return 'Trip{id: $id, destination: $destination, '
        'route: ${route != null ? route![0] : null}, origin: $origin, '
        'originLat: $originLat, originLon: $originLon, '
        'destinationLat: $destinationLat, destinationLon: $destinationLon, '
        'userId: $userId, username: $username, driver: $driver, '
        'matchRate: $matchRate, createdAt: $createdAt, role: $role, '
        'status: $status}';
  }
}
