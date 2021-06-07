import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/authenticationUser.dart';
import 'package:untitled2/models/calendarEvent.dart';
import 'package:untitled2/routes/event.dart';
import 'package:untitled2/state/authentication.dart';
import 'package:untitled2/widgets/textFields.dart';

class CreateEventRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateEventRouteState();
  }
}

class _CreateEventRouteState extends State<CreateEventRoute> {
  final CalendarEvent _event = CalendarEvent();
  TextEditingController startDateController = TextEditingController()
    ..text = "Please select";
  TextEditingController endDateController = TextEditingController()
    ..text = "Please select";
  TextEditingController emailInputController = TextEditingController();
  bool selectGroup = false;

  void _handleTitleChange(String title) {
    _event.name = title;
  }

  void _handleDescriptionChange(String description) {
    _event.description = description;
  }

  void _addEmailToList() {
    this.setState(() {
      if (this._event.emails == null) {
        this._event.emails = [];
      }
      this._event.emails!.add(this.emailInputController.text);
      this.emailInputController.text = "";
    });
  }

  List<Widget> getEmailList() {
    List<Widget> list = [];

    if (this._event.emails == null) {
      return list;
    }

    for (int i = 0; i < this._event.emails!.length; i++) {
      var element = this._event.emails![i];

      list.add(
        ListTile(
          leading: Icon(Icons.person),
          title: Text(element),
          onTap: () {
            this.setState(() {
              this._event.emails!.removeAt(i);
            });
          },
        ),
      );
    }

    return list;
  }

  Future<DateTime?> _selectDate(BuildContext context,
      {DateTime? initial}) async {
    initial = initial != null ? initial : DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future<DateTime?> _selectDateAndTime(BuildContext context,
      {DateTime? initial}) async {
    final DateTime? datePicked = await _selectDate(context, initial: initial);
    final TimeOfDay? timePicked = await _selectTime(context);

    if (timePicked == null || datePicked == null) {
      return null;
    }

    return DateTime(datePicked.year, datePicked.month, datePicked.day,
        timePicked.hour, timePicked.minute);
  }

  Future<Null> _selectStartDateAndTime(BuildContext context) async {
    var dt = await _selectDateAndTime(context, initial: this._event.start);
    if (dt == null) {
      return;
    }
    this.setState(() {
      this._event.start = dt;
      this.startDateController.text = formatDate(dt);
    });
  }

  Future<Null> _selectEndDateAndTime(BuildContext context) async {
    var dt = await _selectDateAndTime(context, initial: this._event.end);
    if (dt == null) {
      return;
    }
    this.setState(() {
      this._event.end = dt;
      this.endDateController.text = formatDate(dt);
    });
  }

  Future<CalendarEvent> createEvent(AuthenticationUser user) async {
    var data = this._event.toCreateJson();
    String requestBody = json.encode(data);

    var url = Uri.parse("http://35.158.154.65/calendars/events/");
    var client = http.Client();

    var headers = user.getAuthenticationHeaders();

    var response = await client.post(url, headers: headers, body: requestBody);

    Map<String, dynamic> jsonBody = json.decode(response.body);

    if (response.statusCode != 201) {
      // Sanitize response by returning the first error existing in the response object
      throw buildError(jsonBody);
    }

    return CalendarEvent.fromJson(jsonBody);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create new event"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Consumer<AuthenticationState>(
                builder: (context, state, widget) {
                  return GestureDetector(
                    onTap: () {
                      this.createEvent(state.user!).then((event) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EventRoute(event: event)));
                      }, onError: (error) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception: ", "")),
                                actions: [
                                  MaterialButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      });
                    },
                    child: Icon(Icons.check),
                  );
                },
              ))
        ],
      ),
      // body:
      body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              getTextField(_handleTitleChange, "Title", false),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              getTextField(_handleDescriptionChange, "Description", false,
                  maxLines: 3),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              TextField(
                focusNode: AlwaysDisabledFocusNode(),
                onTap: () {
                  _selectStartDateAndTime(context);
                },
                controller: startDateController,
                decoration: getTextFieldDecorations("Start Date and Time"),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              TextField(
                focusNode: AlwaysDisabledFocusNode(),
                onTap: () {
                  _selectEndDateAndTime(context);
                },
                controller: endDateController,
                decoration: getTextFieldDecorations("End Date and Time"),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Select group"),
                  Switch(
                      value: this.selectGroup,
                      onChanged: (value) {
                        this.setState(() {
                          this.selectGroup = value;
                        });
                      }),
                ],
              )),
              !this.selectGroup
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        TextField(
                          controller: this.emailInputController,
                          decoration: getTextFieldDecorations("Email"),
                        ),
                        MaterialButton(
                          onPressed: _addEmailToList,
                          child: Text("Add Email"),
                        ),
                        ...this.getEmailList(),
                      ],
                    )
                  : Text("Select group"),
            ],
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
