import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/screens/authentication.dart';
import 'package:untitled2/screens/event_list.dart';
import 'package:untitled2/state/authentication.dart';

MultiProvider getApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthenticationState()),
    ],
    child: OrganizeItApp(),
  );
}

class OrganizeItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Organize It",
      home: Consumer<AuthenticationState>(
        builder: (context, state, child) {
          print("the state of the app is ${state.authenticated}");
          if (!state.authenticated)
            return AuthenticationPage();
          return Scaffold(
            appBar: AppBar(
              title: Text("Organize it"),
            ),
            body: Consumer<AuthenticationState>(
              builder: (context, state, child) {
                return Column(
                  children: [
                    Consumer<AuthenticationState>(
                      // builder: (ctx, state, child) => Text("What is the state of app? ${state.authenticated}"),
                      builder: (ctx, state, child) => EventListPage(),
                    ),
                    Consumer<AuthenticationState>(
                      builder: (ctx, state, child) => TextButton(onPressed: () => state.invertState(), child: Text("Invert state")),
                    )
                  ],
                );
              },
            ),
          );
        },
      )
    );
  }
}