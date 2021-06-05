import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/widgets/textFields.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String username = "";

  void _handleFirstName(String firstName) {
    this.firstName = firstName;
  }

  void _handleLastName(String lastName) {
    this.lastName = lastName;
  }

  void _handleEmail(String email) {
    this.email = email;
  }

  void _handlePassword(String password) {
    this.password = password;
  }

  void _handleUsername(String username) {
    this.username = username;
  }

  void _submit() async {
    var uri = Uri.parse("http://35.158.154.65/users/register/");
    var client = http.Client();

    var response = await client.post(uri, body: {
      "email": this.email,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "password": this.password,
      "username": this.username,
    });

    if (response.statusCode != 201) {
      print("gotten ${response.statusCode}");
      print(response.body);
      // TODO show registration was unsuccessful
    }

    print(response.statusCode);

    print("$firstName, $lastName, $email, $password");

    // TODO show registration was successfull
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
              "Register",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: getTextField(_handleEmail, "Email", false),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: getTextField(_handleFirstName, "First Name", false),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: getTextField(_handleLastName, "Last Name", false),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: getTextField(_handleUsername, "Username", false),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: getTextField(_handlePassword, "Password", true),
          ),
          MaterialButton(
            onPressed: _submit,
            textColor: Colors.blue,
            child: Text("Register"),
          )
        ],
      ),
    );
  }
}