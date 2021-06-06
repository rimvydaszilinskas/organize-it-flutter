import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/routes/profile.dart';
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
              "OrganizeIT !",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_pin),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            }
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text("Change password"),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("User groups"),
          ),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text("New group"),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("invite friend(s)"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              state.logout();
            },
          ),
        ],
      ),
    );
  }
}
