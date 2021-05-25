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
