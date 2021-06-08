import 'package:untitled2/models/user.dart';

class CalendarEventAttendee {
  String? uuid;
  User? user;
  String email;

  CalendarEventAttendee(this.email, {this.uuid, this.user});

  CalendarEventAttendee.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"],
        email = json["email"] {
    var _user = json["user"];
    if (_user != null) {
      user = User.fromJson(_user);
    }
  }
}
