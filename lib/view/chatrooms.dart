import 'dart:io';
import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/view/search.dart';
import 'package:chatapp/view/signin.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/data.dart';
import 'conversation_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp/view/conversation_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  bool _cancelConnect = false; //多次请求！
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatroomId']
                    .toString()
                    .replaceAll("_","")
                    .replaceAll(Constants.myName, ""),
                 chatRoomId: snapshot.data.documents[index].data["chatroomId"],
                //   snapshot.data.documents[index].data['chatroomId']
              );
            }) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();//
  }
  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
        print(
            "we got the data + ${Constants.myName
                .toString()} this is name  ${Constants.myName}");
      });
    });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Image.asset(("assets/images/logo.png"),
            height: 50),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      drawer:  Drawer(
          //ListView => 装载抽屉的部件
          child: ListView(
          //Text('This is Drawer'),
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
          //DrawerHeader =>抽屉的头部
            UserAccountsDrawerHeader(
             accountName: Text(Constants.myName),
             accountEmail: Text(Constants.myName+"@qq.com"),
             currentAccountPicture:
                 new CircleAvatar(
                   child: ClipOval(
                     child: Image.network('https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=194818999,1183601898&fm=26&gp=0.jpg'),
                   ),
                 ),

             // otherAccountsPictures: <Widget>[
             //
             // ],
           onDetailsPressed: () {},
          ),
            ListTile(

            ),
             ],
          ),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
//  bool  ismyself;
  ChatRoomsTile({this.userName,@required this.chatRoomId});
// ChatRoomsTile(this.userName);
  @override
  Widget build(BuildContext context) {
   // String t=ismyself?userName:"myself";
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chatnow(
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}