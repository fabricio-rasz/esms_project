import 'dart:async';

import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/electronic.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_caroussel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'alterEquipment.dart';

class EquipmentDetail extends StatefulWidget {
  final int id;
  EquipmentDetail(this.id);

  @override
  _EquipmentDetailState createState() => _EquipmentDetailState();
}

class _EquipmentDetailState extends State<EquipmentDetail> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  Timer stuck, d;
  bool openProblem = false;
  bool openObservation = false;
  Equipment eq;
  Repair r;
  Future<bool> _loadvars() async {
    dbh
        .queryByID("equipment", widget.id)
        .then((List<Map<String, dynamic>> value) {
      eq = Equipment.fromJson(value[0]);
    });
    dbh
        .queryByID("v_repair", widget.id)
        .then((List<Map<String, dynamic>> value) {
      r = Repair.fromView(value[0]);
    });

    return true && eq != null;
  }

  _reload() {
    stuck = Timer(Duration(seconds: 2), () {
      loaded = _loadvars();
      stuck.cancel();
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    loaded = _loadvars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Aparelho"),
      ),
      body: _layout(),
    );
  }

  _layout() {
    return Container(
        margin: EdgeInsets.all(10),
        child: FutureBuilder<bool>(
            future: loaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  eq != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 16.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      text: "N°" + eq.id.toString())),
                            ),
                            RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 16.0),
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    text: eq.name)),
                            Divider(color: Colors.black38),
                            Column(children: [
                              if (eq.images.length > 0)
                                eq.images[0].isNotEmpty
                                    ? SizedBox(
                                        height: 270,
                                        child: Caroussel(eq.images))
                                    : SizedBox(
                                        height: 170,
                                        child: Center(
                                          child: RichText(
                                              strutStyle:
                                                  StrutStyle(fontSize: 30.0),
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  text: "Sem Imagem")),
                                        )),
                            ]),
                            Divider(color: Colors.black38),
                            ListTile(
                              leading: const Icon(Icons.warning),
                              title: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  text: "Problema : " + '${eq.problem}',
                                ),
                              ),
                              onTap: () => _modal('${eq.problem}', "Problema",
                                  Icons.warning_amber_outlined),
                            ),
                            ListTile(
                              leading: Icon(Icons.info),
                              title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      text: "Observações : " +
                                          '${eq.observation}')),
                              onTap: () => _modal('${eq.observation}',
                                  "Observações", Icons.info_outline),
                            ),
                            ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text("Data de Entrada: " +
                                  '${DateFormat.yMMMd().format(eq.dateInput)}'),
                            ),
                            _Eval(),
                            Divider(color: Colors.black38),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Botoes(
                                  "Alterar",
                                  onPressed: _update,
                                ),
                                Botoes(
                                  "Remover",
                                  onPressed: _remove,
                                )
                              ],
                            ),
                            Divider(color: Colors.transparent),
                          ]),
                    ),
                  ],
                );
              }
              if (snapshot.data == false) {
                _reload();
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  _Eval() {
    return eq.dateExit != null
        ? ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text("Data de Entrega: " +
                '${DateFormat.yMMMd().format(eq.dateExit)}'))
        : Container(width: 0, height: 0);
  }

  _update() {
    setState(() {
      Navigator.of(context)
          .push(new MaterialPageRoute(
              builder: (context) => alterEquipment(eq, r: r)))
          .whenComplete(_reload);
    });
  }

  _remove() {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.warning_amber_outlined),
                    Text("Confirmação de Ação")
                  ],
                ),
                Divider(color: Colors.black38),
                RichText(
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        text: "Deseja realmente remover ${eq.name}?")
                ),
                Divider(color: Colors.transparent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Botoes("Sim", onPressed: (){
                      eq.RemoveDB(eq.id);
                      if(r != null)
                        r.RemoveDB(r.id);
                      d = Timer(Duration(milliseconds: 200), ()
                      {
                        if ((r != null && r.status == 1 && eq.status == 1) ||
                            (r == null && eq.status == 1)) {
                          d.cancel();
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        }
                      });
                      /**/
                    },),
                    Botoes("Não", onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                    },)
                  ],
                )
              ],
            )
    );
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
}
