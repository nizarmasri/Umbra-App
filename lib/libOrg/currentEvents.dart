import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';

class CurrentEventsPage extends StatefulWidget {
  @override
  _CurrentEventsPageState createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  navigateToAddEventForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddEventForm())).then((value) => setState(() {}));
  }

  navigateToEventDetailsPage(
      String title,
      String description,
      String age,
      String type,
      String fee,
      String date,
      String time,
      String location,
      GeoPoint locationPoint,
      List<dynamic> urls) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  title: title,
                  description: description,
                  age: age,
                  type: type,
                  fee: fee,
                  date: date,
                  time: time,
                  location: location,
                  locationPoint: locationPoint,
                  urls: urls,
                )));
  }

  List<EventItem> eventItems = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  DateTime dateChecker;
  Future<List<QueryDocumentSnapshot>> getEvents() async {
    List<QueryDocumentSnapshot> events = [];
    await fb
        .collection("events")
        .where('poster', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        dateChecker = event.data()['date'].toDate();
        print(dateChecker.toString());
        if(dateChecker.isAfter(DateTime.now()))
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

          if(snapshot.data != null && snapshot.data.length != 0){
            snapshot.data.forEach((event) {
              DateTime date = event['date'].toDate();
              eventItems.add(EventItem(
                  title: event['title'],
                  description: event['description'],
                  age: event['age'],
                  type: event['type'],
                  fee: event['fee'],
                  time: event['time'],
                  date: DateFormat.MMMd().format(date),
                  location: event['locationName'],
                  locationPoint: event['location']['geopoint'],
                  urls: event['urls']));
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
                              "On-Going Events",
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
                                      eventItems[index].title,
                                      eventItems[index].description,
                                      eventItems[index].age,
                                      eventItems[index].type,
                                      eventItems[index].fee,
                                      eventItems[index].date,
                                      eventItems[index].time,
                                      eventItems[index].location,
                                      eventItems[index].locationPoint,
                                      eventItems[index].urls,
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      )),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.white10,
                onPressed: () {
                  navigateToAddEventForm();
                },
              ),
            );
          }

          else
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
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.white10,
                onPressed: () {
                  navigateToAddEventForm();
                },
              ),
            );

        });
  }
}
