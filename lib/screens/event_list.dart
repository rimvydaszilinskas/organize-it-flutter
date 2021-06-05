import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/calendarEvent.dart';
import 'package:untitled2/routes/event.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:http/http.dart' as http;

class EventListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventListPageState();
  }
}

class _EventListPageState extends State<EventListPage> {
  List<CalendarEvent> events = [];
  bool loaded = false;

  void _getCalendarEvents(AuthenticationUser user) async {
    var uri = Uri.parse("http://35.158.154.65/calendars/events/");
    var client = http.Client();

    var response = await client.get(uri, headers: user.getAuthenticationHeaders());

    if (response.statusCode != 200) {
      print("bad response ${response.statusCode}");
      // TODO display error
      return;
    }

    List<dynamic> data = json.decode(response.body);

    var events = <CalendarEvent>[];
    var mappedData = data.map((e) => e as Map<String, dynamic>);

    mappedData.forEach((event) {
      var eventInstance = CalendarEvent.fromJson(event);
      events.add(eventInstance);
    });

    setState(() {
      this.events = events;
      this.loaded = true;
    });
  }

  List<Widget> _getEventList() {
    List<Widget> widgets = [];

    this.events.forEach((element) {
      widgets.add(
        ListTile(
          leading: Icon(Icons.storage),
          title: Text(element.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventRoute(event: element)
              ),
            );
          },
        )
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AuthenticationState>(
        builder: (context, state, child) {
          if (!this.loaded && state.authenticated)
            _getCalendarEvents(state.user!);
          return ListView(
            children: _getEventList(),
          );
        }
      ),
    );
  }
}