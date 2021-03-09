import 'globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:events/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String msg = "";
  String msgPassword = "";

  @override
  Widget build(BuildContext context) {
    double schedulerSize = 35;
    double inputSize = 17;
    double loginSize = 15;

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
              child: Container(
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.black,
                margin: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      color: Colors.black,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "myEvents",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: schedulerSize,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight),
                        ),
                      ),
                    )),
                    Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
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
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Center(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                        ),
                                        title: TextField(
                                          controller: passwordController,
                                          cursorColor: Colors.white,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
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
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        EdgeInsets.only(left: 30, right: 10),
                                    child: Text(
                                      msgPassword,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin:
                                            EdgeInsets.only(top: 20, bottom: 20),
                                        child: Center(
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                            title: TextField(
                                              controller:
                                                  confirmPasswordController,
                                              cursorColor: Colors.white,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: inputSize,
                                                  fontFamily: globals.montserrat,
                                                  fontWeight: globals.fontWeight),
                                              decoration: InputDecoration(
                                                  hintText: "Confirm password",
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
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.blue[900],
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: ProgressButton(
                                            buttonState: ButtonState.normal,
                                            progressColor: Colors.white12,
                                            backgroundColor: Colors.black,
                                            onPressed: () {
                                              if (passwordController.text !=
                                                  confirmPasswordController.text)
                                                setState(() {
                                                  msgPassword =
                                                  "Passwords don't match";
                                                });
                                              else {
                                                Future<String> temp = context
                                                    .read<AuthenticationService>()
                                                    .signUp(
                                                    email: emailController
                                                        .text
                                                        .trim(),
                                                    password:
                                                    passwordController
                                                        .text
                                                        .trim());

                                                temp.then((String result) {
                                                  if (result == "Invalid email")
                                                    setState(() {
                                                      msg = result;
                                                    });
                                                  else
                                                    Navigator.pop(context);
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: loginSize,
                                                  fontFamily: globals.montserrat,
                                                  fontWeight: globals.fontWeight),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: ProgressButton(
                                            buttonState: ButtonState.normal,
                                            progressColor: Colors.white12,
                                            backgroundColor: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                msg = "";
                                                msgPassword = "";
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Back",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: loginSize,
                                                      fontFamily:
                                                      globals.montserrat,
                                                      fontWeight:
                                                      globals.fontWeight),
                                                )
                                              ],
                                            ),
                                          ))),
                                ],
                              ),
                            ),

                          ],
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
