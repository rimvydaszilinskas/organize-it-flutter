import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/routes/createEvent.dart';
import 'package:untitled2/screens/authentication.dart';
import 'package:untitled2/screens/event_list.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/sideMenu.dart';

/// Initialize provider with a new instance of Authentication state
/// with a OrganizeIt main scaffolds from OrganizeItApp widget
MultiProvider getApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthenticationState()),
    ],
    child: OrganizeItApp(),
  );
}

/// OrganizeItApp is the entry widget of the application
class OrganizeItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "OrganizeIT",
      home: Consumer<AuthenticationState>(
        builder: (context, state, child) {
          // if the state is not authenticated, render authentication widget
          if (!state.authenticated)
            return AuthenticationPage();
          // otherwise return the application scaffold
          return Scaffold(
            drawer: SideMenu(),
            appBar: AppBar(
              title: Text("OrganizeIT"),
            ),
            body: Consumer<AuthenticationState>(
              builder: (context, state, child) {
                return Column(
                  children: [
                      EventListPage(),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateEventRoute())
                );
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}