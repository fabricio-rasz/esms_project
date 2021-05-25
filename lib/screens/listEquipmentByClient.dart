import 'dart:async';

import 'package:esms_project/client.dart';
import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/screens/createEquipment.dart';
import 'package:esms_project/screens/equipmentDetail.dart';
import 'package:flutter/material.dart';
import 'package:esms_project/electronic.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:intl/intl.dart';

class listEquipmentClient extends StatefulWidget {
  int id_client;
  String clientName;
  listEquipmentClient({this.id_client,this.clientName});
  @override
  _listEquipmentClientState createState() => _listEquipmentClientState();
}

class _listEquipmentClientState extends State<listEquipmentClient> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  List<Map<String, dynamic>> eqList;
  Client c;
  int count = 0;
  Timer stuck;
  Future<bool> _loadvars() async {
    if(widget.id_client!=null) {
      widget.clientName = null;
      dbh.queryEquipmentClient(widget.id_client).then((value) {
        eqList = value;
      });
      dbh.queryByID("client", widget.id_client).then((value) {
        c = Client.fromJson(value[0]);
      });
    }
    if(widget.clientName != null)
      {
        widget.id_client = null;
        dbh.queryByName("v_equipment", widget.clientName).then((value) {
          eqList = value;
        });
      }
    setState(() {
      return true && eqList != null;
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  _reload() {
    if(count < 2)
      stuck = Timer(Duration(seconds: 1), () {
        if(eqList == null)
          loaded = _loadvars();
        stuck.cancel();
        count++;
        setState(() {});
      });
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
        title: Text("Aparelhos para Conserto"),
        actions: <Widget>[
          if(c != null)
          IconButton(
              onPressed: () => _addItem(context),
              icon: Icon(Icons.add_box_outlined))
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: FutureBuilder<bool>(
        future: loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (eqList != null && eqList.length > 0) {
            return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: eqList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 90,
                      color: Colors.black12,
                      child: GestureDetector(
                          child: Center(
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0),
                                                  text:
                                                  '${eqList[index]['equipment']}'))),
                                      Expanded(
                                          flex: 1,
                                          child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle:
                                              StrutStyle(fontSize: 18.0),
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0),
                                                  text:
                                                  '${eqList[index]['problem']}'))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle:
                                              StrutStyle(fontSize: 16.0),
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  text: "Data: " +
                                                      '${DateFormat.yMd().format(DateTime.tryParse(eqList[index]['dateInput']))}'))),
                                      Expanded(
                                          flex: 1,
                                          child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle:
                                              StrutStyle(fontSize: 16.0),
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  text: "Cliente: "+eqList[index]['name'])
                                          )
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                          onTap: () => onPressWithArg(
                            context,
                            eqList[index]['id'],
                          )));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider());
          }
          if (snapshot.data == null) {
            _reload();
          }
            return Container(
                child: Center(
                    child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        strutStyle: StrutStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.black26),
                            text: "Estou vazio!"),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              strutStyle: StrutStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black26),
                                  text:
                                      "Cadastre um aparelho clicando no botão "),
                            ),
                            Icon(
                              Icons.add_box_outlined,
                              color: Colors.black26,
                            ),
                          ]),
                      RichText(
                        strutStyle: StrutStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic),
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.black26),
                            text: "\nOu tente recarregar a tela."),
                      ),
                      Botoes(
                        "Recarregar",
                        onPressed: () => _update(context),
                      )
                    ],
                  ),
                )
              ],
            )));
          }
      ),
    );
  }

  _update(ctx) {
    setState(() {
      Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
              builder: (context) => listEquipmentClient(id_client: widget.id_client, clientName: widget.clientName,)));
    });
  }

  //
  void load(int arg) async {
    Equipment t = new Equipment(0, "", "", "", DateTime.now());
    t = await t.LoadFromDB(arg);
    print(t.toJson());
  }

  void onPressWithArg(ctx, int id) {
    setState(() {
      Navigator.of(ctx)
          .push(
              new MaterialPageRoute(builder: (context) => EquipmentDetail(id)))
          .whenComplete(_loadvars);
    });
  }

  _addItem(ctx) {
    setState(() {
      Navigator.of(ctx)
          .push(new MaterialPageRoute(builder: (context) => CreateEquipment(c: c)))
          .whenComplete(_loadvars);
    });
  }
}
