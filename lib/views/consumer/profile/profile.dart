import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final AsyncSnapshot? snapshot;

  ProfilePage({this.snapshot});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Your Profile",
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                height: 200,
                margin: EdgeInsets.only(bottom: 5.0),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.brown.shade800,
                      backgroundImage: snapshot!.data.data()['dp'].toString() !=
                              ''
                          ? NetworkImage(snapshot!.data.data()['dp'].toString())
                          : null,
                      child: Text(
                        snapshot!.data.data()['dp'].toString() == ''
                            ? snapshot!.data.data()["name"][0].toUpperCase()
                            : '',
                        style: TextStyle(fontSize: 55),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        snapshot!.data.data()["name"],
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                      snapshot!.data.data()["name"].split(" ")[0] +
                          " has attended " +
                          snapshot!.data.data()["attending"].length.toString() +
                          " events.",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              Card(
                color: Colors.grey[850],
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.grey[850],
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Contact",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20.5,
                                color: Colors.white),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      final uri = Uri(
                                        scheme: 'mailto',
                                        path: snapshot!.data.data()["email"],
                                        query:
                                            'subject=&body=', //add subject and body here
                                      );
                                      launch(uri.toString());
                                    },
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      launch(snapshot!.data.data()["twitter"]);
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.twitter,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      launch(snapshot!.data.data()["instagram"]);
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                //                   profEmail(widget.uid),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
