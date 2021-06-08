import 'dart:io';

import 'package:esms_project/client.dart';
import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/electronic.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_generate.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CreateEquipment extends StatefulWidget {
  Client c;
  CreateEquipment({this.c});
  @override
  _CreateEquipmentState createState() => _CreateEquipmentState();
}

class _CreateEquipmentState extends State<CreateEquipment> {
  final values = new List<TextEditingController>.generate(
      9, (_) => TextEditingController());
  List<String> imagens = [];
  List<Map<String, dynamic>> clients;
  Client c;
  bool _client = true;
  bool _justregistered = false;
  File _image;
  final _formEq = GlobalKey<FormState>();
  final _formCli = GlobalKey<FormState>();

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    c = widget.c == null? null: widget.c;
    if(c != null)
      {
        _client = true;
        _justregistered = true;
        values[3].text = c.name;
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Adicionar Aparelho"),
        ),
        body: _layout());
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                  text: "Preencha este formulário com informações do aparelho.",
                ),
                textAlign: TextAlign.center,
              ),
              Form(
                  key: _formEq,
                  child: Column(
                    children: [
                      InputValidado(
                        "Nome do Aparelho",
                        "Ex.: Radio Pioneer",
                        controller: values[0],
                      ),
                      InputValidado(
                        "Problema apresentado",
                        "Ex.: Tela quebrada",
                        controller: values[1],
                      ),
                      InputTextos(
                        "Observações",
                        "Ex.: Vem com cabos",
                        controller: values[2],
                      ),
                      InputData(
                        "Data de Entrada",
                        "Ex. " + DateFormat.yMd().format(DateTime.now()),
                        controller: values[8],
                      )
                    ],
                  )),
              Divider(
                color: Colors.transparent,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                  text: "O cliente ja é cadastrado?",
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        groupValue: _client,
                        value: true,
                        onChanged: _onChangeClient,
                      ),
                      Text("Sim", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        groupValue: _client,
                        value: false,
                        onChanged: _onChangeClient,
                      ),
                      Text("Não", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              _clientCheck(),
              Divider(
                color: Colors.transparent,
              ),
              if (_justregistered == true)
                Column(
                  children: [
                    Botoes(
                      "Cadastrar Aparelho",
                      onPressed: _addEquipment,
                    ),
                    Botoes(
                      "Tire uma foto!",
                      onPressed: _snapPic,
                    ),
                  ],
                ),
              if (imagens != null && imagens.length > 0)
                Text("Você tirou " + imagens.length.toString() + " fotos.")
            ],
          ),
        ));
  }

  _onChangeClient(bool value) {
    setState(() {
      _client = value;
    });
  }

  Future<void> _GetClient() async {
    if (values[3] != null && values[3].text.isNotEmpty) {
      clients = await dbHandler.instance.queryByName("client", values[3].text);
      List<Map<String,dynamic>> temp = List.empty(growable: true);
      setState(() {
        if (clients != null) {
          for (int i = 0; i < clients.length; i++) {
            if (clients[i]['name'] != 'CLIENTE_REMOVIDO')
              temp.add(clients[i]);
          }
          clients = temp;
        }
        FocusScope.of(context).unfocus();
      });
    }
  }

  _clientCheck() {
    return _client
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: InputTextos(
                    "Buscar por nome",
                    "Ex. João da Silva",
                    controller: values[3],
                  )),
                  IconButton(onPressed: _GetClient, icon: Icon(Icons.search))
                ],
              ),
              if (clients != null)
                for (int i = 0; i < clients.length; i++)
                  Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.account_circle_rounded),
                            Text(
                              " Cliente: " + clients[i]['name'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ]),
                          Botoes("Selecionar", onPressed: () => _loadCli(i))
                        ],
                      ),
                    ],
                  ),
            ],
          )
        : Column(
            children: [
              Form(
                  key: _formCli,
                  child: Column(
                    children: [
                      InputValidado(
                        "Digite o nome do Cliente",
                        "Ex. João da Silva",
                        controller: values[4],
                      ),
                      InputTextosPhone(
                        "Digite um telefone",
                        "Ex. (15) 1234-5678",
                        controller: values[5],
                      ),
                      InputTextosPhone(
                        "Digite um celular",
                        "Ex. (15) 991234-5678",
                        controller: values[6],
                      ),
                      InputTextos(
                        "Observações:",
                        "Ex. Tem (15) 99123-4567 como outro número celular",
                        controller: values[7],
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
            ],
          );
  }

  _addClient() {
    setState(() {
      if (_formCli.currentState.validate()) {
        _client = true;
        c = new Client(
            values[4].text, values[5].text, values[6].text, values[7].text);
        c.SaveToDB();
        if (c.id != null || c.id != 0) {
          values[3].text = values[4].text;
          _displaySnackbar("Cliente cadastrado.");
          _justregistered = true;
        } else {
          _displaySnackbar("Erro no cadastro.");
        }
      } else {
        _displaySnackbar("Verifique o cadastro!");
      }
    });
  }

  bool _ValidateInputs() {
    setState(() {});
    return _formEq.currentState.validate() && c != null;
  }

  Future<void> _snapPic() async {
    if (_ValidateInputs()) {
      Directory dir = await getApplicationDocumentsDirectory();
      final imagem = await ImagePicker().getImage(source: ImageSource.camera);

      if (imagem != null) {
        setState(() {
          _image = File(imagem.path);
        });

        final fileName = StringGenerator().getRandomString(10) + ".jpg";
        final savedImage = await File(imagem.path).copy(
            '${dir.path}/Pictures/$fileName');
        if(savedImage != null) {
          imagens.add(fileName);
          _displaySnackbar("Foto adicionada com sucesso.");
        }
        }
      }
    }

  _displaySnackbar(String text) {
    setState(() {
      final snackBar =
          SnackBar(content: Text(text, style: TextStyle(fontSize: 16)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _addEquipment() {
    setState(() {
      if (_formEq.currentState.validate()) {
        Equipment e = new Equipment(
          c.id,
          values[0].text,
          values[1].text,
          values[2].text,
          DateFormat.yMd().parse(values[8].text),
        );
        e.AddImageAsRange(imagens);

        if (e.SaveToDB() == 1) {
          _displaySnackbar("Erro no cadastro!");
        } else {
          _displaySnackbar("Cadastrado com sucesso.");
          Navigator.of(context).pop();
        }
      }

    });
  }

  _loadCli(int index) {
    setState(() {
      values[3].text = clients[index]['name'].toString();
      c = Client.fromJson(clients[index]);
      clients = null;
      _justregistered = true;
    });
  }
}
