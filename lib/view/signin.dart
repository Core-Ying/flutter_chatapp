
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:date_format/date_format.dart';
import 'chatrooms.dart';
import 'dart:convert';
import 'dart:io';
class SignIn extends StatefulWidget {
  @override
  final Function toggle;
  SignIn(this.toggle);
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods =new AuthMethods();
  DatabaseMethods databaseMethods =new DatabaseMethods();
  bool isLoading =true;
  TextEditingController emailTextEdittingController = new TextEditingController();
  TextEditingController passwordTextEdittingController = new TextEditingController();
  QuerySnapshot snapshotUserInfo;
  // void _toggleFavorite() {
  //   // 通过 setState() 更新数据
  //   // 组件树就会自动刷新了
  //   setState(() {
  //   });
  // }
  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEdittingController.text);
    }
    //TODO 获得用户详细信息
    setState(() {
      isLoading =true;
    });
    databaseMethods.getUserByUserEmail(emailTextEdittingController.text)
    .then((val){
      snapshotUserInfo=val;
      HelperFunctions
          .saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["name"]);
    });
    authMethods.signInWithEmailAndPassword(emailTextEdittingController.text,
        passwordTextEdittingController.text).then((val){
      //    if(val!=null){
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>ChatRoom()
            ));
        //  }
    });

  }
  // Future<List<Newslist>> getChatData() async {
  //   final chatJson = await HttpClient().getUrl(Uri.parse('http://api.tianapi.com/txapi/ensentence/index?key=65aa15bf2593d9c7f4610c74d9d4e68d'));
  //   var response = await chatJson.close();
  //   if (response.statusCode == 200) {
  //     var json = await response.transform(utf8.decoder).join();
  //     var data = jsonDecode(json);
  //     Map<String, dynamic> jsonMap = data;
  //     print(jsonMap);
  //     final chat = Chat.fromJson(jsonMap);
  //     print(chat);
  //     chat.newslist.forEach((newslist) => print('student name is ${chat.newslist}'));
  //     List<Newslist> newslist = jsonMap["newslist"]
  //         .map<Newslist>((item) => Newslist.fromJson(item))
  //         .toList();
  //     print(newslist);
  //     return newslist;
  //   } else {
  //     // 抛出异常
  //     throw Exception('statusCode:${response.statusCode}');
  //   }
  // }
  //Color themColor = Color.fromRGBO(220, 220, 220, 1.0);
  DateTime now=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
     // appBar: appBarMain(context),
      body: SingleChildScrollView(
        child:Container(
          height: MediaQuery.of(context).size.height-100,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize:MainAxisSize.min ,
            children: [
              Hero(
                tag: 'heroicon',
                child: Icon(
                  Icons.textsms,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Hero(
                tag: 'HeroTitle',
                child: Text(
                  'Chatter',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TyperAnimatedTextKit(
                isRepeatingAnimation: false,
                speed:Duration(milliseconds: 120),
                text:["⭐曾莹的期末作业线上聊天App⭐".toUpperCase()],
                textStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Color(0xff2A75BC),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        style: biggerTextStyle(),
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                              ? null
                              : "Please Enter Correct Email";
                        },
                        controller: emailTextEdittingController,
                        decoration:textFieldInputDecoration("email",Icon(Icons.email))
                    ),
                    TextFormField(
                        style: biggerTextStyle(),
                        validator:  (val){
                          return val.length > 6 ? null:"Enter Password 6+ characters" ;
                        },
                        controller:passwordTextEdittingController,
                        decoration:textFieldInputDecoration("password",Icon(Icons.check_circle))
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              SizedBox(height: 8,),
              GestureDetector(
                onTap: (){
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                        colors:[
                          const Color(0xff00baF4),
                          const Color(0xff2A75BC),
                        ]
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("登 陆",style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  ),
                ),
              ),
              SizedBox(height:16,),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: biggerTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          color: Color(0xff145C9E),
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //       //  isRepeatingAnimation: false,
              //       //alignment: Alignment.bottomLeft,
              //       //speed:Duration(milliseconds: 120),
              //       "⭐每日一句英语",
              //       style: TextStyle(
              //         fontFamily: 'Poppins',
              //         fontSize: 20,
              //         color: Color(0xff2A75BC),
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(" "),
              //     ),
              //     Text("${formatDate(now, [yyyy, '年', mm, '月', dd, '日'])}",
              //         style:TextStyle(
              //           fontSize:15,
              //           color: Color(0xff2A75BC),
              //           fontStyle: FontStyle.italic,
              //           height: 1.5,
              //         )),
              //     IconButton(
              //       icon: Icon(Icons.autorenew),
              //       onPressed: (){
              //             _toggleFavorite();
              //       },
              //       color: Color(0xff2A75BC),
              //     ),
              //
              //   ],
              // ),
              // FutureBuilder(
              //   future: getChatData(),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: Text('Loading...'),) ;
              //     } else {
              //       return ListView(
              //         shrinkWrap: true,
              //         children: snapshot.data.map<Widget>(
              //                 (item) {
              //               return Column(
              //                 children: <Widget>[
              //                   new Container(
              //                     child: TyperAnimatedTextKit(
              //                       alignment:Alignment.centerLeft,
              //                       isRepeatingAnimation: false,
              //                       speed:Duration(milliseconds: 120),
              //                       text:[item.en],
              //                       textStyle: TextStyle(
              //                         fontFamily: 'Poppins',
              //                         fontSize: 20,
              //                         color: Color(0xff2A75BC),
              //                       ),
              //                     ),
              //                   ),
              //                   new Container(
              //                     child: TyperAnimatedTextKit(
              //                       alignment:Alignment.centerLeft,
              //                       isRepeatingAnimation: false,
              //                       speed:Duration(milliseconds: 120),
              //                       text:[item.zh],
              //                       textStyle: TextStyle(
              //                         fontFamily: 'Poppins',
              //                         fontSize: 15,
              //                         color: Color(0xffaA75BC),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             }
              //         ).toList(),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
// class Chat {
//   final int code;
//   final String msg;
//   final List<Newslist> newslist;
//   Chat({this.code, this.msg,this.newslist});
//   //类似于initWithJson
//   factory Chat.fromJson(Map<String, dynamic> json) {
//     final originList = json['newslist'] as List;
//     List<Newslist> newslist =
//     originList.map((value) => Newslist.fromJson(value)).toList();
//     return Chat(
//         code: json['en'],
//         msg: json['zh'],
//         newslist:newslist);
//   }
// }
// class Newslist {
//   String en;
//   String zh;
//   Newslist({this.en, this.zh});
//   factory Newslist.fromJson(Map<String, dynamic> json) {
//     return Newslist(en: json['en'], zh: json['zh']);
//   }
// }