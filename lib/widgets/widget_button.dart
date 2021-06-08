import 'package:flutter/material.dart';

import 'button_styles.dart';
class Botoes extends StatelessWidget {
  final String texto;
  final Function onPressed;
  Botoes(this.texto, {this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child:Text(
          texto,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
      ),
      onPressed: onPressed
    );
  }
}

class BotaoCustom extends StatelessWidget {
  final String texto;
  final Function onPressed;
  BotaoCustom(this.texto, {this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyles().btnS,
        child:Text(texto, style: ButtonStyles().txS),
        onPressed: onPressed
    );
  }
}
