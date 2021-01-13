import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'chatrooms.dart';
import 'package:chatapp/helper/helperfunctions.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override

  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  //HelperFunctions helperFunctions= new HelperFunctions();
  @override
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEdittingController = new TextEditingController();
  TextEditingController emailTextEdittingController = new TextEditingController();
  TextEditingController passwordTextEdittingController = new TextEditingController();
  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String,String> userInfoMap={
        "name":usernameTextEdittingController.text,
        "email":emailTextEdittingController.text,
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEdittingController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameTextEdittingController.text);
        setState(() {
          isLoading=true;
        });

        authMethods.signUpWithEmailAndPassword(emailTextEdittingController.text,
            passwordTextEdittingController.text).then((val) {
            databaseMethods.uploadUserInfo(userInfoMap);
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>ChatRoom()
            ));
        });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
    //  appBar: appBarMain((context)),
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :  Container(
      //  height: MediaQuery.of(context).size.height-100,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
            children: [
              Spacer(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child:Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Hero(
                            tag: 'heroicon',
                            child: Icon(
                              Icons.textsms,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Hero(
                            tag: 'HeroTitle',
                            child: TyperAnimatedTextKit(
                              isRepeatingAnimation: false,
                              speed:Duration(milliseconds: 120),
                              text:["Chatter".toUpperCase()],
                              textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 40,
                                color:Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TyperAnimatedTextKit(
                      isRepeatingAnimation: false,
                      speed:Duration(milliseconds: 120),
                      text:["⭐曾莹的期末作业线上聊天App⭐".toUpperCase()],
                      textStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Color(0xff145C9E),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextFormField(
                      style: biggerTextStyle(),
                      controller: usernameTextEdittingController,
                      validator: (val){
                        return val.isEmpty || val.length <2 ? "Enter Username 3+ characters" : null;
                      },
                      decoration: textFieldInputDecoration("username",Icon(Icons.account_circle)),
                    ),
                    TextFormField(
                      controller: emailTextEdittingController,
                      style: biggerTextStyle(),
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      decoration: textFieldInputDecoration("email",Icon(Icons.email)),
                    ),
                    TextFormField(
                      obscureText: true,  //密码不可见
                      validator:  (val){
                        return val.length > 6 ? null:"Enter Password 6+ characters" ;
                      },
                      controller: passwordTextEdittingController,
                      style: biggerTextStyle(),
                      decoration: textFieldInputDecoration("password",Icon(Icons.check_circle)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: (){
                  signMeUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors:[
                            const Color(0xff00baF4),
                            const Color(0xff2A75BC),
                          ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "注 册",
                    style: simpleTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: ttTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Text(
                      "SignIn now",
                      style: TextStyle(
                          color: Color(0xff145C9E),
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
      ),
    );
  }
}
