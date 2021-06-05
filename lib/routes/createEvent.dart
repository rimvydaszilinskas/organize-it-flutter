import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateEventRouteState();
  }

}

class _CreateEventRouteState extends State<CreateEventRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new event"),
      ),
      body: Text("Hello world"),
    );
  }

}