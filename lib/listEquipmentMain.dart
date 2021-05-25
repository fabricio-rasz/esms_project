import 'package:esms_project/screens/listEquipment.dart';
import 'package:esms_project/screens/listEquipmentByClient.dart';
import 'package:esms_project/screens/listEquipmentByID.dart';
import 'package:esms_project/screens/listEquipmentDelivered.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';

class listEquipmentMain extends StatefulWidget {
  @override
  _listEquipmentMainState createState() => _listEquipmentMainState();
}
// TODO: Tela pesquisar via cliente
// Polir
class _listEquipmentMainState extends State<listEquipmentMain> {
  final _formCli = GlobalKey<FormState>();
  final _formCli2 = GlobalKey<FormState>();
  TextEditingController input = TextEditingController();
  TextEditingController input2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _layout());
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 30),
                      text: "Listagem de Aparelhos")),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 20),
                      text: "Selecione uma das opções abaixo.")),
              Divider(),
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BotaoCustom(
                      "Por Cliente",
                      btn: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(Size.fromWidth(300)),
                      ),
                      onPressed: () => _modalInput("Digite um nome.",
                          "Ex. José da Silva"),
                    ),
                    BotaoCustom(
                      "Por Número",
                      btn: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(Size.fromWidth(300)),
                      ),
                      onPressed: () => _modalInputID("Digite um número.",
                          "Ex. 1123"),
                    ),
                    BotaoCustom(
                      "Aparelhos Entregues",
                      btn: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(Size.fromWidth(300)),
                      ),
                      onPressed: () => _goto(context, listEquipmentDelivered()),
                    ),
                    BotaoCustom("Aparelhos em Aberto",
                        btn: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(Size.fromWidth(300)),
                        ),
                        onPressed: () => _goto(context, listEquipment()))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _goto(context, page) {
    setState(() {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => page));
    });
  }

  _modalInputID(String label, String hint) {
    input.clear();
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.search),
                    Text("Filtro de Pesquisa"),
                  ],
                ),
                Divider(color: Colors.black38),
                Form(key: _formCli, child: InputNumber(label, hint, controller: input)),
                Botoes(
                  "Pesquisar",
                  onPressed: () => _validateSearchID(),
                ),
                Botoes(
                  "Fechar",
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ));
  }

  _modalInput(String label, String hint) {
    input2.clear();
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.search),
                Text("Filtro de Pesquisa"),
              ],
            ),
            Divider(color: Colors.black38),
            Form(key: _formCli2, child: InputValidado(label, hint, controller: input2)),
            Botoes(
              "Pesquisar",
              onPressed: () => _validateSearchClient(),
            ),
            Botoes(
              "Fechar",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            )
          ],
        ));
  }
  _validateSearchClient() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      if (_formCli2.currentState.validate()) {
        if (input2 != null) {
          String name = input2.text;
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => listEquipmentClient(
                    clientName: name,
                  )));
        }
      }
    });
  }

  _validateSearchID() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      if (_formCli.currentState.validate()) {
        if (input != null) {
          int goto = int.tryParse(input.text);
          input.clear();
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => listEquipmentID(goto)));
        }
      }
    });
  }
}
