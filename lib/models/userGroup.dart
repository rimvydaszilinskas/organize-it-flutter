import 'package:untitled2/models/user.dart';

class UserGroup {
  String? uuid;
  String name;
  String? description;
  User creator;
  List<User>? users;

  UserGroup(this.name, this.creator, {this.uuid, this.description, this.users});

}