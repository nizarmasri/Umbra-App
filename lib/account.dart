import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'accountpage.dart';
import 'accountinfo.dart';
import 'authentication_service.dart';
import 'globals.dart' as globals;
import 'bookmarks.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  double btnHeight = 60;

  // Top widget
  Container NameAvatar(
      {String name, String email, Function page, String picture}) {
    return Container(
      margin: EdgeInsets.only(top: 40, right: 10, bottom: 20),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown.shade800,
              backgroundImage: picture != '' ? NetworkImage(picture) : null,
              child: Text(
                picture == '' ? name[0].toString().toUpperCase() : '',
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
                  style: TextStyle(fontSize: 21, color: Colors.white),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    page();
                  },
                  child: Text(
                    "View Account",
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Logout button
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
          stateWidgets: {
            ButtonState.idle: Text(
              "Log out",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
            ButtonState.loading: Text(
              "loading...",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
            ButtonState.success: Text(
              "Logged out",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
            ButtonState.fail: Text(
              "failed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
          },
          stateColors: {
            ButtonState.loading: Colors.white12,
            ButtonState.idle: Colors.black,
            ButtonState.success: Colors.green,
            ButtonState.fail: Colors.red
          },
          onPressed: () {
            context.read<AuthenticationService>().signOut();
          },

        ));
  }

  navigateToBookmark() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Bookmarks()));
  }

  navigateToAccountInfo() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountInfo()))
        .then((value) => setState(() {}));
  }

  navigateToAccountPageDetails() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountPageDetails()));
  }

  // Settings tile
  InkWell Setting({String title, IconData icon, Color color, Function page}) {
    return InkWell(
      onTap: () {
        page();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 25, 15),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text(title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.85;
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LiquidLinearProgressIndicator(
                value: 0.25, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.red,
                borderWidth: 5.0,
                borderRadius: 12.0,
                direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text("Loading..."),
              )
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.black,
            body: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                    Duration(
                      seconds: 1,
                    ), () {
                  setState(() {});
                });
              },
              child: ListView(children: [
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        NameAvatar(
                            name: snapshot.data["name"],
                            email: snapshot.data["email"],
                            page: navigateToAccountPageDetails,
                            picture: snapshot.data['dp']),
                        Container(
                          child: Column(
                            children: [
                              Setting(
                                title: "Saved",
                                icon: Icons.bookmark_outline,
                                page: navigateToBookmark,
                              ),
                              Setting(
                                  title: "Account Information",
                                  icon: Icons.account_circle_rounded,
                                  page: navigateToAccountInfo),
                              Setting(
                                title: "About",
                                icon: Icons.contact_mail,
                              ),
                              Setting(
                                title: "Guidelines",
                                icon: Icons.rule,
                              ),
                              Setting(
                                title: "Report",
                                icon: Icons.report,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            bottomNavigationBar:
                LogoutButton(width: btnWidth, height: btnHeight),
          );
        });
  }
}
