import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/screens/clientDetail.dart';
import 'package:esms_project/screens/createClient.dart';
import 'package:flutter/material.dart';
import 'package:esms_project/widgets/widget_button.dart';

class ListClients extends StatefulWidget {
  @override
  _ListClientsState createState() => _ListClientsState();
}

class _ListClientsState extends State<ListClients> {
  final dbHandler dbh = dbHandler.instance;
  Future<bool> loaded;
  List<Map<String, dynamic>> cliList = List.empty(growable: true);

  Future<bool> _loadvars() async {
    cliList = List.empty(growable: true);
    dbh.queryOrdered("client", "ASC", "name").then((value) {
      List<Map<String,dynamic>> tmp = value;
      for(int i = 0; i < tmp.length; i++)
        {
          if(tmp[i]['name'] != "CLIENTE_REMOVIDO")
            {
              cliList.add(tmp[i]);
            }
        }
      setState(() {
        return true && cliList != null;
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
        title: Text("Listagem de Clientes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              setState(() {
                Navigator.of(context)
                    .push(new MaterialPageRoute(
                        builder: (context) => CreateClient()))
                    .whenComplete(_loadvars);
              });
            },
          )
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
          else if (cliList != null && cliList.length != 0) {
            return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: cliList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 90,
                      color: Colors.black12,
                      child: InkWell(
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
                                          text: "Cliente: " +
                                              '${cliList[index]['name']}')),
                                ],
                              ),
                              Row(
                                children: [
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 18.0),
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                                          text: "Celular: " +
                                              '${cliList[index]['cellular']}'))
                                ],
                              )
                            ],
                          ),
                        onTap: () =>
                            onPressWithArg(context, cliList[index]['id']),
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
                                      "Cadastre um cliente clicando no botão "),
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

  _update(BuildContext context) {
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListClients()));
    });
  }

  onPressWithArg(context, int id) {
    setState(() {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ClientDetail(id)))
          .whenComplete(_loadvars);
    });
  }
}
