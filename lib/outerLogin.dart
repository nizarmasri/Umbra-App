import 'globals.dart' as globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/authentication_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:events/signup.dart';
import 'login.dart';

class outerLogin extends StatefulWidget {
  @override
  _outerLoginState createState() => _outerLoginState();
}

class _outerLoginState extends State<outerLogin> {

  double btnHeight = 60;
  
  navigateToSignUpPage() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => SignUpPage())
    );
  }
  navigateToSignInPage() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginPage())
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.85;
    return Scaffold(
      
      backgroundColor: Colors.black,

      body: Center(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: height*0.1),
                child: Text(
                  "Logo",
                  style: globals.style
                ),
              ),
            ),
            
            Expanded(
              child:Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: btnHeight,
                      width: btnWidth,
                      margin: EdgeInsets.only(
                        bottom: 15
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white12),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12)
                            )
                          )
                        ),
                        onPressed: () {
                          navigateToSignUpPage();
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.white,
                            //  fontSize: loginSize,
                              fontFamily:globals.montserrat,
                              fontWeight:globals.fontWeight
                          ),
                        ),
                      )
                    ),
                    Container(
                      height: btnHeight,
                      width: btnWidth,
                      margin: EdgeInsets.only(
                        bottom: 15
                      ),
                      child: ElevatedButton.icon(
                        icon: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.white38,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12)
                            )
                          )
                        ),
                        onPressed: () {

                        },
                        label: Text(
                          "Sign in with Facebook",
                          style: TextStyle(
                              color: Colors.white,
                            //  fontSize: loginSize,
                              fontFamily:globals.montserrat,
                              fontWeight:globals.fontWeight
                          ),
                        ),
                      )
                    ),
                    Container(
                      height: btnHeight,
                      width: btnWidth,
                      margin: EdgeInsets.only(
                        bottom: 10
                      ),
                      child: ElevatedButton.icon(

                        icon: FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white38,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12)
                            )
                          )
                        ),
                        onPressed: () {
                          Future<String> temp = context
                              .read<AuthenticationService>()
                              .signInWithGoogle();
                        },
                        label: Text(
                          "Sign in with Google",
                          style: TextStyle(
                              color: Colors.white,
                            //  fontSize: loginSize,
                              fontFamily:globals.montserrat,
                              fontWeight:globals.fontWeight
                          ),
                        ),
                      )
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: btnHeight,
                      width: btnWidth,
                      margin: EdgeInsets.only(
                        bottom: 10
                      ),
                      child:ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black)
                            )
                          )
                        ),
                        onPressed: (){
                          navigateToSignInPage();
                        },
                        child:Text(
                          "Log in",

                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:globals.montserrat,
                            fontWeight:globals.fontWeight
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),           
            )
          ],
        ),
      ) 
    );
  }
}
