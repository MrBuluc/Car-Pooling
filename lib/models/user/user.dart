class User {
  String? id;
  String? mail;
  String? name;
  String? surname;
  String? profilePictureUrl;

  User({this.id, this.mail, this.name, this.surname, this.profilePictureUrl});

  User.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            mail: json["mail"],
            name: json["name"],
            surname: json["surname"],
            profilePictureUrl: json["profilePictureUrl"]);

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (mail != null) "mail": mail,
        if (name != null) "name": name,
        if (surname != null) "surname": surname,
        if (profilePictureUrl != null) "profilePictureUrl": profilePictureUrl
      };

  String get username {
    String usernameStr = name!;
    if (surname != null) {
      usernameStr += " $surname";
    }
    return usernameStr;
  }

  @override
  String toString() {
    return 'User{id: $id, mail: $mail, name: $name, surname: $surname, '
        'profilePictureUrl: $profilePictureUrl}';
  }
}
