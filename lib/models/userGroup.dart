import 'package:untitled2/models/user.dart';

class UserGroup {
  String? uuid;
  String name;
  String? description;
  User creator;
  List<User>? users;
  List<String>? emails;

  UserGroup(this.name, this.creator, {this.uuid, this.description, this.users});

  UserGroup.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"],
        name = json["name"],
        description = json["description"],
        creator = User.fromJson(json["creator"]) {
    List<User> users = [];
    var retrievedUsers = json["users"];

    retrievedUsers.forEach((user) {
      users.add(User.fromJson(user));
    });

    this.users = users;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "emails": this.emails != null ? this.emails : []
    };
  }
}
