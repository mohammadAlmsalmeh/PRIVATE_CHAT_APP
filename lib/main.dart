import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:private_message/view/addFriend.dart';
import 'package:private_message/view/chatWith.dart';
import 'package:private_message/view/chatList.dart';
import 'package:private_message/view/imageShow.dart';
import 'package:private_message/view/login.dart';
import 'package:private_message/view/myAccount.dart';
import 'package:private_message/view/subCat.dart';
import 'package:flutter/material.dart';

import 'models/appVar.dart';

void main() {
//'resource://drawable/launch'

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    "resource://mipmap/launcher_icon",
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white
      ),
      NotificationChannel(
        channelGroupKey: 'chat_tests',
        channelKey: 'chats',
        channelName: 'Chat groups',
        channelDescription: 'This is a simple example channel of a chat group',
        channelShowBadge: true,
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
      ),
    ],
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  var tempDie = getTemporaryDirectory().then((value) {
    AppVar.tempDir=value.path;});
  Permission.microphone.isGranted.then((value){
    if(!value){
      Permission.microphone.request();
    }
  });

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/" :(context) => LogIn(),
          "/chatList"   : (context) => ChatList(),
          "/myAccount"  : (context) => MyAccount(),
          "/subCatalog" : (context) => SubCat(),
          "/addFriend"  : (context) => AddFriend(),
          "/chatWith"   : (context) => ChatWith(),
          "/imageShow"  : (context) => ImageShow()
        },
      )
  );
}

