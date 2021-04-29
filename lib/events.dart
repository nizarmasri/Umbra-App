import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  navigateToAddEventForm() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEventForm()))
        .then((value) => setState(() {}));
  }

  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  data: data,
                )));
  }

  List<EventItem> eventItems = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  DateTime dateChecker;

  Future<List<QueryDocumentSnapshot>> getEvents() async {
    List<QueryDocumentSnapshot> events = [];
    List<dynamic> eventIds = [];

    await fb.collection('users').doc(uid).get().then((value) {
      eventIds = value.data()['attending'];
    });

    // Handles up to 20 events attending
    // Loop code for > 20 not implemented
    if (eventIds.length > 10) {
      List<dynamic> currentList = [];
      for (int i = 0; i < 10; i++) {
        currentList.add(eventIds[i]);
      }
      await fb
          .collection("events")
          .where('__name__', whereIn: currentList)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          events.add(event);
        });
      });

      int currentSize = eventIds.length - 10;
      if (currentSize > 10) {
        bool isLessThanTen = false;
        while (isLessThanTen == false) {}
      } else if (currentSize > 0) {
        currentList = [];
        for (int i = 10; i < currentSize + 10; i++) {
          currentList.add(eventIds[i]);
        }
        await fb
            .collection("events")
            .where('__name__', whereIn: currentList)
            .get()
            .then((value) {
          value.docs.forEach((event) {
            events.add(event);
          });
        });
      }
    }
    else {
      await fb
          .collection("events")
          .where('__name__', whereIn: eventIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          events.add(event);
        });
      });
    }

    return events;
  }

  List<List<dynamic>> listDivisions(List<dynamic> list) {
    List<List<dynamic>> dividedList;
    if (list.length >= 10) {
      int arraySize = list.length - 10;
      int divisions = 1;
      bool isLessThanTen;
      if (arraySize >= 10) isLessThanTen = false;
      while (isLessThanTen == false) {
        if (arraySize >= 10) {
          arraySize -= 10;
          divisions++;
        } else
          isLessThanTen = true;
      }

      for (int i = 0; i < divisions; i++) {}
      print(divisions);
    }
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
              eventItems.add(EventItem(
                data: event,
              ));
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
                          "Attending Events",
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
                          "Attending Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          "You are not attending any events",
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
