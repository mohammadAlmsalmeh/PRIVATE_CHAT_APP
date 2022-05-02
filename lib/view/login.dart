import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/userModel.dart';
import 'package:private_message/view/curevPath.dart';
import 'package:private_message/view/externalFunction.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppVar.backgroundStatus = state.name;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.addObserver(this);
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    AwesomeNotifications().actionStream.listen(
            (receivedNotification){
              AwesomeNotifications().cancelAll();
              AwesomeNotifications().getGlobalBadgeCounter().then((value){
                AwesomeNotifications().setGlobalBadgeCounter(value-1);
              });
              String titleName = receivedNotification.title!;
              if(titleName.length>7){
                titleName=titleName.substring(0,6);
              }
              if(receivedNotification.id == 2001){
                Navigator.of(context).pushNamed('/NotificationPage',);
              }
              if(titleName=="group:"){
                AppVar.groupID = receivedNotification.id.toString();
                AppVar.chatOrGroup ="group";
                String name = receivedNotification.title!;
                name=name.substring(6);
                AppVar.friendName = name;
                Navigator.pushNamed(context,"/chatWith");
              }
              else{
                AppVar.friendID = receivedNotification.id.toString();
                AppVar.chatOrGroup ="chat";
                AppVar.friendName = receivedNotification.title.toString();
                Navigator.pushNamed( context, "/chatWith");
              }
        }
    );
  }
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String msg ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context,isScroll){
          return <Widget>[
            SliverAppBar(
              pinned: false,
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height,
              backgroundColor: Colors.white,
              flexibleSpace: ClipPath(
                clipper: LoginPath(),
                child: Container(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/f2.jpg")
                              )
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.6),
                                    Colors.blue.withOpacity(0.6)
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
        body: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100,),
                Center(child: Container(
                    height: 150,
                    child: Image(image: AssetImage("assets/images/logoLite.png"),))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: "User name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10,0,10,0),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",

                    ),
                    cursorColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8.0, 0, 10.0),
                  child: TextButton(
                      onPressed: (){
                        if(username.text==""||password.text==""){
                          setState(() {
                            msg= "please enter username and password";
                          });
                        }
                        else {
                          UserModel().logIN(username.text, password.text).then((value){
                            if(value == "user"){
                              Navigator.pushNamed(context, "/chatList");
                            }
                            else{
                              ExternalFunction().popMessage(value, context);
                            }
                          });
                          username.text ="";
                          password.text ="";
                        }
                      },
                      child: Text("Log In")),),
                Text(msg,style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
