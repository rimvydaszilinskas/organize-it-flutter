import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/screens/login.dart';
import 'package:untitled2/screens/register.dart';
import 'package:untitled2/state/authentication.dart';

/// Container for both login and register components
class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Authentication"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.supervised_user_circle)),
              Tab(icon: Icon(Icons.group_add)),
            ],
          ),
        ),
        body: Consumer<AuthenticationState>(
          builder: (context, state, child) {
            return TabBarView(
              children: [
                LoginPage(),
                RegisterPage(),
              ],
            );
          },
        ),
      ),
    );
  }
}
