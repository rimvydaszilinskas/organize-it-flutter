import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/calendarEvent.dart';
import 'package:untitled2/routes/createEvent.dart';
import 'package:untitled2/widgets/textFields.dart';

class EventRoute extends StatelessWidget {
  final CalendarEvent event;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  EventRoute({Key? key, required this.event}): super(key: key) {
    this._startDateController.text = formatDate(this.event.start!);
    this._endDateController.text = formatDate(this.event.end!);
    this._descriptionController.text = this.event.description != null ? this.event.description! : "Not provided";

  }

  List<Widget> getAttendeesList() {
    List<Widget> attendees = [];

    if (this.event.attendees != null) {
      this.event.attendees!.forEach((element) {
        attendees.add(ListTile(
          leading: Icon(Icons.person),
          title: Text(element.user != null ? element.user!.getFullName(): element.email),
        ));
      });
    }

    if (attendees.length == 0) {
      attendees.add(Text("Not listed"));
    }

    return attendees;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.event.name),
      ),
      body: Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: [
          TextField(
            focusNode: AlwaysDisabledFocusNode(),
            controller: _startDateController,
            decoration: getTextFieldDecorations("Start Time"),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          TextField(
            focusNode: AlwaysDisabledFocusNode(),
            controller: _endDateController,
            decoration: getTextFieldDecorations("End Time"),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text("organizer:"),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          ListTile(
          leading: Icon(Icons.person),
          title: Text(this.event.organizer != null ? this.event.organizer!.getFullName(): this.event.organizer!.email!),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          TextField(
            focusNode: AlwaysDisabledFocusNode(),
            controller: _descriptionController,
            maxLines: this.event.description != null ? "\n".allMatches(this.event.description!).length + 1 : 1,
            decoration: getTextFieldDecorations("event description"),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text("attendees:"),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          ...getAttendeesList(),
        ],
      )
    )
    );
  }


}
