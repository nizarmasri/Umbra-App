import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';

import 'package:events/authentication_service.dart';
import 'package:events/globals.dart' as globals;

class AccountOrgPage extends StatefulWidget {
  @override
  _AccountOrgPageState createState() => _AccountOrgPageState();
}

class _AccountOrgPageState extends State<AccountOrgPage> {
  double btnHeight = 60;

  Container LogoutButton({double width, double height}) {
    return Container(
        height: height,
        width: width,
        margin: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            color: Colors.black,
            borderRadius: BorderRadius.circular(10)),
        child: ProgressButton(
          buttonState: ButtonState.normal,
          progressColor: Colors.white12,
          backgroundColor: Colors.black,
          onPressed: () {
            context.read<AuthenticationService>().signOut();
          },
          child: Text(
            "Log out",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: globals.montserrat,
                fontWeight: globals.fontWeight),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.85;
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.red),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              child: Text(snapshot.data
                                  .data()["name"][0]
                                  .toString()
                                  .toUpperCase()),
                            ),
                          ),
                          Text(
                            snapshot.data.data()["name"],
                            style: TextStyle(fontSize: 23, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Account Page",
                      style: globals.style,
                    ),
                    LogoutButton(width: btnWidth, height: btnHeight)
                  ],
                ),
              ),
            ),
          );
        }
        /*    child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account Page",
                  style: globals.style,
                ),
                LogoutButton(width: btnWidth, height: btnHeight)
              ],
            ),
          ),
        ),
      ),*/
        );
  }
}
