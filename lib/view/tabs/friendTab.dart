

import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/friendModel.dart';
import 'package:private_message/view/externalFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FriendTab extends StatefulWidget {

  @override
  _FriendTabState createState() => _FriendTabState();
}

class _FriendTabState extends State<FriendTab> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppVar.whereAmI = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, "/addFriend");
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add,color: Colors.white,),
        ),
        body: FutureBuilder(
          future: FriendModel().getFriendList(),
          builder: (BuildContext context , AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.length == 0){
                return Center(child: Text("no Friend "),);
              }
              else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        //Fluttertoast.showToast(msg: "please wait");
                        //openChat(snapshot.data[index].id.toString(),snapshot.data[index].username.toString());
                        AppVar.chatOrGroup ="chat";
                        AppVar.friendID = snapshot.data[index].id;
                        AppVar.friendName = snapshot.data[index].username;

                      Navigator.pushNamed( context, "/chatWith",arguments: {"name":snapshot.data[index].username.toString()});
                    },
                      child: ExternalFunction().chatListCardBuild(
                          snapshot.data[index].username, snapshot.data[index].status, "friend"),
                    );
                  },
                );
              }
            }
            else{
              return Container(child: Center(
                  child:CircularProgressIndicator()
              ),);
            }
          },
        )
    );
  }
  //
  /*
  void openChat(String friendID,String friendName) async {
    var theMessages =[];
    var msgWait = await ChatModel().getMessages(friendID,"yes");
    for(var j in msgWait){
      theMessages.insert(0,j);
    }
    AppVar.chatOrGroup ="chat";
    AppVar.friendID = friendID;
    AppVar.theNewMessagesList.clear();
    //Get.to(ChatLess(theMessages,friendName));
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=>ChatLess(theMessages, friendName))
    );
  }
  */

}



