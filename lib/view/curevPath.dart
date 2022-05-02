import 'package:flutter/cupertino.dart';

class LoginPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path =Path();
    path.lineTo(0,size.height-150);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-150);

    path.lineTo(size.width,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}

class CatalogPath extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0.0, size.height-100);
    path.cubicTo(10,size.height,size.width-10, size.height, size.width,size.height-100);
    path.lineTo(size.width,0.0);
    return path ;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}