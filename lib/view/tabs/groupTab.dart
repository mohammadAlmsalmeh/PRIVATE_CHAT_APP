import 'dart:async';
import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/groupModel.dart';
import 'package:private_message/models/retrunType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../externalFunction.dart';


class GroupTab extends StatefulWidget {

  @override
  _GroupTabState createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  List<Groups> theGroups=[];
  late Timer timer;
  void timeFun(){
    if(AppVar.newGroupChat){
      for(var NewChat in AppVar.theNewGroupChat){
        var sum =0;
        for(var chat in theGroups){
          if(chat.id == NewChat[0]){
            theGroups[sum].msg = NewChat[2];
            theGroups[sum].newMsg = true;
            var tempChat = theGroups[sum];
            theGroups.removeAt(sum);
            theGroups.insert(0, tempChat);
          }
          sum++;
        }//end second for
        sum = 0;
        /*for(var i in theGroups){
          sum++;
        }//end of for
        */
      }//end first for
      setState(() {});
      AppVar.newGroupChat =false;
      AppVar.theNewGroupChat.clear();
    }//end if
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveGroupInList();
    AppVar.whereAmI ="group";
    timer = Timer.periodic(Duration(seconds: 3), (timer) { timeFun();});
  }
  void saveGroupInList() async{
    var groupWait = await GroupModel().getGroupList();
    if(groupWait[0].id =="0" && groupWait[0].name =="0"){
      ExternalFunction().popMessage(groupWait[0].msg,context);
    }
    else{
      theGroups.clear();
      for(var j in groupWait){
        theGroups.add(j);
      }
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: theGroups.length,
            itemBuilder: (BuildContext context , int index){
              if(theGroups.isEmpty){
                return Center(child: CircularProgressIndicator());
              }
              return GestureDetector(
                  onTap: (){
                    AppVar.groupID = theGroups[index].id;
                    AppVar.friendName = theGroups[index].name;
                    AppVar.chatOrGroup ="group";
                    Navigator.pushNamed( context,"/chatWith");
                    if(index != -1){
                      setState(() {
                        theGroups[index].newMsg=false;
                      });
                    }
                  },
                child: ExternalFunction().chatListCardBuild(theGroups[index].name, theGroups[index].msg,"group"
                    ,senderID: theGroups[index].sender,senderName:theGroups[index].senderName,newMessage: theGroups[index].newMsg,sendOrSeen: "send" ),
              );
            }
        )
    );
  }
}