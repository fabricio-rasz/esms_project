import 'dart:async';

import 'package:esms_project/client.dart';
import 'package:esms_project/screens/listClients.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';

import 'clientDetail.dart';

class alterClient extends StatefulWidget {
  Client c;

  alterClient(this.c);
  @override
  _alterClientState createState() => _alterClientState();
}

class _alterClientState extends State<alterClient> {
  Timer d;
  final values = new List<TextEditingController>.generate(
      4, (_) => TextEditingController());
  final _formCli = GlobalKey<FormState>();

  @override
  void initState() {
    values[0].text = widget.c.name;
    values[1].text = widget.c.telephone;
    values[2].text = widget.c.cellular;
    values[3].text = widget.c.observations;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alterar Cliente"),
        ),
        body: _layout());
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        child: SingleChildScrollView(
            child: Column(
                children: [
                  Form(
                      key: _formCli,
                      child: Column(
                        children: [
                          InputValidado(
                            "Digite o nome do Cliente",
                            "Ex. João da Silva",
                            controller: values[0],
                          ),
                          InputTextosPhone(
                            "Digite um telefone",
                            "Ex. (15) 1234-5678",
                            controller: values[1],
                          ),
                          InputTextosPhone(
                            "Digite um celular",
                            "Ex. (15) 991234-5678",
                            controller: values[2],
                          ),
                          InputTextos(
                            "Observações:",
                            "Ex. Tem (15) 99123-4567 como outro número celular",
                            controller: values[3],
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Botoes(
                    "Atualizar cliente",
                    onPressed: _updateClient,
                  ),
                  Botoes(
                    "Remover cliente",
                    onPressed: () {
                      _removeClient();
                    },
                  )
                ]
            )
        ));
  }

  _updateClient() {
    setState(() {
      if (_formCli.currentState.validate()) {
        int temp = widget.c.id;
        widget.c = new Client(
          values[0].text,
          values[1].text,
          values[2].text,
          values[3].text,
        );
        widget.c.UpdateDB(temp);
        int StuckCount = 0;
        d = Timer(Duration(milliseconds: 300), () {
          if (widget.c.status == 1) {
            _showcontent(temp);
            StuckCount = 0;
            d.cancel();
          }
          else
            StuckCount++;
        });
        if (StuckCount >= 2)
          _displaySnackbar("Verifique os valores");
      }
    });
  }

  _displaySnackbar(String text) {
    setState(() {
      final snackBar =
      SnackBar(content: Text(text, style: TextStyle(fontSize: 16)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _showcontent(temp) {
    setState(() {
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Aviso'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text('Cliente atualizado.'),
                ],
              ),
            ),
            actions: [
              new TextButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  if(values[0].text == "CLIENTE_REMOVIDO")
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => ListClients()));
                  else {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => ListClients()));
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => ClientDetail(temp)));
                  }

                },
              ),
            ],
          );
        },
      );
    });
  }

  _removeClient() {
    setState(() {
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Confirmação'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text('Tem certeza que quer remover o cliente ${widget.c
                      .name}?'),
                ],
              ),
            ),
            actions: [
              new TextButton(
                child: new Text('Sim'),
                onPressed: () {
                  values[0].text = "CLIENTE_REMOVIDO";
                  values[1].text = "";
                  values[2].text = "";
                  values[3].text = "";
                  _updateClient();

                },
              ),
              new TextButton(
                child: new Text('Não'),
                onPressed: () {

                },
              ),
            ],
          );
        },
      );
    });
  }
}
