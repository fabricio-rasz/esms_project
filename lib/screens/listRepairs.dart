import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:flutter/material.dart';
class ListRepairs extends StatefulWidget {
  @override
  _ListRepairsState createState() => _ListRepairsState();
}

class _ListRepairsState extends State<ListRepairs> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  List<Map<String, dynamic>> repList;

  Future<bool> _loadvars() async {
    dbh.queryOrdered("v_repair", "ASC", "name").then((value) {
      repList = value;
      setState(() {
        return true && repList != null;
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
        title: Text("Listagem de Reparos")
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
          else if (repList != null && repList.length != 0) {
            return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: repList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 90,
                      color: Colors.black12,
                      child: GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 18.0),
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                                        text: "Aparelho: " +
                                            '${repList[index]['name']}')),
                              ],
                            ),
                            Row(
                              children: [
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 18.0),
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                                        text: "Reparo: " +
                                            '${repList[index]['repair']}'))
                              ],
                            )
                          ],
                        ),
                        onTap: () =>
                            onPressWithArg(context, repList[index]['id']),
                      ));
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
                                    text: "Nenhum reparo cadastrado."),
                              ),
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
                                    text: "\nTente recarregar a tela."),
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

  _update(BuildContext context) {
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListRepairs()));
    });
  }

  onPressWithArg(context, int id) {
    setState(() {
      /*Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ClientDetail(id)))
          .whenComplete(_loadvars);*/
    });
  }
}
