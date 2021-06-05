class UserCalendar {
  String name;

  UserCalendar(this.name);

  UserCalendar.fromJson(Map<String, dynamic> data):
    name = data["name"];
}
