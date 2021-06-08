import 'dart:io';

import 'package:esms_project/listEquipmentMain.dart';
import 'package:esms_project/screens/aboutESMS.dart';
import 'package:esms_project/screens/createClient.dart';
import 'package:esms_project/screens/createEquipment.dart';
import 'package:esms_project/screens/listClients.dart';
import 'package:esms_project/screens/listRepairs.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  String verNumber;
  int superCoolSecret = 0;
  @override
  void initState() {
    super.initState();
    makeFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _layout());
  }

  makeFolders() async {
    final _self = await getApplicationDocumentsDirectory();
    final _selfPictures = Directory('${_self.path}/Pictures');
    if (!await _selfPictures.exists()) {
      final _newFolder = await _selfPictures.create(recursive: true);
    }
    PackageInfo.fromPlatform().then((PackageInfo p) {
      verNumber = p.version;
    });
  }

  _layout() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: SizedBox(
                    child: Column(
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.black,
                                fontSize: 100),
                            text: "ESMS")),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 12),
                          text: "Eletronics Servicing Management System"),
                    )
                  ],
                )),
                onTap: () {
                  setState(() {
                    if (superCoolSecret < 4) superCoolSecret++;
                  });
                },
                onLongPressUp: () {
                  setState(() {
                    if (superCoolSecret >= 4) _goto(context, AboutScr());
                  });
                },
              ),
              Divider(
                color: Colors.black38,
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BotaoCustom(
                      "Cadastrar Cliente",
                      onPressed: () => _goto(context, CreateClient()),
                    ),
                    BotaoCustom("Cadastrar Aparelho",
                        onPressed: () => _goto(context, CreateEquipment())),
                    BotaoCustom("Ver Aparelhos",
                        onPressed: () => _goto(context, listEquipmentMain())),
                    BotaoCustom("Ver Clientes",
                        onPressed: () => _goto(context, ListClients())),
                    BotaoCustom("Ver Reparos",
                        onPressed: () => _goto(context, ListRepairs())),
                  ],
                ),
              ),
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
}
