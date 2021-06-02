import 'package:untitled2/models/user.dart';
import 'package:untitled2/models/userGroup.dart';

class CalendarEvent {
  String? uuid;
  String name;
  String? description;
  User? organizer;
  UserGroup? userGroup;
  List<String>? emails;
  List<User>? attendees;

  CalendarEvent(this.name, {
    this.uuid,
    this.description,
    this.organizer,
    this.userGroup,
    this.emails,
    this.attendees,
  });

  CalendarEvent.fromJson(Map<String, dynamic> json):
    uuid = json["uuid"],
    name = json["name"],
    description = json["description"],
    emails = json["emails"] {
    organizer = User.fromJson(json["organizer"]);
  }


}