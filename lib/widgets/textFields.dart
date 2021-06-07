import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Build TextField widget with passed through parameters
/// Only change the styling here to apply in all input fields
Widget getTextField(ValueChanged<String> onChange, String label, bool? obscure,
    {maxLines = 1}) {
  if (obscure == null) {
    obscure = false;
  }

  return TextField(
    obscureText: obscure,
    onChanged: onChange,
    maxLines: maxLines,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        labelText: label),
  );
}

Widget getTextFieldContainer(
    ValueChanged<String> onChange, String label, bool? obscure,
    {maxLines = 1}) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: getTextField(onChange, label, obscure, maxLines: maxLines),
  );
}

InputDecoration getTextFieldDecorations(String label) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: label);
}
/// date formatting to year/month/day hour:minutes
String formatDate(DateTime dt) {
  return "${dt.year}/${dt.month.toString().padLeft(2, "0")}/${dt.day.toString().padLeft(2, "0")} ${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}";
}

String formatOnlyDate(DateTime dt) {
  return "${dt.year}/${dt.month.toString().padLeft(2, "0")}/${dt.day.toString().padLeft(2, "0")}";
}

Exception buildError(Map<String, dynamic> jsonBody) {
  var firstErrorKey = jsonBody.keys.first;
  var message = jsonBody[firstErrorKey];
  if (message is String) {
    return Exception("$firstErrorKey - $message");
  } else if (message is List) {
    return Exception("$firstErrorKey - ${message[0]}");
  }
  return Exception("Unknown error occurred");
}