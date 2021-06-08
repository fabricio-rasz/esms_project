import 'package:esms_project/client.dart';
import 'package:esms_project/screens/listClients.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';
class CreateClient extends StatefulWidget {
  @override
  _CreateClientState createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  final values = new List<TextEditingController>.generate(
      4, (_) => TextEditingController());
  Client c;
  final _formCli = GlobalKey<FormState>();

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Adicionar Cliente"),
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
              "Cadastrar cliente",
              onPressed: _addClient,
            )
            ]
        )
        ));
  }

  _addClient() {
    setState(() {
      if (_formCli.currentState.validate()) {
        c = new Client(
            values[0].text, values[1].text, values[2].text, values[3].text);
        c.SaveToDB();
        if (c.id != null || c.id != 0) {
          _displaySnackbar("Cliente cadastrado.");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ListClients()));
        } else {
          _displaySnackbar("Erro no cadastro.");
        }
      } else {
        _displaySnackbar("Verifique o cadastro!");
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
}
