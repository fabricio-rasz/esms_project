import 'package:esms_project/listEquipmentMain.dart';
import 'package:esms_project/screens/createClient.dart';
import 'package:esms_project/screens/createEquipment.dart';
import 'package:esms_project/screens/listClients.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:flutter/material.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _layout());
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                    fontSize: 100
                ),
                text: "ESMS"
            )),
            RichText(text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                    fontSize: 30
                ),
                text: "Versão 1.0"
            )),
            Divider(),
            SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BotaoCustom("Cadastrar Cliente",btn: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(300)),
                  ),
                  onPressed: () => _goto(context, CreateClient()),),
                  BotaoCustom("Cadastrar Aparelho",btn: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(300)),
                  ),
                    onPressed: () => _goto(context, CreateEquipment())),
                  BotaoCustom("Ver Aparelhos",btn: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(300)),
                  ),
                      onPressed: () => _goto(context, listEquipmentMain())),
                  BotaoCustom("Ver Clientes",btn: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(300)),
                  ),
                      onPressed: () => _goto(context, ListClients()))
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  _goto(context, page) {
    setState(() {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => page));
    });
  }
}
