import 'package:car_pooling/ui/const.dart';

class Review {
  String? id;
  String? review;
  String? userId;
  String? reviewerId;
  String? tripId;
  String? username;
  String? reviewerUsername;
  DateTime? createdAt;
  String? driverTripId;

  Review(
      {this.id,
      this.review,
      this.userId,
      this.reviewerId,
      this.tripId,
      this.username,
      this.reviewerUsername,
      this.createdAt,
      this.driverTripId});

  Review.fromJson(Map<String, dynamic> json)
      : this(
            review: json["review"],
            reviewerUsername: json["reviewer_username"],
            createdAt: DateTime.parse(json["created_at"]));

  Map<String, dynamic> toJson() => {
        if (review != null) "review": review,
        if (userId != null) "user_id": userId,
        if (reviewerId != null) "reviewer_id": reviewerId,
        if (tripId != null) "trip_id": tripId,
        if (driverTripId != null) "driver_trip_id": driverTripId
      };

  String createdAtToString() =>
      "${convertMonth(createdAt!.month)} ${createdAt!.year}";

  @override
  String toString() {
    return 'Review{id: $id, review: $review, userId: $userId, '
        'reviewerId: $reviewerId, tripId: $tripId, username: $username, '
        'reviewerUsername: $reviewerUsername, driverTripId: $driverTripId}';
  }
}
