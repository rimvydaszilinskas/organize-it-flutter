class User {
  String? uuid;
  String? email;
  String? firstName;
  String? lastName;
  String? username;

  User.empty();

  User({this.uuid, this.email, this.username, this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        firstName = json["first_name"],
        lastName = json["last_name"],
        username = json["username"];

  String getFullName() {
    if (this.firstName != null &&
        this.firstName != "" &&
        this.lastName != null &&
        this.lastName != "") {
      return "${this.firstName} ${this.lastName}";
    }
    return this.email.toString();
  }
}
