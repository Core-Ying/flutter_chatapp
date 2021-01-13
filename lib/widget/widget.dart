import 'package:flutter/material.dart';
//构建上下文
Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png", height: 40,
    ),
    elevation: 0.0,
    backgroundColor:Color(0xff145C9E),
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText,Icon test) {
  return InputDecoration(
      icon:test,
      hintText: hintText,
      hintStyle: TextStyle(color:Color(0xff2A75BC)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Color(0xff145C9E), fontSize: 17);
}
//const Color(0xff2A75BC)
TextStyle ttTextStyle() {
  return TextStyle(color: Color(0xff2A75BC), fontSize: 17);
}
