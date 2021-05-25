import 'dart:io';

import 'package:esms_project/electronic.dart';
import 'package:esms_project/screens/equipmentDetail.dart';
import 'package:esms_project/widgets/widget_button.dart';
import 'package:esms_project/widgets/widget_input.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';

class alterEquipment extends StatefulWidget {
  Equipment e;
  alterEquipment(this.e);
  @override
  _alterEquipmentState createState() => _alterEquipmentState();
}

class _alterEquipmentState extends State<alterEquipment> {
  final values = new List<TextEditingController>.generate(
      5, (_) => TextEditingController());
  final _formEq = GlobalKey<FormState>();
  File _image;
  List<String> imagens = [];
  @override
  void initState() {
    imagens = widget.e.images;
    values[0].text = widget.e.name;
    values[1].text = widget.e.problem;
    values[2].text = widget.e.observation;
    values[3].text = DateFormat.yMd().format(widget.e.dateInput);
    values[4].text = widget.e.dateExit == null ? "" : DateFormat.yMd().format(widget.e.dateExit);
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
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
                        "Ex.: Radio Pioneer",
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
                        "Ex. " +
                            DateFormat.yMd().format(DateTime.now()),
                        controller: values[3],),
                      InputDataNoValidate(
                        "Data de Saída",
                        "Ex. " +
                            DateFormat.yMd().format(DateTime.now().add(Duration(days:30))),
                        controller: values[4],)
                    ],
                  )),
              Divider(
                color: Colors.transparent,
              ),
              Botoes(
                "Atualizar Aparelho",
                onPressed: _update,
                    ),
              if(widget.e.images.length < 2)
              Botoes(
                "Tire uma foto!",
                onPressed: _snapPic,
              ),
              if(imagens[0].isNotEmpty)
                Text("Você tirou "+imagens.length.toString()+ " fotos.")
            ],
          ),
          ),
    );
  }
  bool _ValidateInputs() {
    setState(() {});
    return _formEq.currentState.validate() && widget.e != null;
  }

  Future<void> _snapPic() async {
    if (_ValidateInputs()) {
      final imageCarregada =
      await ImagesPicker.openCamera(pickType: PickType.image);
      if (imageCarregada != null) {
        setState(() {
          _image = File(imageCarregada[0].thumbPath);

        });
        bool resultado = await ImagesPicker.saveImageToAlbum(
            File(imageCarregada[0].thumbPath),
            albumName: "Fotos de Aparelhos");
      }
      if(imagens[0].isEmpty)
        imagens[0] = _image.path;
      else if(imagens.length < 2)
        imagens.add(_image.path);
        _displaySnackbar("Foto adicionada com sucesso.");
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
        if(_ValidateInputs())
          {
            int tmp = widget.e.id;
            int tmp2 = widget.e.client_id;
            widget.e = new Equipment(
                tmp2,
                values[0].text,
                values[1].text,
                values[2].text,
                DateFormat.yMd().parse(values[3].text),
            );

            if(values[4].text.isNotEmpty)
              widget.e.EquipmentLeave(
                  DateFormat.yMd().parse(values[4].text)
              );
            widget.e.images = imagens;
            widget.e.UpdateDB(tmp);
            _displaySnackbar("Equipamento atualizado.");
            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> EquipmentDetail(tmp)));
          }
    });
  }
}
