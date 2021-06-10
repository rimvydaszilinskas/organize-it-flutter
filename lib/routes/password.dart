import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

//screen to be created and linked with the logic
class PasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _repeatNewPasswordController = TextEditingController();
  bool loaded = false;

  void updatePassword(AuthenticationUser user, BuildContext context) {
    var uri = Uri.parse("http://35.158.154.65/users/password/");
    var client = http.Client();
    var headers = user.getAuthenticationHeaders();
    var body = {
      "current_password": this._currentPasswordController.text,
      "new_password": this._newPasswordController.text
    };

    client.patch(uri, headers: headers, body: body).then((response) {
      String message = "Password change successfully";
      bool exit = true;

      if (response.statusCode != 204) {
        Map<String, dynamic> jsonBody = json.decode(response.body);
        exit = false;
        message = buildError(jsonBody).toString();
      }

      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(exit ? "Success" : "Error"),
                content: Text(message),
                actions: [
                  MaterialButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (exit) Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }, onError: (error) {
      print(error);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 10.0)),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text("Enter your current password for profile security"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _currentPasswordController,
              decoration: getTextFieldDecorations("current password"),
              obscureText: true,
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            ListTile(
              leading: Icon(Icons.arrow_circle_down),
              title: Text("and set your new password below:"),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _newPasswordController,
              decoration: getTextFieldDecorations("new password"),
              obscureText: true,
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            TextField(
              controller: _repeatNewPasswordController,
              decoration: getTextFieldDecorations("repeat new password"),
              obscureText: true,
            ),
            Consumer<AuthenticationState>(
              builder: (context, state, widget) {
                return MaterialButton(
                  onPressed: () {
                    if (this._newPasswordController.text !=
                        this._repeatNewPasswordController.text) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Passwords do not match"),
                                actions: [
                                  MaterialButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    } else
                      this.updatePassword(state.user!, context);
                  },
                  child: Text("Confirm"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
