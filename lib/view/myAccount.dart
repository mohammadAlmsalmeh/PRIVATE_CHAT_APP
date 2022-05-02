import 'package:private_message/models/appVar.dart';
import 'package:private_message/models/userModel.dart';
import 'package:private_message/view/externalFunction.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Icon(Icons.person,size: 80.0 ,),
                  radius: 50.0,
                  backgroundColor: Colors.blue,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.person_pin_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppVar.username),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.reduce_capacity_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("active"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.lock_outline),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8.0, 0, 10.0),
                  child: TextButton(
                      onPressed: (){
                        //changeStatus();
                        showModalBottomSheet(context: context,
                          builder: (builder) =>change(),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Text("change your password")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  TextEditingController oldPass = new TextEditingController();
  TextEditingController newPass = new TextEditingController();
  TextEditingController conPass = new TextEditingController();
  Widget change(){
    return SingleChildScrollView(
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(15),
          child: Stack(
            children: [
              Column(
                children: [
                  TextField(
                    controller: oldPass,
                    decoration: InputDecoration(
                      labelText: "old password"
                    ),
                  ),
                  TextField(
                    controller: newPass,
                    decoration: InputDecoration(
                        labelText: "new password"
                    ),
                  ),
                  TextField(
                    controller: conPass,
                    decoration: InputDecoration(
                        labelText: "confirm new password"
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.send),
                  onPressed: (){
                    //change password
                    UserModel().changePassword(oldPass.text,newPass.text,conPass.text).then((value) {
                      ExternalFunction().popMessage(value,context);
                    });
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ) ,
      ),
    );
  }
}
