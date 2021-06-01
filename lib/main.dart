import 'package:esms_project/mainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  /* TODO: Consertos realizados em outros aparelhos parecidos? -- 01/06/2021, adicionado tabela
          TODO: Fazer telas relacionadas a tabela
            Vai pegar o nome do aparelho quando colocar data de entrega se o usuário quiser
            Pode deletar ou alterar informações de reparo*/
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

