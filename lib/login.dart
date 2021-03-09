import 'globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:events/authentication_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:events/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  double schedulerSize = 32;
  double inputSize = 17;
  double loginSize = 17;
  double googleSize = 15;

  //AssetImage icon = AssetImage('assets/icon/logo.png');

  navigateToSignUpPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  String msg = "";

  TextStyle signUpStyle1 = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300);
  TextStyle signUpStyle2 = TextStyle(
      color: Colors.red,
      fontSize: 15,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.black,
                  child: Column(children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.black,
                        )),
                    Expanded(
                      flex: 4,
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Container()),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "myEvents",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: schedulerSize,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight),
                        ),
                      ),
                    ),
                  ]),
                )),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.black,
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
                child: Column(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.email_outlined,
                                          color: Colors.white,
                                        ),
                                        title: TextField(
                                          controller: emailController,
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: inputSize,
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight),
                                          decoration: InputDecoration(
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: inputSize,
                                                  fontFamily:
                                                      globals.montserrat,
                                                  fontWeight:
                                                      globals.fontWeight),
                                              border: InputBorder.none,
                                              focusColor: Colors.black,
                                              fillColor: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 0, right: 10),
                                    child: Text(
                                      msg,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(top: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                        ),
                                        title: TextField(
                                          controller: passwordController,
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: inputSize,
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight),
                                          decoration: InputDecoration(
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: inputSize,
                                                  fontFamily:
                                                      globals.montserrat,
                                                  fontWeight:
                                                      globals.fontWeight),
                                              border: InputBorder.none,
                                              focusColor: Colors.black,
                                              fillColor: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                      // login button
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue[900],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              top: 23, bottom: 23),
                                          child: ProgressButton(
                                            buttonState: ButtonState.normal,
                                            progressColor: Colors.white12,
                                            backgroundColor: Colors.blue[700],
                                            onPressed: () {
                                              Future<String> temp = context
                                                  .read<AuthenticationService>()
                                                  .signIn(
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim());

                                              temp.then((String result) {
                                                setState(() {
                                                  msg = result;
                                                });
                                                print(msg);
                                              });
                                            },
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: loginSize,
                                                  fontFamily:
                                                      globals.montserrat,
                                                  fontWeight:
                                                      globals.fontWeight),
                                            ),
                                          ))),
                                  Expanded(
                                    // google sign in
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[900],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.only(
                                            top: 23, bottom: 23),
                                        child: ProgressButton(
                                          backgroundColor: Colors.blue,
                                          onPressed: () {
                                            Future<String> temp = context
                                                .read<AuthenticationService>()
                                                .signInWithGoogle();
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.google,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                "  Sign in with Google",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    globals.fontWeight,
                                                    fontFamily:
                                                    globals.montserrat,
                                                    fontSize: googleSize),
                                              ),
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          navigateToSignUpPage();
                          setState(() {
                            msg = "";
                          });
                        },
                        child: Container(
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "Don't have an account yet? ",
                                    style: signUpStyle1),
                                TextSpan(text: "Sign up", style: signUpStyle2),
                              ]),
                            )),
                      ),
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
