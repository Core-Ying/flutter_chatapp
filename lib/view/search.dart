import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'conversation_screen.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool ishave=false;
  bool haveUserSearched = false;
  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.getUserByUsername(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          return userTile(
            searchResultSnapshot.documents[index].data["name"],
            searchResultSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage({String userName}) {
     String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chatnow(
            chatRoomId: chatRoomId,
          )
      ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color:  Color(0xff145C9E),
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color:  Color(0xff145C9E),
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(
                  userName:userName,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color:  Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }
  Widget page() {
    if (ishave==false) {
      return Container(
        color: Colors.blue[100],
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Icon(
                    Icons.search,
                    size: 100,
                    color: Color(0xff145C9E),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter a note to search.',
                    style: TextStyle(color: Color(0xff145C9E),fontSize: 38),
                  )
                ]
            )),
      );
    } else {
      if (searchResultSnapshot.documents.length==0) {
        return Container(
          color: Colors.blue[100],
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Icon(
                      Icons.sentiment_dissatisfied,
                      size: 100,
                      color: Color(0xff145C9E),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'No results found',
                    style: TextStyle(color: Color(0xff145C9E),fontSize: 50),
                  )
                ],
              )),
        );
      } else {
        return userList();
      }
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar:AppBar(
        title: Image.asset("assets/images/logo.png", height: 40,
        ),
        elevation: 0.0,
        backgroundColor:Color(0xff145C9E),
        actions: [
          IconButton(
            icon: Icon(
                Icons.close,
                color: Colors.white,
            ),
            onPressed: (){
              searchEditingController.text='';
            },
          )
        ],
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: biggerTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Color(0xff145C9E),
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      ishave=true;
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xff145C9E),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png",
                          height: 25, width: 25,color: Color(0xff145C9E),)),
                  )
                ],
              ),
            ),
            page()
          ],
        ),
      ),
    );
  }
}
