import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Build TextField widget with passed through parameters
/// Only change the styling here to apply in all input fields
Widget? getTextField(
    ValueChanged<String> onChange, String label, bool? obscure) {
  if (obscure == null) {
    obscure = false;
  }

  return TextField(
    obscureText: obscure,
    onChanged: onChange,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: label
    ),
  );
}
