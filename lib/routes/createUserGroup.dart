import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/models/userGroup.dart';
import 'package:untitled2/routes/createEvent.dart';

// TODO implement me
class CreateUserGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateUserGroupState();
  }

}

class _CreateUserGroupState extends State<CreateEventRoute> {
  final UserGroup _userGroup = UserGroup("", User());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}