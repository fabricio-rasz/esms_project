import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class AboutScr extends StatefulWidget {
  @override
  _AboutScrState createState() => _AboutScrState();
}

class _AboutScrState extends State<AboutScr> {
  PackageInfo p;
  String os;
  Future<bool> loaded;

  Timer stuck;
  Future<bool> loadVals() async {
    if(Platform.isAndroid)
      os = "Android";
    else if(Platform.isIOS)
      os = "IOS";
    os += ' ${Platform.operatingSystemVersion}';

    await PackageInfo.fromPlatform().then((value) {
      p = value;
    });
    return true && p != null;
  }

  _reload() {
    stuck = Timer(Duration(seconds: 2), () {
      loaded = loadVals();
      stuck.cancel();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loaded = loadVals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre"),
      ),
      body: _layout(),
    );
  }

  _layout() {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder<bool>(
          future: loaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (p != null) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.redAccent[700],
                                    fontSize: 12,
                                letterSpacing: 10),
                                text: "RELEASE CANDIDATE 1",),
                          ),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.black,
                                    fontSize: 100),
                                text: "ESMS"),
                          ),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 12),
                                text: "Eletronics Servicing Management System"),
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                text:
                                    "Informações da Versão"),
                          ),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Divider(color: Colors.transparent,),
                                Text("Versão: ${p.version}"),
                                Text("Número da Build: ${p.buildNumber}"),
                                Text("Nome da Package: ${p.packageName}"),
                                Text("Versão Dart: ${Platform.version.substring(0,Platform.version.lastIndexOf('(dev)'))}"),
                                Text("Edição ${os}")
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  Divider(color: Colors.transparent,),
                  Expanded(
                    flex: 1,
                    child: Text("Desenvolvido por F. Raszeja, 2021")
                  )
                ],
              ));
            }
            if (snapshot.data == false) {
              _reload();
            }
            return Container(
              child: Text("Oops!"),
            );
          }),
    );
  }
}
