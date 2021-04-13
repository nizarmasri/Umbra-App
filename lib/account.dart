import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'accountpage.dart';
import 'accountinfo.dart';
import 'authentication_service.dart';
import 'globals.dart' as globals;
import 'bookmarks.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  double btnHeight = 60;
  Container NameAvatar(
      {String name, String email, Function page, String picture}) {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
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
                  style: TextStyle(fontSize: 23, color: Colors.white),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.white),
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

  InkWell Setting({String title, IconData icon, Color color, Function page}) {
    return InkWell(
      onTap: () {
        page();
      },
      child: Container(
        decoration: BoxDecoration(color: color),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 25, 15),
              child: Icon(
                icon,
                size: 40,
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.85;
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                            name: snapshot.data.data()["name"],
                            email: snapshot.data.data()["email"],
                            page: navigateToAccountPageDetails,
                            picture: snapshot.data.data()['dp']),
                        Container(
                          child: Column(
                            children: [
                              Setting(
                                title: "Bookmarks",
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
