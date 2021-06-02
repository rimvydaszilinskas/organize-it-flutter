import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/models/authenticationUser.dart';

class AuthenticationState extends ChangeNotifier {
  bool authenticated = true;
  AuthenticationUser? user;
  String? errorMessage;

  AuthenticationState() {
  //  TODO attempt retrieving tokens from local memory
  }

  void invertState() {
    authenticated = !authenticated;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    this.errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    this.errorMessage = null;
    notifyListeners();
  }

  void _loginUser(Map<String, dynamic> userData) {
    this.user = AuthenticationUser.fromJson(userData);
    // TODO store token in local memory
    this.clearErrorMessage();
    this.invertState();
  }

  void attemptLogin(String email, password) {
    var url = Uri.parse("http://35.158.154.65/users/login/");
    var client = http.Client();

    client.post(url, body: {
      "email": email,
      "password": password,
    }).then((response) {
      try {
        Map<String, dynamic> jsonBody = json.decode(response.body);

        if (response.statusCode != 201) {
          this.setErrorMessage("Wrong/bad credentials provided");
          return;
        }

        this._loginUser(jsonBody);
      } catch (exception) {
        throw exception;
      }
    }, onError: (error) {
      // TODO show login error message to the user
      print(error);
    });
  }
}