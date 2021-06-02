import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/calendarEvent.dart';
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
      widgets.add(Text("Event ${element.name}"));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Consumer<AuthenticationState>(
        builder: (context, state, child) {
          if (!this.loaded)
            _getCalendarEvents(state.user!);
          return Stack(
            children: _getEventList(),
          );
        }
      ),
    );
  }
}