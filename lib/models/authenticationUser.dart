import 'package:untitled2/models/user.dart';

/// User model for authentication state
class AuthenticationUser extends User {
  String? token;

  AuthenticationUser(this.token, {
    String? email,
    String? username,
    String? firstName,
    String? lastName
  }): super(
      email: email,
      username: username,
      lastName: lastName,
      firstName: firstName
  );

  AuthenticationUser.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    this.token = json["token"];
  }

  Map<String, String> getAuthenticationHeaders() {
    return {
      "Authorization": "Token ${this.token}",
    };
  }

}