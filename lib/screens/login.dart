import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  bool submitted = false;

  void _usernameHandler(String username) {
    this.username = username;
  }

  void _passwordHandler(String password) {
    this.password = password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: getTextField(_usernameHandler, "Emwail", false),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: getTextField(_passwordHandler, "Password", true),
            ),
            Consumer<AuthenticationState>(
              builder: (context, state, child) {
                return MaterialButton(
                  onPressed: () {state.attemptLogin(username, password, context);},
                  textColor: Colors.blue,
                  child: Text("Login"),
                );
              },
            )
          ],
        ));
  }
}
