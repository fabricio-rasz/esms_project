import 'dart:async';
import 'dart:io';
import 'package:esms_project/electronic.dart';
import 'package:esms_project/screens/equipmentDetail.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_generate.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class alterEquipment extends StatefulWidget {
  Equipment e;
  Repair r;
  alterEquipment(this.e, {this.r});
  @override
  _alterEquipmentState createState() => _alterEquipmentState();
}

class _alterEquipmentState extends State<alterEquipment> {
  Timer d;
  final values = new List<TextEditingController>.generate(
      6, (_) => TextEditingController());
  final _formEq = new GlobalKey<FormState>();
  final _formRep = new GlobalKey<FormState>();
  File _image;

  bool _writeRepair = false;
  List<String> imagens = [];
  @override
  void initState() {
    imagens = widget.e.images;
    values[0].text = widget.e.name;
    values[1].text = widget.e.problem;
    values[2].text = widget.e.observation;
    values[3].text = DateFormat.yMd().format(widget.e.dateInput);
    values[4].text = widget.e.dateExit == null
        ? ""
        : DateFormat.yMd().format(widget.e.dateExit);
    if (widget.r != null) {
      values[5].text = widget.r.repair == null ? "" : widget.r.repair;
      _writeRepair = true;
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alterar Informações"),
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
                      "Ex.: Radio XYZ",
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
                      controller: values[3],
                    ),
                    InputDataNoValidate(
                      "Data de Saída",
                      "Ex. " +
                          DateFormat.yMd()
                              .format(DateTime.now().add(Duration(days: 30))),
                      controller: values[4],
                    ),
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
                text: "Deseja registrar o reparo?",
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      groupValue: _writeRepair,
                      value: true,
                      onChanged: _onChangeRepair,
                    ),
                    Text("Sim", style: TextStyle(fontSize: 18)),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: _writeRepair,
                      value: false,
                      onChanged: _onChangeRepair,
                    ),
                    Text("Não", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            _Repair(),
            Divider(
              color: Colors.transparent,
            ),
            Botoes(
              "Atualizar Aparelho",
              onPressed: _update,
            ),
            Botoes(
              "Tire uma foto!",
              onPressed: _snapPic,
            ),
            if (imagens[0].isNotEmpty)
              Text("Você tirou " + imagens.length.toString() + " fotos."),
          ],
        ),
      ),
    );
  }

  bool _ValidateInputs() {
    setState(() {});
    return widget.e != null && _formEq.currentState.validate();
  }

  bool _ValidateRepair() {
    setState(() {});
    return _writeRepair && _formRep.currentState.validate();
  }

  _Repair() {
    return _writeRepair
        ? Container(
            child: Form(
              key: _formRep,
              child: Column(
                children: [
                  InputValidado(
                    "Reparo realizado",
                    "Troca de peça X, Y, Z",
                    controller: values[5],
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  _onChangeRepair(bool value) {
    setState(() {
        _writeRepair = value;
    });
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
        final savedImage =
            await File(_image.path).copy('${dir.path}/Pictures/$fileName');

        if (savedImage != null) {
          if (imagens[0].isEmpty)
            imagens[0] = fileName;
          else
            imagens.add(fileName);
          _displaySnackbar("Foto adicionada com sucesso.");
        }
      }
    } else {
      _displaySnackbar("Verifique os campos.");
    }
  }

  _displaySnackbar(String text) {
    setState(() {
      final snackBar =
          SnackBar(content: Text(text, style: TextStyle(fontSize: 16)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _update() {
    setState(() {
      if(!_writeRepair && widget.r != null) {
          _deleteRepair(widget.r.id);
      }
      else if(_writeRepair || widget.r == null){
        _updateSt2();
      }
    });
  }
  _updateSt2()
  {
    if (_ValidateInputs()) {
      int tmp = widget.e.id;
      int tmp2 = widget.e.client_id;
      widget.e = new Equipment(
        tmp2,
        values[0].text,
        values[1].text,
        values[2].text,
        DateFormat.yMd().parse(values[3].text),
      );
      widget.e.id = tmp;
      if (values[4].text.isNotEmpty)
        widget.e.EquipmentLeave(DateFormat.yMd().parse(values[4].text));
      widget.e.images = imagens;
      widget.e.UpdateDB(tmp);
      if (_ValidateRepair()) {
        if (widget.r == null) {
          widget.r = new Repair(tmp, values[5].text);
          widget.r.SaveToDB();
        } else {
          int tmp3 = widget.r.id;
          widget.r = new Repair(tmp, values[5].text);
          widget.r.UpdateDB(tmp3);
        }
      }
      int TryCount = 0;
      d = Timer(Duration(milliseconds: 200), () {
        if ((!_writeRepair && widget.e.status == 1) || (widget.r.status == 1 && widget.e.status == 1)) {
          TryCount = 0;
          _showcontent(tmp);
          d.cancel();
        } else
          TryCount++;
      });
      if (TryCount >= 2) _displaySnackbar("Erro na operação.");
    }
  }
  void _deleteRepair(temp)
  {
    setState(() {
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Aviso'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text('Deseja remover informações sobre reparo?'),
                ],
              ),
            ),
            actions: [
              new TextButton(
                child: new Text('Sim'),
                onPressed: () {
                  widget.r.RemoveDB(temp);
                  _updateSt2();
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              new TextButton(
                child: new Text('Não'),
                onPressed: () {
                  _updateSt2();
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _showcontent(temp) {
    setState(() {
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Aviso'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text('Equipamento atualizado.'),
                ],
              ),
            ),
            actions: [
              new TextButton(
                child: new Text('OK'),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => EquipmentDetail(temp)));
                },
              ),
            ],
          );
        },
      );
    });
  }
}
