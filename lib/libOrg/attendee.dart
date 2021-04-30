import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendee extends StatefulWidget {
  final width;
  final data;
  final id;
  const Attendee({Key key, this.width, this.data, this.id}) : super(key: key);
  @override
  _AttendeeState createState() =>
      _AttendeeState(this.width, this.data, this.id);
}

class _AttendeeState extends State<Attendee> {
  @override
  final width;
  final data;
  final id;
  _AttendeeState(this.width, this.data, this.id);
  int confirmed;

  void initState() {
    setState(() {
      confirmed = data['confirmed'];
    });
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 15),
        //color: Colors.red,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        width: width,
        child: Row(children: [
          GestureDetector(
            onTap: () {
              print("WEQ");
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 30,
                child: data["dp"] == ""
                    ? Text(
                        data["name"][0],
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight,
                            fontSize: 30,
                            color: Colors.white),
                      )
                    : null,
                backgroundImage:
                    data['dp'] != '' ? NetworkImage(data['dp']) : null,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("WE");
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: globals.montserrat,
                          fontSize: 16),
                    ),
                    Text(
                      data["amount"].toString() + " tickets",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: globals.montserrat,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
          confirmed == 0
              ? Row(
                  children: [
                    Container(
                      child: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('reservations')
                                .doc(id)
                                .collection("attendees")
                                .doc(data.id)
                                .update({'confirmed': 1});
                            setState(() {
                              confirmed = 1;
                            });
                          },
                          icon: Icon(
                            Icons.check_circle_outline,
                            size: 35,
                            color: Colors.green,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 3),
                      child: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('reservations')
                                .doc(id)
                                .collection("attendees")
                                .doc(data.id)
                                .update({'confirmed': -1});
                            setState(() {
                              confirmed = -1;
                            });
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 35,
                            color: Colors.red,
                          )),
                    ),
                  ],
                )
              : confirmed == 1
                  ? Container(
                      child: Text("Confirmed",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      margin: EdgeInsets.only(right: 10),
                    )
                  : Container(
                      child: Text("Rejected",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      margin: EdgeInsets.only(right: 10),
                    )
        ]));
  }
}
