import 'dart:async';

import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/client.dart';
import 'package:esms_project/screens/alterClient.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'listEquipmentByClient.dart';

class ClientDetail extends StatefulWidget {
  final int id;
  ClientDetail(this.id);

  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  Timer stuck;
  Client cli;

  Future<bool> _loadvars() async {
    Future<List<Map<String, dynamic>>> tmp = dbh.queryByID("client", widget.id);
    tmp.then((List<Map<String, dynamic>> value) {
      cli = Client.fromJson(value[0]);
    });
    return true && cli != null;
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    loaded = _loadvars();
  }

  _reload() {
    stuck = Timer(Duration(seconds: 2), () {
      loaded = _loadvars();
      stuck.cancel();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Cliente"),
      ),
      body: _layout(),
    );
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(30),
        child: FutureBuilder<bool>(
            future: loaded,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  cli != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.account_circle),
                              title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 16.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      text: cli.name)),
                            ),
                            ListTile(
                                leading: const Icon(Icons.phone),
                                title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    text: "Telefone: ${cli.telephone}",
                                  ),
                                ),
                                onTap: () =>
                                    _launchUrl("tel:${cli.telephone}")),
                            ListTile(
                                leading: Icon(Icons.phone_android),
                                title: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        text: "Celular: ${cli.cellular}")),
                                onTap: () => _launchUrl("tel:${cli.cellular}")),
                            ListTile(
                              leading: Icon(Icons.notes),
                              title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      text:
                                          "Observações: ${cli.observations}")),
                              onTap: () => _modal(
                                  cli.observations, "Observações", Icons.notes),
                            ),
                          ]),
                    ),
                    Botoes(
                      "Alterar",
                      onPressed: _update,
                    ),
                    Botoes(
                      "Ver Aparelhos",
                      onPressed: () => _list(cli.id),
                    ),
                  ],
                );
              }
              if (snapshot.data == false) {
                _reload();
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text("Carregando.")],
                ),
              );
            }));
  }

  _modal(String value, String type, IconData icon) {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              semanticLabel: type,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon),
                    Text(type),
                  ],
                ),
                Divider(color: Colors.black38),
                RichText(
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        text: value)),
                Botoes(
                  "Fechar",
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ));
  }

  _launchUrl(String url) async {
    await canLaunch(url) ? await launch(url) : print("Uh-oh!");
  }

  _update() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => alterClient(cli)))
        .whenComplete(_reload);
  }

  _list(int id) {
    setState(() {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => listEquipmentClient(id_client: widget.id,)))
          .whenComplete(_loadvars);
    });
  }
}
