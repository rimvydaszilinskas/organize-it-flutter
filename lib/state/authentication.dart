import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/models/authenticationUser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled2/models/user.dart';

/// AuthenticationState is the main component for managing user authentication
/// with the remote API and local storage
class AuthenticationState extends ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String secureStorageAuthTokenKey = "authenticationToken";

  bool authenticated = false;
  AuthenticationUser? user;
  String? errorMessage;
  bool loading = false;

  AuthenticationState() {
    // Try loading the user from local storage if possible
    this._loadUser().then((user) {
      this.authenticated = true;
      this.user = user;
    }, onError: (error) {
      this.authenticated = false;
    });
  }

  void invertState() {
    authenticated = !authenticated;
    this.notifyListeners();
  }

  void setErrorMessage(String message) {
    this.errorMessage = message;
    this.notifyListeners();
  }

  void clearErrorMessage() {
    this.errorMessage = null;
    this.notifyListeners();
  }

  void setLoadingVariable(bool loading) {
    this.loading = loading;
    this.notifyListeners();
  }

  void setUser(User user) {
    this.user = AuthenticationUser.fromUser(user, this.user!.token!);
    this.notifyListeners();
  }

  User _loginUser(Map<String, dynamic> userData) {
    this.user = AuthenticationUser.fromJson(userData);

    this.clearErrorMessage();
    this.invertState();
    return this.user!;
  }

  /// Check local storage for user authentication token and check
  /// its validity against remote api server
  /// if token will be invalid, it will throw an exception
  Future<AuthenticationUser> _loadUser() async {
    String? value =
        await this.storage.read(key: this.secureStorageAuthTokenKey);

    if (value == null) {
      throw Exception("Storage was empty");
    }

    AuthenticationUser user = AuthenticationUser(value);

    var url = Uri.parse("http://35.158.154.65/users/self/");
    var client = http.Client();

    var response =
        await client.get(url, headers: user.getAuthenticationHeaders());

    if (response.statusCode != 200) {
      throw Exception("Error authenticating user. Got ${response.statusCode}");
    }

    Map<String, dynamic> jsonBody = json.decode(response.body);

    return AuthenticationUser.fromJson(jsonBody);
  }

  /// Try logging in user with email and password
  /// if unsuccessful an exception is going to be raised and an error message
  /// on the class will be set
  void attemptLogin(String email, password, BuildContext context) {
    var url = Uri.parse("http://35.158.154.65/users/login/");
    var client = http.Client();

    client.post(url, body: {
      "email": email,
      "password": password,
    }).then((response) {
      try {
        Map<String, dynamic> jsonBody = json.decode(response.body);

        if (response.statusCode != 201) {
          throw Exception();
        }

        // We are sure at this point that user is set and token will exist
        this._loginUser(jsonBody);
        this.storage.write(
            key: this.secureStorageAuthTokenKey, value: this.user!.token);
      } catch (exception) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Incorrect credentials"),
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
      }
    }, onError: (error) {
      this.setErrorMessage("Error authenticating user");
    });
  }

  /// Remove tokens from local storage and possibly destroy remote sessions
  void logout() {
    this.clearErrorMessage();
    this.user = null;
    this.authenticated = false;
    this.storage.delete(key: this.secureStorageAuthTokenKey);
    this.notifyListeners();
  }
}
