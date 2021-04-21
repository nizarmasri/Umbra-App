import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizerPage extends StatefulWidget {
  final organizeruid;

  const OrganizerPage({Key key, this.organizeruid}) : super(key: key);
  @override
  _OrganizerPageState createState() => _OrganizerPageState(organizeruid);
}

class _OrganizerPageState extends State<OrganizerPage> {
  final organizeruid;
  _OrganizerPageState(this.organizeruid);
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
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(organizeruid)
                  .get(),
              builder: (context, snapshot) {
                final url = snapshot.data.data()['dp'].toString();

                final Uri params = Uri(
                  scheme: 'mailto',
                  path: snapshot.data.data()["email"],
                  query: 'subject=&body=', //add subject and body here
                );
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(bottom: 5.0),
                      color: Colors.purple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.brown.shade800,
                            backgroundImage:
                                url != '' ? NetworkImage(url) : null,
                            child: Text(
                              url == ''
                                  ? snapshot.data
                                      .data()["name"][0]
                                      .toUpperCase()
                                  : '',
                              style: TextStyle(fontSize: 55),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              snapshot.data.data()["name"],
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Organizer",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
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
                                            launch(params.toString());
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
                                            launch(snapshot.data
                                                .data()["twitter"]);
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
                                            launch(snapshot.data
                                                .data()["instagram"]);
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.instagram,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            onPressed: () {
                                              launch("tel://" +
                                                  snapshot.data
                                                      .data()["number"]);
                                            },
                                            icon: Icon(
                                              Icons.phone,
                                              color: Colors.blue,
                                            )),
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
                );
              }),
        ),
      ),
    );
  }
}
