import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
class Caroussel extends StatefulWidget {
  List<String> images;
  String path;
  List<Image> finalImg = List<Image>.empty(growable: true);
  Caroussel(this.images);
  @override
  _CarousselState createState() => _CarousselState();
}
class _CarousselState extends State<Caroussel> {
  Future<bool> loaded;
  Future<bool> getPath() async{
    final directory = await getApplicationDocumentsDirectory().then((Directory value){
      widget.path = value.path;
    });
    for (int i = 0; i < widget.images.length; i++) {
      widget.finalImg.add(Image.file(File(widget.path+"/Pictures/"+widget.images[i].trimLeft())));
    }
    return true && widget.path.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    loaded = getPath();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FutureBuilder<bool>(
            future: loaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  widget.finalImg.length > 0) {
                return
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.finalImg.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return Container(
                        margin: EdgeInsets.only(right:5),
                        child: widget.finalImg[index],
                      );
                    },
                  );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
/*
*
* Center(
      child: ListView(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          for(int i = 0; i < widget.finalImg.length; i++)
            widget.finalImg[i],
        ],
      ),
    );*/
