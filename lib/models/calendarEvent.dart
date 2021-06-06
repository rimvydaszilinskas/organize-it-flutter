import 'package:untitled2/models/calendarEventAttendee.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/models/userGroup.dart';

class CalendarEvent {
  String? uuid;
  String name;
  String? description;
  User? organizer;
  UserGroup? userGroup;
  List<String>? emails;
  List<CalendarEventAttendee>? attendees;
  DateTime? start;
  DateTime? end;

  CalendarEvent({
    this.name="",
    this.uuid,
    this.description,
    this.organizer,
    this.userGroup,
    this.emails,
    this.attendees,
    this.start,
    this.end
  });

  CalendarEvent.fromJson(Map<String, dynamic> json):
    uuid = json["uuid"],
    name = json["name"],
    description = json["description"],
    start = DateTime.parse(json["time_start"]),
    end = DateTime.parse(json["time_end"]),
    emails = json["emails"] {
      organizer = User.fromJson(json["organizer"]);

      List<CalendarEventAttendee> _attendees = [];
      var attendeesJson = json["attendees"];

      attendeesJson.forEach((element) {
        _attendees.add(CalendarEventAttendee.fromJson(element));
      });

      this.attendees = _attendees;
    }

  Map<String, dynamic> toCreateJson() {
    return {
      "name": this.name,
      "description": this.description,
      "emails": this.emails,
      "time_start": this.start != null ? this.start!.toIso8601String() : null,
      "time_end": this.end != null ? this.end!.toIso8601String(): null,
    };
  }
}