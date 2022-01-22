import 'globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/authentication_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:events/libOrg/signup.dart';

import 'package:events/signup.dart';
import 'views/login.dart';

class OuterLogin extends StatefulWidget {
  @override
  _OuterLoginState createState() => _OuterLoginState();
}

class _OuterLoginState extends State<OuterLogin> {

  navigateToSignUpPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  navigateToSignInPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  navigateToOrgSignupPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpOrgPage()));
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double body = height * 0.9;
    double btnWidth = width * 0.85;
    double btnHeight = height * 0.07;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: globals.background,
                fit: BoxFit.fill,
              )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[Colors.black87, Colors.black87])),
            child: Center(
              child: Container(
                height: body,
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Logo
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.15),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "u",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 110,
                                  color: Colors.white24
                              )
                          ),
                          TextSpan(
                              text: "mbra",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 30,
                                  color: Colors.white70
                              )
                          )]),
                      ),
                    ),
                    // Sign up
                    Container(
                        height: btnHeight,
                        width: btnWidth,
                        margin: EdgeInsets.only(bottom: 15),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white12),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.white12)))),
                          onPressed: () {
                            navigateToSignUpPage();
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                //  fontSize: loginSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        )),
                    // google
                    Container(
                        height: btnHeight,
                        width: btnWidth,
                        margin: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.blueGrey,
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.white12)))),
                          onPressed: () {
                            Future<String> temp = context
                                .read<AuthenticationService>()
                                .signInWithGoogle();
                            temp.then((String result) {
                              if (result == "Signed in")
                                globals.isOrg = false;
                            });
                          },
                          label: Text(
                            "Sign in with Google",
                            style: TextStyle(
                                color: Colors.white,
                                //  fontSize: loginSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        )),
                    // facebook

                    // login
                    Container(
                        alignment: Alignment.center,
                        height: btnHeight,
                        width: btnWidth,
                        margin: EdgeInsets.only(bottom: 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                          ),
                          onPressed: () {
                            navigateToSignInPage();
                          },
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              ),
                              TextSpan(
                                text: "Log in",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              )
                            ]),
                          ),
                        )),
                    Divider(
                      color: Colors.white24,
                      thickness: 0.3,
                      indent: 20,
                      endIndent: 20,
                    ),
                    // organizer
                    Container(
                        alignment: Alignment.center,
                        height: btnHeight,
                        width: btnWidth,
                        //margin: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                          ),
                          onPressed: () {
                            navigateToOrgSignupPage();
                          },
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Sign up as ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              ),
                              TextSpan(
                                text: "Organizer",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              )
                            ]),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
