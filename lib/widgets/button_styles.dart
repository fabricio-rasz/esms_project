import 'package:flutter/material.dart';

class ButtonStyles {

  ButtonStyle btnS = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.redAccent[700], width: 1.2))),
      backgroundColor: MaterialStateProperty.all(Colors.redAccent),);
  TextStyle txS = TextStyle(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400);
}
