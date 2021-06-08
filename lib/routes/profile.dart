import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/user.dart';
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

  Future<User> _attemptSave(AuthenticationUser authenticationUser) async {
    var data = {
      "username": this._usernameController.text,
      "first_name": this._firstnameController.text,
      "last_name": this._lastnameController.text,
    };

    var url = Uri.parse("http://35.158.154.65/users/self/");
    var client = http.Client();
    var headers = authenticationUser.getAuthenticationHeaders();

    var response = await client.patch(url, headers: headers, body: data);

    Map<String, dynamic> jsonBody = json.decode(response.body);

    if (response.statusCode != 200) {
      throw buildError(jsonBody);
    }

    return User.fromJson(jsonBody);
  }

  @override
  Widget build(BuildContext context) {
    if (!this.loaded) {
      AuthenticationState state = Provider.of<AuthenticationState>(context);
      this._usernameController.text =
          state.user!.username != null ? state.user!.username! : "";
      this._firstnameController.text =
          state.user!.firstName != null ? state.user!.firstName! : "";
      this._lastnameController.text =
          state.user!.lastName != null ? state.user!.lastName! : "";
      this._emailController.text = state.user!.email!;
      this.loaded = true;
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        actions: [
          Consumer<AuthenticationState>(builder: (context, state, widget) {
            return Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    this._attemptSave(state.user!).then((value) {
                      state.setUser(value);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Success"),
                                content: Text("Profile successfully updated"),
                                actions: [
                                  MaterialButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              ));
                    }, onError: (error) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception: ", "")),
                                actions: [
                                  MaterialButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              ));
                    });
                  },
                  child: Icon(Icons.check),
                ));
          }),
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
