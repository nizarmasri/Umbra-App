import 'package:events/globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:events/views/authentication/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpOrgPage extends StatefulWidget {
  @override
  _SignUpOrgPageState createState() => _SignUpOrgPageState();
}

class _SignUpOrgPageState extends State<SignUpOrgPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String msg = "";
  String msgPassword = "";

  double schedulerSize = 35;
  double inputSize = 17;
  double loginSize = 15;
  double btnHeight = 60;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: globals.background,
                fit: BoxFit.fill,
              )),
          child: Container(
            color: Colors.black87,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.05, bottom: height * 0.05),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "u",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 110,
                                  color: Colors.white24)),
                          TextSpan(
                              text: "mbra",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 30,
                                  color: Colors.white70)),
                          TextSpan(
                            text: "\nOrganizer",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 20),
                          )
                        ]),
                      ),
                    ),
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
                    // Password
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
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                border: InputBorder.none,
                                focusColor: Colors.black,
                                fillColor: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    // Confirm Password
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
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          title: TextField(
                            controller: confirmPasswordController,
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
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                border: InputBorder.none,
                                focusColor: Colors.black,
                                fillColor: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    // Sign up btn
                    Container(
                        height: btnHeight,
                        width: btnWidth,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: ProgressButton(
                          stateWidgets: {
                            ButtonState.idle: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: loginSize,
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight),
                            )
                          },
                          stateColors: {
                            ButtonState.loading: Colors.white12,
                            ButtonState.idle: Colors.black
                          },
                          onPressed: () {
                            if (passwordController.text !=
                                confirmPasswordController.text)
                              setState(() {
                                msgPassword = "Passwords don't match";
                              });
                            else {
                              Future<String> temp = context
                                  .read<AuthenticationService>()
                                  .signUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      organizer: true);

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
                        )),
                    // Email error message
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
                    // Password error message
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          msgPassword,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
