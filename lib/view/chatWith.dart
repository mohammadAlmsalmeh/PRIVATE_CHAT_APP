import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:private_message/models/sipAndroid.dart';
import 'package:flutter/services.dart';
import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/chatModel.dart';
import 'package:private_message/models/groupModel.dart';
import 'package:private_message/models/multimediaModel.dart';
import 'package:private_message/models/retrunType.dart';
import 'package:record_mp3/record_mp3.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:private_message/view/extra/messageSelector.dart';


class ChatWith extends StatefulWidget {
  @override
  _ChatWithState createState() => _ChatWithState();
}
class _ChatWithState extends State<ChatWith>{
  //controller for text to send
  TextEditingController typeMessage = new TextEditingController();
  //list have all message
  List<ChatMessages> theChatMessages=[];
  List<GroupMessage> theGroupMessages=[];
  //
  ScrollController listController = new ScrollController();
  //to get new message
  late Timer timer;
  //to limit record to 50 sec
  bool recording =false;
  late Timer _timer ;
  //to hide and show floating button
  bool visibleFloatingButton = false;
  bool visibleNewMessageOnFloating = false;
  void timeFun(){
    try{
      if(AppVar.chatOrGroup == "chat"){
        if(AppVar.lastMessageState !=theChatMessages[0].msgState && AppVar.lastMessageState!="" ){
          if(AppVar.lastMessageState=="receive"){
            if(theChatMessages[0].msgState=="send"){
              for(var i =0;i<theChatMessages.length;i++){
                if(theChatMessages[i].msgState == "send"){
                  setState(() {
                    theChatMessages[i].msgState = "receive";
                  });
                }
                else{
                  break;
                }
              }
            }
          }
          else if(AppVar.lastMessageState =="seen"){
            if(theChatMessages[0].msgState!="seen"){
              for(var j=0;j<theChatMessages.length;j++){
                if(theChatMessages[j].msgState !="seen"){
                  theChatMessages[j].msgState = "seen";
                }
                else{break;}
              }
              setState(() {});
            }
          }
          AppVar.lastMessageState="";
        }
        else{AppVar.lastMessageState="";}
        if(AppVar.newMessage){
          if(visibleFloatingButton){
            visibleNewMessageOnFloating = true;
          }
          setState(() {
            theChatMessages.insert(0,ChatMessages("0", AppVar.theMessage,
                AppVar.friendID,AppVar.id, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),AppVar.msgType,"send"));
          });
          AppVar.newMessage=false;
          setState(() {});
        }
      }
      else if(AppVar.chatOrGroup == "group"){
        if(AppVar.lastReadBy!=[]){
          if(AppVar.lastReadBy !=theGroupMessages[0].readBy){
            theGroupMessages[0].readBy = AppVar.lastReadBy;
          }
        }
        if(AppVar.lastReceiveBy!=[]){
          if(AppVar.lastReceiveBy !=theGroupMessages[0].receiveBy ){
            theGroupMessages[0].receiveBy = AppVar.lastReceiveBy;
          }
        }
        if(AppVar.newGroupMessage){
          if(visibleFloatingButton){
            visibleNewMessageOnFloating = true;
          }
          setState(() {
            theGroupMessages.insert(0,GroupMessage(AppVar.theGroupMessage["from"], AppVar.theGroupMessage["name"], AppVar.theGroupMessage["msg"], DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),AppVar.theGroupMessage["type"],[],[]));
          });
          AppVar.newGroupMessage=false;
          setState(() {});
        }
      }
    }
    catch(e){}
  }
  //get messages from database
  Future<bool> getIt(String firstPart) async{
    theGroupMessages.clear();
    theChatMessages.clear();
    var msgWait;
    if(AppVar.chatOrGroup == "chat"){
      msgWait = await ChatModel().getMessages(AppVar.friendID,firstPart);
      for(var j in msgWait){
        theChatMessages.insert(0,j);
      }
    }
    else{
     msgWait = await GroupModel().getMessages(AppVar.groupID,firstPart);
     for(var j in msgWait){
       theGroupMessages.insert(0,j);
     }
    }
    setState(() {});
      return true;
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppVar.stopAnotherAudio = false;
    AppVar.anyAudioOn = false;
    getIt("yes").then((value){
      timer = Timer.periodic(Duration(seconds: 2), (timer) { timeFun();});
    });
    AppVar.isChatWithActive = true;
    listController.addListener(() {
      //b
      if(listController.position.pixels != listController.position.minScrollExtent){
        if(visibleFloatingButton==false){
          setState(() {
            visibleFloatingButton =true;
          });
        }
      }else{
        if(visibleFloatingButton==true){
          setState(() {
            visibleFloatingButton =false;
          });
        }
      }
      //e
    });
  }
  //dispose fun
  @override
  void dispose() {
    // TODO: implement dispose
    AppVar.friendID ="0";
    AppVar.groupID ="0";
    AppVar.chatOrGroup = "";
    AppVar.isChatWithActive = false;
    AppVar.stopAnotherAudio = true;
    super.dispose();
  }
  //audio variable
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(AppVar.friendName),
        centerTitle: true,
        actions: [
          AppVar.chatOrGroup=="chat"?IconButton(onPressed: (){
            SipAndroid.call(AppVar.friendName, context);
          }, icon: Icon(Icons.call)):Text("")
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Visibility(
            visible: visibleFloatingButton,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5,0,0,60),
              child: FloatingActionButton(
                onPressed: (){
                    listController.animateTo(
                    listController.position.minScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 800),
                  );
                    setState(() {
                      visibleNewMessageOnFloating = false;
                    });
                },
                child: Icon(Icons.keyboard_arrow_down) ,
                mini: true,
                backgroundColor: Colors.grey.withOpacity(0.85),
              ),
            ),
          ),
          Visibility(
            visible: visibleNewMessageOnFloating,
              child: Container(
                padding: EdgeInsets.fromLTRB(17, 0, 0, 40),
                margin: EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.green.withOpacity(0.7),
                      onPressed: (){},
                      child: Icon(
                          Icons.fiber_new_outlined,
                      ),
                    ),
                  ),
                ),
              ) ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              //height: MediaQuery.of(context).size.height -140,
              child: ListView.builder(
                controller: listController,
                reverse: true,
                itemCount:AppVar.chatOrGroup=="chat"?theChatMessages.length:theGroupMessages.length,
                itemBuilder: (BuildContext context , int index){
                  if(AppVar.chatOrGroup=="chat"){
                    String nameOfNextAudio="no";
                    if(index!=0){
                      if(theChatMessages[index-1].type=="audio"){
                        nameOfNextAudio = theChatMessages[index-1].msg;
                      }
                    }
                    return chatMsgSelector(
                        msgType:theChatMessages[index].type,
                        from: theChatMessages[index].from,
                        message:theChatMessages[index].msg,
                        msgTime:theChatMessages[index].created,
                        context: context,
                        msgState: theChatMessages[index].msgState,
                        nameOfNextAudio: nameOfNextAudio,
                        getIt: (){
                          getIt("no");
                        }
                    );
                  }
                  else{
                    String nameOfNextAudio="no";
                    if(index!=0){
                      if(theGroupMessages[index-1].type=="audio"){
                        nameOfNextAudio = theGroupMessages[index-1].msg;
                      }
                    }
                    return groupMsgSelector(
                        msgType:theGroupMessages[index].type,
                        from: theGroupMessages[index].from,
                        message:theGroupMessages[index].msg,
                        msgTime:theGroupMessages[index].created,
                        context: context,
                        fromName: theGroupMessages[index].fromName,
                        nameOfNextAudio: nameOfNextAudio,
                        getIt: (){
                          getIt("no");
                        },
                        readBy: theGroupMessages[index].readBy,
                        receiveBy: theGroupMessages[index].receiveBy
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-52,
                      child: Card(
                        margin: EdgeInsets.all(3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: TextFormField(
                          controller: typeMessage,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "type message to send",
                              contentPadding: EdgeInsets.all(8),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: (){
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder:(builder)=> attachCard(context: context));
                                },
                              )
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onLongPressEnd:(detail){
                        if(recording){
                          _timer.cancel();
                          RecordMp3.instance.stop();
                          sleep(Duration(milliseconds: 500));
                          AppVar.stopAnotherAudio = false;
                          AppVar.anyAudioOn = false;
                          setState(() {
                            recording = false;
                          });
                          if(detail.localPosition.distance<90.0){
                            Fluttertoast.showToast(msg: "Sending..");
                            sendAudio();
                          }
                          else{
                            Fluttertoast.showToast(msg: "Record cancel");
                          }

                        }
                      },
                      onLongPress: (){
                        AppVar.stopAnotherAudio = true;
                        //timer begin
                        int end =50;
                        _timer = new Timer.periodic(
                            Duration(seconds: 1),
                                (timer){
                              if(end == 0){
                                RecordMp3.instance.stop();
                                sleep(Duration(milliseconds: 500));
                                Fluttertoast.showToast(msg: "Record can only 50 second");
                                _timer.cancel();
                                AppVar.stopAnotherAudio = false;
                                AppVar.anyAudioOn = false;
                                setState(() {
                                  recording =false;
                                });
                                Fluttertoast.showToast(msg: "Sending..");
                                sendAudio();
                                AudioCache().play("recordEnd.wav");
                              }
                              end--;
                            }
                        );
                        //toast to
                        setState(() {
                          recording = true;
                        });
                        Fluttertoast.showToast(msg: "Recording swipe up to cancel..");
                        //limit recorder for 50 second
                        RecordMp3.instance.start(AppVar.tempDir+"/test.mp3", (error){
                        });
                      },
                      onTap: (){
                        setState(() {
                          //but thw message on screen
                          if(typeMessage.text!="") {
                            var textMessage = typeMessage.text;
                            textMessage = textMessage.replaceAll("|:|", "");
                            textMessage = textMessage.replaceAll("|;|", "");
                            //send the message to database
                            if(AppVar.chatOrGroup=="chat"){
                              theChatMessages.insert(0,ChatMessages("0", textMessage, AppVar.id,
                                  AppVar.friendID, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"text","new"));
                            ChatModel().sendChatMessage(textMessage,"text",AppVar.friendID).then((value){
                              AppVar.lastMessageState="";
                              if(value){setState(() {
                                theChatMessages[0].msgState="send";
                              });}
                            });
                            }else{
                              theGroupMessages.insert(0,GroupMessage(AppVar.id, AppVar.username, textMessage, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"text", [],[]));
                              GroupModel().sendMessage(textMessage, "text", AppVar.groupID).then((value) {
                                AppVar.lastReceiveBy=[];
                                AppVar.lastReadBy=[];
                              });
                            }
                          }
                          else{
                            Fluttertoast.showToast(msg: "please write message");
                          }
                        });
                        typeMessage.text ="";
                        },
                      child:CircleAvatar(
                        radius:25 ,
                        child: Icon(recording==false?Icons.send:Icons.mic,color: Colors.white,),
                        backgroundColor: recording==false?Colors.blue:Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget attachCard({BuildContext? context}) {
    return SingleChildScrollView(
      child: Container(
        height: 275,
        width: MediaQuery.of(context!).size.width,
        child:Card(
          margin: EdgeInsets.all(18),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // set image from gallery
                        sendImage();
                      },
                      child:attachCardIcon(colors: Colors.purple,icons: Icons.image,name: "image"),
                    ),
                    GestureDetector(
                      child:attachCardIcon(colors: Colors.blue,icons: Icons.insert_drive_file,name: "document"),
                      onTap: (){
                        sendDoc();
                      },
                    ),
                    GestureDetector(
                      child: attachCardIcon(colors: Colors.blue,icons: Icons.ondemand_video_rounded,name: "video"),
                      onTap: (){
                        sendVideo();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void sendImage() async{
      var data = await MultimediaModel().sendImage(context);
      if(data['state']=="success"){
        //put image on screen
        //check you are in chat or group
        if(AppVar.chatOrGroup=="chat"){
        theChatMessages.insert(0,ChatMessages("0",data['imageUrl'].toString(), AppVar.id,
            AppVar.friendID, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"image","send"));
        setState(() {});
        //send image to database
        ChatModel().sendChatMessage(data['imageUrl'].toString(), "image", AppVar.friendID);
        }
        else{
          theGroupMessages.insert(0,GroupMessage(AppVar.id,AppVar.username,data['imageUrl'],DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"image",[],[]));
          setState(() {});
          //send image to data base
          GroupModel().sendMessage(data['imageUrl'],"image",AppVar.groupID);
        }
      }
      else{Fluttertoast.showToast(msg: "fail to upload image");}
  }
  void sendDoc() async{
    var data = await MultimediaModel().sendDoc(context);
    if(data["state"]=="success"){
      if(AppVar.chatOrGroup == "chat"){
      theChatMessages.insert(0,ChatMessages("0",data['pdfUrl'].toString(), AppVar.id,
          AppVar.friendID, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"pdf","send"));
      setState(() {
      });
      //send image to database
      ChatModel().sendChatMessage(data['pdfUrl'].toString(), "pdf", AppVar.friendID);
      }
      else{
        //put image on screen
        theGroupMessages.insert(0,GroupMessage(AppVar.id,AppVar.username,data['pdfUrl'],DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"pdf",[],[]));
        setState(() {});
        //send image to database
        GroupModel().sendMessage(data['pdfUrl'],"pdf",AppVar.groupID);
      }
    }else{Fluttertoast.showToast(msg: "fail to upload document");}
  }
  void sendVideo() async{
    var data = await MultimediaModel().sendVideo(context);
    if(data["state"]=="success"){
      if(AppVar.chatOrGroup == "chat"){
      //put video on screen
      theChatMessages.insert(0,ChatMessages("0",data['videoUrl'].toString(), AppVar.id,
          AppVar.friendID, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"video","send"));
      setState(() {});
      //send video to database
      ChatModel().sendChatMessage(data['videoUrl'].toString(), "video", AppVar.friendID);
      }else{
        //put video on screen
        theGroupMessages.insert(0,GroupMessage(AppVar.id,AppVar.username,data['videoUrl'],DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"video",[],[]));
        setState(() {});
        //send video to backend
        GroupModel().sendMessage(data['videoUrl'],"video",AppVar.groupID);
      }
    }else{Fluttertoast.showToast(msg: "fail to upload video");}
  }
  void sendAudio() async{
    var resultOfAudio = await MultimediaModel().sendAudio(context);
    if(resultOfAudio["state"]=="success"){
      if(AppVar.chatOrGroup == "chat"){
      //put audio on screen
        setState(() {
          theChatMessages.insert(0,ChatMessages(DateTime.now().second.toString()+DateTime.now().millisecond.toString(),resultOfAudio['audioUrl'], AppVar.id,
              AppVar.friendID, DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"audio","send"));
        });
      //send audio to database
      ChatModel().sendChatMessage(resultOfAudio['audioUrl'].toString(), "audio", AppVar.friendID).then((value) {
        AppVar.lastMessageState="";
        if(value){setState(() {
          theChatMessages[0].msgState="send";
        });}
      });
      }
      else{
        //put audio on screen
        setState(() {
        theGroupMessages.insert(0,GroupMessage(AppVar.id,AppVar.username,resultOfAudio['audioUrl'],DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),"audio",[],[]));
        });
        //send audio to backEnd
        GroupModel().sendMessage(resultOfAudio['audioUrl'],"audio",AppVar.groupID);
      }
    }else{Fluttertoast.showToast(msg: "fail to upload audio");}
  }
}
Widget attachCardIcon({Color? colors,IconData? icons,String? name}){
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: colors,
        child: Icon(icons,color: Colors.white,size: 28,),
      ),
      SizedBox(height: 5,),
      Text(name!)
    ],
  );
}

