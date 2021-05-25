import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/screens/createEquipment.dart';
import 'package:esms_project/screens/equipmentDetail.dart';
import 'package:flutter/material.dart';
import 'package:esms_project/electronic.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:intl/intl.dart';

class listEquipment extends StatefulWidget {
  @override
  _listEquipmentState createState() => _listEquipmentState();
}

class _listEquipmentState extends State<listEquipment> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  List<Map<String, dynamic>> eqList;

  Future<bool> _loadvars() async {
    dbh.queryAllEquipment().then((value) {
      eqList = value;
      setState(() {
        return true && eqList != null;
      });
    });
    return false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aparelhos para Conserto"),
        actions: <Widget>[
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
          else if (eqList != null && eqList.length != 0) {
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
                                                      "Aparelho: "+'${eqList[index]['equipment']}'))),
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
                                                  text: "Cliente: " +
                                                      '${eqList[index]['name']}'))),
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
          } else {
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
        },
      ),
    );
  }

  _update(ctx) {
    setState(() {
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (context) => listEquipment()));
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
          .push(new MaterialPageRoute(builder: (context) => CreateEquipment()))
          .whenComplete(_loadvars);
    });
  }
}
