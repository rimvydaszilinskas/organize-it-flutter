import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/calendarEvent.dart';

class EventRoute extends StatelessWidget {
  final CalendarEvent event;

  EventRoute({Key? key, required this.event}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(this.event.name),
      ),
      body: Text("${this.event.description}"),
    );
  }


}
