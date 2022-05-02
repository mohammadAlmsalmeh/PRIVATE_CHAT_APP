import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCat extends StatefulWidget {
  @override
  _SubCatState createState() => _SubCatState();
}

class _SubCatState extends State<SubCat> {
   var routes;
  @override
  Widget build(BuildContext context) {
    routes=ModalRoute.of(context)!.settings.arguments as Map<String,String>;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context,isScroll){
          return [
            SliverAppBar(
              pinned: false,
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              backgroundColor: Colors.white,
              flexibleSpace: ClipPath(
                clipper: MyPath(),
                child: Container(
                    child: Stack(
                      children: [
                        Hero(
                          tag: routes["tag"],
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/"+routes['tag'])
                                )
                            ),
                          ),
                        ),
                        /*Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://bbchardware.com/images/1.JPG")
                              )
                          ),
                        ),*/
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.withOpacity(0.6),
                                    Colors.blue.withOpacity(0.4)
                                  ]
                              )
                          ),
                        ),

                      ],
                    )
                ),
              ),

            )
          ];
        },
        body: ListView(
          children: [
            productCard("Rollers","carouselRoller.jpg")
          ],
        ),
      ),
    );
  }
}

class MyPath extends CustomClipper<Path>{
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
Widget productCard(String txt,String image){
  return SingleChildScrollView(
    child: Card(
      color: Colors.black.withOpacity(0.7),
      shadowColor: Colors.cyan.withOpacity(0.4),
      child: Column(
        children: [
          Text(txt,style: TextStyle(color: Colors.white,fontSize: 20),),
          Container(
              margin: EdgeInsets.all(20),
              child: Image(image:AssetImage("assets/images/"+image)))
        ],
      ),
    ),
  );
}