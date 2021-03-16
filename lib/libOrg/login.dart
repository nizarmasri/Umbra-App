import 'package:events/globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:events/authentication_service.dart';
import 'package:provider/provider.dart';

import 'package:events/libOrg/signup.dart';

class LoginOrgPage extends StatefulWidget {
  @override
  _LoginOrgPageState createState() => _LoginOrgPageState();
}

class _LoginOrgPageState extends State<LoginOrgPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  double schedulerSize = 32;
  double inputSize = 17;
  double loginSize = 17;
  double googleSize = 15;
  double btnHeight = 60;

  //AssetImage icon = AssetImage('assets/icon/logo.png');

  navigateToSignUpOrgPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpOrgPage()));
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    double btnWidth = width * 0.9;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.05, bottom: height * 0.05),
                    child: RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "myEvents\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight,
                              fontSize: 35
                          ),
                        ),
                        TextSpan(
                          text: "Organizer",

                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight,
                              fontSize: 20
                          ),
                        )
                      ]),
                    ),
                  ),
                  Column(
                    children: [
                      // email field
                      Container(
                        height: btnHeight,
                        width: btnWidth,
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(bottom: 15),
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
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  border: InputBorder.none,
                                  focusColor: Colors.black,
                                  fillColor: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      // password field
                      Container(
                        height: btnHeight,
                        width: btnWidth,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
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
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  border: InputBorder.none,
                                  focusColor: Colors.black,
                                  fillColor: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      // login button
                      Container(
                          height: btnHeight,
                          width: btnWidth,
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white12),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: ProgressButton(
                            buttonState: ButtonState.normal,
                            progressColor: Colors.white12,
                            backgroundColor: Colors.blue[700],
                            onPressed: () {
                              Future<String> temp = context
                                  .read<AuthenticationService>()
                                  .signIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());

                              temp.then((String result) {
                                setState(() {
                                  msg = result;
                                });
                                print(msg);

                                if (msg == "Signed in") {
                                  msg = " ";
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: loginSize,
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight),
                            ),
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            msg,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          height: btnHeight,
                          width: btnWidth,
                          margin: EdgeInsets.only(bottom: 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () {
                              navigateToSignUpOrgPage();
                            },
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                ),
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                )
                              ]),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
