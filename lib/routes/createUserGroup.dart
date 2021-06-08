import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/models/userGroup.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

class CreateUserGroupRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateUserGroupRouteState();
  }
}

class _CreateUserGroupRouteState extends State<CreateUserGroupRoute> {
  final UserGroup _userGroup = UserGroup("", User());
  List<String> emails = [];
  DateTime _lastInputTime = DateTime.now();
  List<String> selected = [];
  TextEditingController? _autocompleteEditingController;

  void _handleGroupNameChange(String name) {
    _userGroup.name = name;
  }

  List<Widget> getMembers() {
    List<Widget> list = [];

    for (int i = 0; i < this.selected.length; i++) {
      var element = this.selected[i];

      list.add(
        ListTile(
          leading: Icon(Icons.person),
          title: Text(element),
          onLongPress: () {
            this.setState(() {
              this.selected.removeAt(i);
              this._userGroup.emails = this.selected;
            });
          },
        ),
      );
    }

    return list;
  }

  void createGroup(BuildContext context, AuthenticationUser user) {
    var headers = user.getAuthenticationHeaders();
    var url = Uri.parse("http://35.158.154.65/users/groups/");
    var client = http.Client();
    var data = json.encode(this._userGroup.toJson());
    headers["Content-Type"] = "application/json";

    client.post(url, headers: headers, body: data).then((response) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      if (response.statusCode != 201) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(buildError(jsonBody).toString()),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"),
                    )
                  ],
                ));
        return;
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text("User group created successfully"),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"),
                  )
                ],
              ));
    }, onError: (error) {
      throw error;
    });
  }

  Future<Null> _retrieveUsers(AuthenticationUser user, String lookup) async {
    var headers = user.getAuthenticationHeaders();
    var url = Uri.parse("http://35.158.154.65/users/?lookup=$lookup");
    var client = http.Client();

    var response = await client.get(url, headers: headers);

    if (response.statusCode != 200) {
      // throw an error here
      print("Error occurred");
      return;
    }

    List<dynamic> data = json.decode(response.body);

    List<String> emails = [];

    data.forEach((element) {
      emails.add(element["email"]);
    });

    this.setState(() {
      this.emails = emails;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create new user group"),
        actions: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Consumer<AuthenticationState>(
              builder: (context, state, widget) {
                return GestureDetector(
                  onTap: () {
                    this.createGroup(context, state.user!);
                  },
                  child: Icon(Icons.check),
                );
              },
            ),
          )
        ],
      ),
      body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(10.0),
          child: Consumer<AuthenticationState>(
            builder: (context, state, widget) {
              return ListView(
                children: [
                  getTextField(
                      this._handleGroupNameChange, "Group name", false),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Autocomplete<String>(
                    fieldViewBuilder: (context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      if (this._autocompleteEditingController == null) {
                        this._autocompleteEditingController =
                            textEditingController;
                      }
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: getTextFieldDecorations("Email"),
                      );
                    },
                    optionsBuilder: (TextEditingValue value) {
                      this._lastInputTime = DateTime.now();
                      if (value.text == "") {
                        return [];
                      } else {
                        Future.delayed(Duration(milliseconds: 500), () {
                          if (DateTime.now()
                                  .difference(this._lastInputTime)
                                  .inMilliseconds >
                              500) {
                            this._retrieveUsers(state.user!, value.text);
                          }
                        });
                      }
                      return this.emails;
                    },
                    onSelected: (String selection) {
                      if (this.selected.contains(selection)) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("$selection is already added"),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"),
                                    ),
                                  ],
                                ));
                        return;
                      }
                      this.selected.add(selection);
                      this.setState(() {
                        this._userGroup.emails = this.selected;
                      });
                      if (this._autocompleteEditingController != null)
                        this._autocompleteEditingController!.text = "";
                    },
                  ),
                  ...this.getMembers(),
                ],
              );
            },
          )),
    );
  }
}
