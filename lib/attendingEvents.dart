import 'package:events/attendNavigator.dart';
import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AttendingEventsPage extends StatefulWidget {
  @override
  _AttendingEventsPageState createState() => _AttendingEventsPageState();
}

class _AttendingEventsPageState extends State<AttendingEventsPage> {
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
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) events.add(event);
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
            DateTime dateChecker = event.data()['date'].toDate();
            if (dateChecker.isAfter(DateTime.now())) events.add(event);
          });
        });
      }
      events.sort((a, b) => b['date'].compareTo(a['date']));

    }
    else if(eventIds.length > 0){
      await fb
          .collection("events")
          .where('__name__', whereIn: eventIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) events.add(event);
        });
      });
      events.sort((a, b) => b['date'].compareTo(a['date']));
    }
    else {
      events = null;
    }


    return events;
  }

  String _sortBy = 'Ascending';

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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<Null> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

    setState(() {   });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double listHeight = height * 0.75;

    eventItems = [];

    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {


          if (snapshot.data != null) {
            if (!snapshot.hasData) {
              return Center(
                child: globals.spinner,
              );
            }
            eventItems = [];
            snapshot.data.forEach((event) {
              eventItems.add(EventItem(
                data: event,
                key: Key(event['title'] + event['date'].toString()),
              ));
            });

            if (_sortBy == 'Descending')
              eventItems
                  .sort((a, b) => b.data['date'].compareTo(a.data['date']));
            else if (_sortBy == 'Ascending')
              eventItems
                  .sort((a, b) => a.data['date'].compareTo(b.data['date']));

            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Sort by ",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  //color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.grey[900],
                                    value: _sortBy,
                                    style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontSize: 15,
                                      fontWeight: globals.fontWeight,
                                      color: Colors.white,
                                    ),
                                    //elevation: 5,
                                    items: <String>[
                                      'Ascending',
                                      'Descending',
                                    ].map<DropdownMenuItem<String>>(
                                            (String sorting) {
                                          return DropdownMenuItem<String>(
                                            value: sorting,
                                            child: Text(sorting),
                                          );
                                        }).toList(),
                                    hint: Text(
                                      _sortBy,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: globals.fontWeight,
                                          fontFamily: globals.montserrat),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _sortBy = value;
                                      });
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        height: listHeight,
                        child: SmartRefresher(
                          enablePullDown: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
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
                        ),
                      )
                    ],
                  )),
                ),
              ),
            );
          }
          else
            return Scaffold(
              body: SafeArea(
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(30),
                      child: Text(
                        "You are not attending any events",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
        });
  }
}
