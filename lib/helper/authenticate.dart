
import 'package:chatapp/view/signin.dart';
import 'package:chatapp/view/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true; //初始页面

  void toggleView() { //检查登陆
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override

  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
