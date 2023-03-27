class Vehicle {
  String? brand;
  String? color;
  String? id;
  String? model;
  String? plateNo;
  String? userId;

  Vehicle(
      {this.brand, this.color, this.id, this.model, this.plateNo, this.userId});

  Vehicle.fromJson(Map<String, dynamic> json)
      : this(
            brand: json["brand"],
            color: json["color"],
            id: json["id"],
            model: json["model"],
            plateNo: json["plate_number"],
            userId: json["user_id"]);

  Map<String, dynamic> toJson() => {
        if (brand != null) "brand": brand,
        if (color != null) "color": color,
        if (model != null) "model": model,
        if (plateNo != null) "plate_number": plateNo,
        if (userId != null) "user_id": userId
      };

  @override
  String toString() {
    return 'Vehicle{brand: $brand, color: $color, id: $id, model: $model, '
        'plateNo: $plateNo, userId: $userId}';
  }
}
