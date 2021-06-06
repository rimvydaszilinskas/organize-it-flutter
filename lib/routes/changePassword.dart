import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

import 'createEvent.dart';

//possibly to be removed since reset password logic is not yet implemented
class PasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
  String currentPassword = "";
  String newPassword = "";

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    throw UnimplementedError();
  }
}