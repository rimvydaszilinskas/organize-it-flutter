import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

class InvitePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvitePageState();
  }
}

class _InvitePageState extends State<InvitePage> {
  String email = "";

  void setEmail(String email) {
    this.email = email;
  }

  void _sendInvite(BuildContext context, AuthenticationUser user) {
    var headers = user.getAuthenticationHeaders();
    var url = Uri.parse("http://35.158.154.65/users/invitations/");
    var client = http.Client();
    var data = {
      "email": this.email,
    };

    client.post(url, headers: headers, body: data).then((response) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      if (response.statusCode != 201) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(buildError(jsonBody).toString()),
                actions: [
                  MaterialButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Invitation sent successfully to ${this.email}"),
              actions: [
                MaterialButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO build view
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite friend"),
        actions: [
          Consumer<AuthenticationState>(builder: (context, state, widget) {
            return Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  this._sendInvite(context, state.user!);
                },
                child: Icon(Icons.check),
              )

            );
          })
        ],
      ),
      body: Text("invite friends"),
    );
  }
}
