import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class Cards extends StatefulWidget {
  String imagemFrente;
  String imagemTras;
  bool permiteTroca;

  Cards(this.imagemFrente, this.imagemTras, this.permiteTroca);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: widget.permiteTroca,
      speed: 200,
      front: Container(
        //
        child: Image.file(File(widget.imagemFrente))),
      back: Container(
        child: Image.file(File(widget.imagemTras))),
    );
  }
}
