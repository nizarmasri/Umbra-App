import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/globals.dart' as globals;
import 'attendee.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

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
          },
        ),
      ),
    );
  }
}
