import 'package:flutter/material.dart';

class ButtonStyles {

  ButtonStyle btnS = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.redAccent, width: 1.2))),
      backgroundColor: MaterialStateProperty.all(Colors.redAccent[700]),);
  TextStyle txS = TextStyle(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400);
}
