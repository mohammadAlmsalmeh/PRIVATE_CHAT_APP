import 'dart:io';
import 'dart:ui';


import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:private_message/models/appVar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_safe/open_file_safe.dart';
class ExternalFunction {
  //show pop message on screen
  void popMessage(String message,BuildContext context){
    showModalBottomSheet(context: context, builder: (builder) {
      return Card(
        child:Padding(
          padding: EdgeInsets.all(15),
          child: Text(message),
        ) ,
      );
    },
        backgroundColor: Colors.transparent
    );
  }
  //senderID for chat and group senderName for group
  Widget chatListCardBuild(String cardTitle,String cardSubTitle,String type,{String senderID ="0",String senderName="0",String sendOrSeen="0",bool newMessage =false}){
    return Card(
      color: newMessage == false?Colors.white:Colors.amberAccent,
      child: Padding(
        padding: EdgeInsets.all(11.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                type=="group"?Icons.people:Icons.person,
                color: Colors.white,),
              backgroundColor: Colors.blue,
            ),
            senderID==AppVar.id?Icon(
              sendOrSeen=="send"?Icons.done:sendOrSeen=="new"?Icons.access_time:Icons.done_all
              ,color: sendOrSeen=="seen"?Colors.blue:Colors.grey
              ,): Text(""),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:10.0),
                  child: Text(cardTitle,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                ),
                Container(
                  width: 200,
                    child: Text(cardSubTitle,
                      maxLines: 1,
                      overflow:TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black,),)
                    ,padding:EdgeInsets.only(left: 20.0))
              ],
            ),

          ],
        ),
      ),
    );
  }
  //card for text message send or receive for chat and group
  Widget textCardBuild(String message,String time,BuildContext context,String type,{String state="0",String name="0"}){
    return Align(
      alignment: type == "send" ?Alignment.centerRight:Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 80
        ),
        child: Card(
          color: type =="send"?Color(0xffdcf8c6):Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 80, 20),
                child: name=="0"?Text(message,style: TextStyle(color: Colors.black),):
                Column(
                  children: [
                    Text(name,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                    Text(message,style: TextStyle(color: Colors.black),)
                  ],
                ),),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    Text(time,style: TextStyle(color: Colors.black),),
                    SizedBox(width: 5,),
                    type =="send"?Icon(
                      state=="send"?Icons.done:state=="new"?Icons.access_time:Icons.done_all
                      ,color: state=="seen"?Colors.blue:Colors.grey
                      ,):Text("")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> checkMicPermission() async {

    return true;
  }
}

//pdf card
class PdfCard extends StatefulWidget {
  final String tm;
  final String  name;
  final String state;
  final String senderName;
  PdfCard(this.name,this.tm,{this.state = "false",this.senderName="",Key? key}):super(key: key);
  @override
  _PdfCardState createState() => _PdfCardState(this.name,this.tm,this.state,this.senderName);
}
class _PdfCardState extends State<PdfCard> {
  final String tm;
  final String name;
  final String senderName;
  String state;
  List<int> _byte =[];
  bool isDownload = false;
  var downloadVal = 0.0;
  _PdfCardState(this.name,this.tm,this.state,this.senderName);
  @override
  Widget build(BuildContext context) {
    var url =AppVar.serverName+"/api/pdfFile/"+name;
    return Container(
      width: MediaQuery.of(context).size.width-50,
      child: Card(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(senderName , style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                )
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(isDownload==false?Icons.arrow_downward:Icons.done),
                  iconSize: 35,
                  onPressed: (){
                    if(isDownload==false){
                      Fluttertoast.showToast(msg: "downloading ...");
                      http.Client().send(http.Request("GET",Uri.parse(url))).then((res) {
                        var total =res.contentLength;
                        var sum = 0;
                        res.stream.listen((value) {
                          setState(() {
                            sum = sum +value.length;
                            _byte.addAll(value);
                            downloadVal = (sum*100)/total!;
                          });
                        }
                        ).onDone(() {
                          File f = File(AppVar.tempDir+"/"+name);
                          f.writeAsBytes(_byte).then((value) {
                            setState(() {
                              isDownload =true;
                            });
                          });
                        });
                      });
                    }
                  },
                ),
                isDownload==false?Text(downloadVal.toStringAsFixed(2)+"%"):Text(""),
                isDownload==false?Text("tap on icon to download pdf"):
                    GestureDetector(
                      child: Text("tap here to show pdf"),
                      onTap: (){
                        OpenFile.open(AppVar.tempDir+"/"+name);
                      },
                    )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(tm),
                state=="false"?Text(""):
                Icon(
                  state=="send"?Icons.done:state=="new"?Icons.access_time:Icons.done_all
                  ,color: state=="seen"?Colors.blue:Colors.grey
                  ,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
//video card
class VideoCard extends StatefulWidget {
  final String name;
  final String senderName;
  VideoCard(this.name,{this.senderName="",Key? key}):super(key: key);
  @override
  _VideoCardState createState() => _VideoCardState(this.name,this.senderName);
}
class _VideoCardState extends State<VideoCard> {
  bool isDownload =false;
  final String name;
  final String senderName;
  _VideoCardState(this.name,this.senderName);
  @override
  Widget build(BuildContext context) {
    var tall = MediaQuery.of(context).size.width -100;
    var url = AppVar.serverName+"/api/videoFile/"+name;
    return  Container(
      width:tall,
      height: 200,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(senderName,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
          ),
          isDownload==false?Center(child: Text("press button below to download video")):
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer.network(
                url,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  aspectRatio: 16 / 9,
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(isDownload==false?Icons.arrow_downward:Icons.play_arrow_sharp),
              onPressed: (){
                if(isDownload==false){
                  setState(() {
                    isDownload=true;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
