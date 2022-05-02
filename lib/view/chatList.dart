import 'dart:async';
import 'dart:io';

import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/sipAndroid.dart';
import 'package:private_message/models/userModel.dart';
import 'package:private_message/view/tabs/chatTab.dart';
import 'package:private_message/view/tabs/friendTab.dart';
import 'package:private_message/view/tabs/groupTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with SingleTickerProviderStateMixin{
  late TabController tabController ;
  late Timer timer ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) { UserModel().checkNotification();});
    tabController = new TabController(length: 3, vsync: this,initialIndex: 0);
    SipAndroid.login("192.168.1.7","5060", AppVar.username, AppVar.password, context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    SipAndroid.logout();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PRIVATE CHAT APP V.1.0.0"),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          unselectedLabelColor: Colors.black54,
          controller: tabController,
          tabs: [
            Tab(
              child: Text("Chat"),
            ),
            Tab(
              child: Text("Group"),
            ),
            Tab(
              child: Text("Friend List"),
            )
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Center(child: Text("PRIVATE CHAT V.1.0.0")),
              ),
              ListTile(
                title: Text("My account"),
                onTap: (){
                  Navigator.pushNamed(context,"/myAccount");
                },
              ),
              ListTile(
                title: Text("Logout"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Exit"),
                onTap: (){
                  exit(0);
                },
              ),
            ],
          )
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ChatTab(),
          GroupTab(),
          FriendTab()
        ],
      ),
    );
  }
}
