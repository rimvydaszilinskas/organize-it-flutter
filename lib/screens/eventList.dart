import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/calendarEvent.dart';
import 'package:untitled2/routes/event.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/widgets/textFields.dart';

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
    List<dynamic> data = json.decode(response.body);

    if (response.statusCode != 200) {
      print("bad response ${response.statusCode}");
      // TODO display error
      return;
    }

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

    DateTime? lastInput;

    this.events.forEach((element) {
      var duration = element.end!.difference(element.start!);
      String formattedStartDate = formatDate(element.start!);
      String durationDisplay = "";

      if (duration.inMinutes % 60 != 0) {
        var durationMinutes = duration.inMinutes % 60;
        durationDisplay = "$durationMinutes minutes";
      }

      if (duration.inHours != 0) {
        durationDisplay = "${duration.inHours} hours $durationDisplay";
      }

      DateTime currentEventDate = DateTime(element.start!.year, element.start!.month, element.start!.day);
      if (lastInput != currentEventDate) {
        lastInput = currentEventDate;
        if (widgets.length != 0) {
          widgets.add(
            Divider(
              thickness: 2,
            )
          );
        }
        widgets.add(
          Text(
            "${formatOnlyDate(lastInput!)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      widgets.add(
        ListTile(
          leading: Icon(Icons.event),
          title: Text(element.name),
          subtitle: Text("at $formattedStartDate for $durationDisplay"),
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
          if (!this.loaded && state.authenticated) {
            _getCalendarEvents(state.user!);
          }
          return ListView(
            children: [
              MaterialButton(
                child: Text("Refresh"),
                onPressed: () {
                  this.setState(() {
                    this.loaded = false;
                  });
                },
              ),
              ..._getEventList(),
            ],
          );
        }
      ),
    );
  }
}