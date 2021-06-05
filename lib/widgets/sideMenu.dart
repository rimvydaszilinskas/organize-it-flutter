import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/state/authentication.dart';

/// Side menu of the application
/// Accessible through the scaffold sidebar hamburger menu
class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationState state = Provider.of<AuthenticationState>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "Organize it!",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("User groups"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {state.logout();},
          ),
        ],
      ),
    );
  }
}