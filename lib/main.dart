import 'package:esms_project/mainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  /* TODO: Consertos realizados em outros aparelhos parecidos?
  *  TODO: Como armezenar essas informações? */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESMS - Sistema para Técnicos em Eletrônica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: mainScreen(),
    );
  }
}

