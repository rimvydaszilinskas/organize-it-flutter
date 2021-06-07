import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/userGroup.dart';
import 'package:untitled2/state/authentication.dart';

class UserGroupsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserGroupsPageState();
  }
}

class _UserGroupsPageState extends State<UserGroupsPage> {
  List<UserGroup> userGroups = [];

  Future<List> _retrieveGroups(AuthenticationUser user) async {
    var uri = Uri.parse("http://35.158.154.65/users/groups/");
    var client = http.Client();

    var response = await client.get(uri, headers: user.getAuthenticationHeaders());

    if (response.statusCode != 200) {
      throw Exception("retrieved bad response: ${response.statusCode} with body: ${response.body}");
    }

    List<dynamic> data = json.decode(response.body);
    var mappedData = data.map((e) => e as Map<String, dynamic>);
    var groups = <UserGroup>[];

    mappedData.forEach((element) {
      var group = UserGroup.fromJson(element);
      groups.add(group);
    });

    this.setState(() {
      this.userGroups = groups;
    });

    return groups;
  }

  List<Widget> _getGroups(AuthenticationUser user, BuildContext context) {
    this._retrieveGroups(user).then((value) => {}, onError: (error) {
      print(error);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred retrieving user groups"),
            actions: [
              MaterialButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    });

    List<Widget> widgets = [];

    this.userGroups.forEach((userGroup) {
      if (widgets.length != 0) {
        widgets.add(
          Divider(
            thickness: 2,
          )
        );
      }
      widgets.add(Text(
        userGroup.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ));
      if(userGroup.users != null){
        userGroup.users!.forEach((user) {
          widgets.add(
            ListTile(
              leading: Icon(Icons.person),
              title: Text(user.getFullName()),
            )
          );
        });
      }
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("User groups"),
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10.0),
        child: Consumer<AuthenticationState>(
          builder: (context, state, child) {
            return ListView(
              children: _getGroups(state.user!, context),
            );
          },
        ),
      ),
    );
  }
}