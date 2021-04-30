import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:events/globals.dart' as globals;
import 'attendee.dart';

class AttendeeList extends StatefulWidget {
  @override
  final id;

  const AttendeeList({Key key, this.id}) : super(key: key);
  _AttendeeListState createState() => _AttendeeListState(id);
}

class _AttendeeListState extends State<AttendeeList> {
  @override
  final id;
  _AttendeeListState(this.id);

  TextStyle temp = TextStyle(
    color: Colors.white,
    fontFamily: globals.montserrat,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Attendees"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("reservations")
              .doc(id)
              .collection("attendees")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader2,
                  color: Colors.white,
                ),
              );
            } else {
              if (snapshot != null) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Attendee(
                      data: snapshot.data.docs[index],
                      width: MediaQuery.of(context).size.width,
                      id: id,
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
