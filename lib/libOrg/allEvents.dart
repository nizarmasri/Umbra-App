import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';

class AllEventsPage extends StatefulWidget {
  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  navigateToAddEventForm() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEventForm()))
        .then((value) => setState(() {}));
  }


  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(data: data,)));
  }

  List<EventItem> eventItems = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getEvents() async {
    List<QueryDocumentSnapshot> events = [];
    await fb
        .collection("events")
        .where('poster', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        events.add(event);
      });
    });
    return events;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double listHeight = height * 0.8;

    eventItems = [];

    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader2,
                color: Colors.white,
              ),
            );
          }

          if (snapshot.data != null && snapshot.data.length != 0) {
            snapshot.data.forEach((event) {
              eventItems.add(EventItem(data: event,));
            });

            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "All Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: listHeight,
                        child: ListView.builder(
                          itemCount: eventItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: eventItems[index],
                              onTap: () {
                                navigateToEventDetailsPage(
                                    eventItems[index].data);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  )),
                ),
              ),
            );
          } else
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Current Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          "You do not have any events in progress",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        });
  }
}
