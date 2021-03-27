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

  Container NameAvatar({String name, String email}) {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 10, right: 10),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown.shade800,
              child: Text(
                name[0].toString().toUpperCase(),
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 23, color: Colors.white),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container LogoutButton({double width, double height}) {
    return Container(
        height: height,
        width: width,
        margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
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
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    NameAvatar(
                        name: snapshot.data.data()["name"],
                        email: snapshot.data.data()["email"]),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                LogoutButton(width: btnWidth, height: btnHeight),
          );
        });
  }
}
