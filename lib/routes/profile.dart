import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

import 'createEvent.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!this.loaded) {
      AuthenticationState state = Provider.of<AuthenticationState>(context);
      this._usernameController.text = state.user!.username != null ? state.user!.username! : "not set";
      this._firstnameController.text = state.user!.firstName != null ? state.user!.firstName! : "not set";
      this._lastnameController.text = state.user!.lastName != null ? state.user!.lastName! : "not set";
      this._emailController.text = state.user!.email != null ? state.user!.email! : "not provided";
      this.loaded = true;
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: (){
              print("tap");
              print(this._firstnameController.text);
              // TODO implement me pls!
            },
            child: Icon(Icons.check),
          )
          )
        ],
      ),
          body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            TextField(
              controller: _firstnameController,
              decoration: getTextFieldDecorations("firstname"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _lastnameController,
              decoration: getTextFieldDecorations("lastname"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _usernameController,
              decoration: getTextFieldDecorations("username"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              focusNode: AlwaysDisabledFocusNode(),
              controller: _emailController,
              decoration: getTextFieldDecorations("email"),
            ),
          ],
        ),
    ),
    );
  }
}