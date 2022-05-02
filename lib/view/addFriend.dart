import 'package:private_message/models/friendModel.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  String result ="";
  TextEditingController friendName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add new Friend"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: friendName,
              decoration: InputDecoration(
                labelText: "type friend name"
              ),
            ),
            TextButton(
                onPressed: (){
                  FriendModel().addNewFriend(friendName.text).then((value) {
                    setState(() {
                      result = value;
                    });
                  });
                },
                child: Text("add")
            ),
            Text(result)
          ],
        ),
      ),
    );
  }
}
