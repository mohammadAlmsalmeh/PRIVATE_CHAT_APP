import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:private_message/models/appVar.dart';

class ImageShow extends StatefulWidget {

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppVar.isChatWithActive = false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    AppVar.isChatWithActive = true;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var routes=ModalRoute.of(context)!.settings.arguments as Map<String,String>;
    return Scaffold(
      body: Center(
        child: Container(
           child: PhotoView(
              imageProvider: NetworkImage(routes['url']!),
            )
        ),
      ),
    );
  }
}
