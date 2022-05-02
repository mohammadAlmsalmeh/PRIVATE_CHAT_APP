import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/chatModel.dart';
import 'package:private_message/models/retrunType.dart';
import 'package:private_message/view/externalFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<Chats> theChats=[];
  late Timer timer;
  void timeFun(){
    if(AppVar.newChat){
      for(var NewChat in AppVar.theNewChat){
        var sum =0;
        for(var chat in theChats){
          if(chat.id == NewChat[0]){
            theChats[sum].msg = NewChat[1];
            theChats[sum].newMsg = true;
            var tempChat = theChats[sum];
            theChats.removeAt(sum);
            theChats.insert(0, tempChat);
          }
          sum++;
        }//end second for
        sum = 0;
        /*for(var i in theChats){
          sum++;
        }//end of for
        */
      }//end first for
      setState(() {});
      AppVar.newChat =false;
      AppVar.theNewChat.clear();
    }//end if
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveChatInList();
    AppVar.whereAmI = "chat";
    timer = Timer.periodic(Duration(seconds: 3), (timer) { timeFun();});
  }
  void saveChatInList() async{
    var newChatCount =0;
    var chatWait = await ChatModel().getChatList();
    //if there is issue
    if(chatWait[0].id == "0" && chatWait[0].username =="0"){
      ExternalFunction().popMessage(chatWait[0].msg, context);
    }//else fill chat in list
    else{
      theChats.clear();
      for(var j in chatWait){
        theChats.add(j);
        if(j.newMsg){
          newChatCount++;
        }
      }
      setState(() {});
    }
    AwesomeNotifications().setGlobalBadgeCounter(newChatCount);
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: theChats.length,
            itemBuilder: (BuildContext context , int index){
              if(theChats.isEmpty){
                return Center(child: CircularProgressIndicator());
              }
              return GestureDetector(
                  onTap: (){
                    AppVar.friendID = theChats[index].id;
                    AppVar.friendName = theChats[index].username;
                    AppVar.chatOrGroup ="chat";
                    Navigator.pushNamed( context, "/chatWith");
                    if(index != -1){
                      setState(() {
                        theChats[index].newMsg=false;
                      });
                    }
                  },
                child: ExternalFunction().chatListCardBuild(theChats[index].username, theChats[index].msg, "chat",sendOrSeen:theChats[index].sendOrSeen
                ,senderID:theChats[index].sender,newMessage:theChats[index].newMsg),
              );
            }
        )
    );
  }
}

