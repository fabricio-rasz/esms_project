import 'dart:async';

import 'package:esms_project/dbhandler.dart';
import 'package:esms_project/screens/equipmentDetail.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class InputTextos extends StatelessWidget {
  String rotulo, hint;
  TextEditingController controller;
  bool readonly;
  InputTextos(this.rotulo,this.hint, {this.controller, this.readonly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly == null ? false : readonly,
      controller: controller,
      style : TextStyle(
        color: Colors.black,
        backgroundColor: Colors.transparent
      ),
      decoration : InputDecoration(
        labelText: rotulo,
        hintText: hint
      )
    );
  }
}

class CustomSearch extends SearchDelegate{
  dbHandler dbh= dbHandler.instance;
  List<Map<String,dynamic>> loadList;
  int type;
  CustomSearch({this.type, this.loadList});
  @override
  List<Widget> buildActions(BuildContext context) {
    return[
        IconButton(onPressed: (){
            query = '';
        }, icon: Icon(Icons.clear))
    ];
  }
  @override
  String get searchFieldLabel => "Pesquisar";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.red,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        hintStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400),
      ),
        textTheme: TextTheme(headline6: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400),)
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          close(context, null);
          },
        icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String,dynamic>> searchList = List.empty(growable: true);

    if(query.length < 3)
      {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Termo deve ser maior que 2 letras.",
              ),
            )
          ],
        );
      }

    for(int i = 0; i < loadList.length; i++)
    {
      switch(type)
      {
        case 0:
          {
            if(loadList[i]['name'].contains(query)){
              searchList.add(loadList[i]);
            }
            break;
          }
        case 1:
          {
            if(loadList[i]['equipment'].contains(query)){
              searchList.add(loadList[i]);
            }
            break;
          }
        default:
          break;
      }
    }

    if(searchList != null){
      return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: searchList.length,
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0),
                                  text: "Aparelho: " +
                                      '${searchList[index]['name']}')),
                        ],
                      ),
                      Row(
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 18.0),
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0),
                                  text: "Reparo: " +
                                      '${searchList[index]['repair']}'))
                        ],
                      )
                    ],
                  ),
                  onTap: () => onPressWithArg(
                      searchList[index]['repair'],searchList[index]['id'],searchList[index]['repair_id'],context),
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider());
    }

    return Container(
      padding: EdgeInsets.only(left:10,right:10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
                "Insira um termo de busca válido",
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black26)
            ),
          ),
          Center(
            child: Text(
                "(Ex. Aparelho XYZ, João da Silva)",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black26)
            ),
          ),

        ],
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.length < 3)
    {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Termo deve ser maior que 2 letras.",
            ),
          )
        ],
      );
    }
    return Column();
  }
  onPressWithArg(String rep, int id, int repid, context) {
      _modalInput(rep, id, repid, context);
  }

  _modalInput(String repair, int eq, int rep, context) {
    return showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Detalhes do Reparo"),
              ],
            ),
            Divider(color: Colors.black38),
            RichText(
                strutStyle: StrutStyle(fontSize: 16.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                    text:repair)),
            Divider(color: Colors.transparent),
            Botoes(
              "Ver Aparelho",
              onPressed: () {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) => EquipmentDetail(eq)));
              },
            ),
          ],
        )
    );
  }
}

class InputData extends StatelessWidget {
  String rotulo, hint;
  TextEditingController controller;
  InputData(this.rotulo,this.hint, {this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              readOnly: true,
              keyboardType: TextInputType.datetime,
              validator: (value){
                try{
                  DateFormat.yMd().parseStrict(value);
                }
                on FormatException catch (_)
                {
                  return 'Valor inválido';
                }
              },
              controller: controller,
              style : TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.transparent
              ),
              decoration : InputDecoration(
                  labelText: rotulo,
                  hintText: hint
              )
          ),
        ),
        IconButton(icon: Icon(Icons.calendar_today), onPressed: (){
          Future<DateTime> tmp = _showCalendar(context);
          tmp.then((DateTime res){
            controller.text = DateFormat.yMd().format(res);
          });
        })
      ],
    );
  }
  _showCalendar(context)
  {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050)

    );
  }
}

class InputDataNoValidate extends StatelessWidget {
  String rotulo, hint;
  bool readonly;
  TextEditingController controller;
  InputDataNoValidate(this.rotulo,this.hint, {this.controller, this.readonly});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              readOnly: readonly == null ? false : readonly,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value.isNotEmpty)
                  {
                    try{
                      DateFormat.yMd().parseStrict(value);
                    }
                    on FormatException catch (_)
                    {
                      return 'Valor inválido';
                    }
                  }
              },
              controller: controller,
              style : TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.transparent
              ),
              decoration : InputDecoration(
                  labelText: rotulo,
                  hintText: hint
              )
          ),
        ),
        IconButton(icon: Icon(Icons.calendar_today), onPressed: (){
          Future<DateTime> tmp = _showCalendar(context);
          tmp.then((DateTime res){
            controller.text = DateFormat.yMd().format(res);
          });
        })
      ],
    );
  }
  _showCalendar(context)
  {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050)

    );
  }
}

class InputValidado extends StatelessWidget {
  String rotulo, hint;
  TextEditingController controller;
  bool readonly;
  InputValidado(this.rotulo,this.hint, {this.controller, this.readonly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value){
          if(value.isEmpty)
            return 'Preencha o valor';
        },
        readOnly: readonly == null ? false : readonly,
        controller: controller,
        style : TextStyle(
            color: Colors.black,
            backgroundColor: Colors.transparent
        ),
        decoration : InputDecoration(
            labelText: rotulo,
            hintText: hint
        )
    );
  }
}

class InputNumber extends StatelessWidget {
  String rotulo, hint;
  TextEditingController controller;
  bool readonly;
  InputNumber(this.rotulo,this.hint, {this.controller, this.readonly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value){
          if(int.tryParse(value) == null)
            return 'Valor inválido';
        },
        keyboardType: TextInputType.number,
        readOnly: readonly == null ? false : readonly,
        controller: controller,
        style : TextStyle(
            color: Colors.black,
            backgroundColor: Colors.transparent
        ),
        decoration : InputDecoration(
            labelText: rotulo,
            hintText: hint
        )
    );
  }
}

class InputTextosPhone extends StatelessWidget {
  String rotulo, hint;
  TextEditingController controller;

  InputTextosPhone(this.rotulo,this.hint, {this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'\+|\(|\)|\d|\s|\-'))
        ],
        keyboardType: TextInputType.phone,
        controller: controller,
        style : TextStyle(
            color: Colors.black,
            backgroundColor: Colors.transparent
        ),
        decoration : InputDecoration(
            labelText: rotulo,
            hintText: hint
        )
    );
  }
}
