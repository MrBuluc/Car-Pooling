class Review {
  String? id;
  String? review;
  String? userId;
  String? reviewerId;
  String? tripId;
  String? username;
  String? reviewerUsername;

  Review(
      {this.id,
      this.review,
      this.userId,
      this.reviewerId,
      this.tripId,
      this.username,
      this.reviewerUsername});

  Review.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            review: json["review"],
            username: json["username"],
            reviewerUsername: json["reviewer_username"],
            tripId: json["trip_id"]);

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (review != null) "review": review,
        if (userId != null) "user_id": userId,
        if (reviewerId != null) "reviewer_id": reviewerId,
        if (tripId != null) "trip_id": tripId
      };

  @override
  String toString() {
    return 'Review{id: $id, review: $review, userId: $userId, '
        'reviewerId: $reviewerId, tripId: $tripId, username: $username, '
        'reviewerUsername: $reviewerUsername}';
  }
}
