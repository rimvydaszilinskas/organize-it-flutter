import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/models/authenticationUser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled2/models/user.dart';

/// AuthenticationState is the main component for managing user authentication
/// with the remote API and local storage
class AuthenticationState extends ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String SecureStorageAuthTokenKey = "authenticationToken";

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

  // TODO remove me when not needed
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
    String? value = await this.storage.read(key: this.SecureStorageAuthTokenKey);

    if (value == null) {
      throw Exception("Storage was empty");
    }

    AuthenticationUser user = AuthenticationUser(value);

    var url = Uri.parse("http://35.158.154.65/users/self/");
    var client = http.Client();

    var response = await client.get(url, headers: user.getAuthenticationHeaders());

    if (response.statusCode != 200) {
      throw Exception("Error authenticating user. Got ${response.statusCode}");
    }

    Map<String, dynamic> jsonBody = json.decode(response.body);

    return AuthenticationUser.fromJson(jsonBody);
  }

  /// Try logging in user with email and password
  /// if unsuccessful an exception is going to be raised and an error message
  /// on the class will be set
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

        // We are sure at this point that user is set and token will exist
        this._loginUser(jsonBody);
        this.storage.write(
            key: this.SecureStorageAuthTokenKey,
            value: this.user!.token
        );

      } catch (exception) {
        throw exception;
      }
    }, onError: (error) {
      print(error);
      this.setErrorMessage("Error authenticating user");
    });
  }

  /// Remove tokens from local storage and possibly destroy remote sessions
  void logout() {
    this.clearErrorMessage();
    this.user = null;
    this.authenticated = false;
    this.storage.delete(key: this.SecureStorageAuthTokenKey);
    this.notifyListeners();
  }
}