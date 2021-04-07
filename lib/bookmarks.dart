import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'authentication_service.dart';
import 'globals.dart' as globals;

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  Widget item(DocumentSnapshot event) {
    return Container(
      child: Text(
        event.data()["title"],
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  List<Widget> addItems(List<QueryDocumentSnapshot> events) {
    List<Widget> newEvents = [];
    events.forEach((element) {
      newEvents.add(item(element));
    });
    return newEvents;
  }

  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Bookmarks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .get()
              .then((value) {
            return FirebaseFirestore.instance
                .collection("events")
                .where("__name__", whereIn: value.data()["booked"])
                .get();
          }),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Column(
              children: addItems(snapshot.data.docs),
            );
          }),
    );
  }
}
