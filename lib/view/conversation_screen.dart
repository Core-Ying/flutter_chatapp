import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatnow extends StatefulWidget {
  final String chatRoomId;

  Chatnow({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chatnow> {

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                othername : widget.chatRoomId
                    .toString()
                    .replaceAll("_","")
                    .replaceAll(Constants.myName, ""),
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
       // orname=widget.chatRoomId
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Colors.blue[100],
                child: Row(
                  children: [
                    Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          elevation:5,
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0,top:2,bottom: 2),
                              child: TextField(
                                controller: messageEditingController,
                                style: biggerTextStyle(),
                                decoration: InputDecoration(
                                    hintText: "   Message ...",
                                    hintStyle: TextStyle(
                                      color: Color(0xff2A75BC),
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none
                                ),
                              )),
                          ),
                        ),

                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,color: Color(0xff2A75BC),)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String othername;
  MessageTile({@required this.message, @required this.sendByMe,@required this.othername});


  @override
  Widget build(BuildContext context) {
    return Container(
     child: Column(
       children: <Widget>[
         Container(
           padding: EdgeInsets.only(
               top: 8,
               bottom: 0,
               left: sendByMe ? 0 : 24,
               right: sendByMe ? 24 : 0),
               alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
               child:  Text(sendByMe?Constants.myName:othername,style: sendByMe? biggerTextStyle():ttTextStyle(),),
         ),
        Container(
          padding: EdgeInsets.only(
              top: 0,
              bottom: 8,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Container(
                margin: sendByMe
                    ? EdgeInsets.only(left: 30)
                    : EdgeInsets.only(right: 30),
                padding: EdgeInsets.only(
                    top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: sendByMe ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23)
                    ) :
                    BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                    gradient: LinearGradient(
                      colors: sendByMe ? [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]
                          : [
                        const Color(0xff00ceF4),
                        const Color(0xff00baF4)
                      ],
                    )
                ),
                child: Text(
                  message,
                    textAlign: TextAlign.start,
                    style: sendByMe?
                    TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300):
                    TextStyle(
                        color:  Color(0xff1F1F1F),
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
       ],
     ),
    );
  }
}

