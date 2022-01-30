import 'dart:async';

import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/consumer/search/search_result_item.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchString;

  SearchResultsPage({Key key, this.searchString}) : super(key: key);

  @override
  _SearchResultsPageState createState() =>
      _SearchResultsPageState(searchString);
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final String searchString;

  _SearchResultsPageState(this.searchString);

  String searchStringFormatted = '';

  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  data: data,
                ))).then((value) => setState(() {}));
  }

  List<SearchResultItem> eventItems = [];

  void searchStringFormat() {
    searchStringFormatted = searchString.trim().toUpperCase();
  }

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  DateTime dateChecker;

  Future<List<QueryDocumentSnapshot>> getEvents() async {
    eventItems = [];
    List<QueryDocumentSnapshot> events = [];
    searchStringFormat();
    String descSearch = "";
    String titleSearch = "";
    String ageSearch = "";
    String typeSearch = "";
    String locationSearch = "";
    String feeSearch = "";

    await fb
        .collection("events")
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .get()
        .then((value) {
      value.docs.forEach((event) {
        descSearch = event.data()['description'].toUpperCase();
        titleSearch = event.data()['title'].toUpperCase();
        ageSearch = event.data()['age'].toUpperCase();
        typeSearch = event.data()['type'].toUpperCase();
        locationSearch = event.data()['locationName'].toUpperCase();
        feeSearch = event.data()['fee'].toUpperCase();

        if (event.data().containsValue(searchString) ||
            descSearch.contains(searchStringFormatted) ||
            titleSearch.contains(searchStringFormatted) ||
            typeSearch.contains(searchStringFormatted) ||
            locationSearch.contains(searchStringFormatted) ||
            ageSearch.contains(searchStringFormatted) ||
            feeSearch.contains(searchStringFormatted)) events.add(event);
      });
    });
    events.sort((a, b) => a['date'].compareTo(b['date']));
    return events;
  }

  String _sortBy = 'Ascending';

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

          if (snapshot.data != null && snapshot.data.length != 0) {
            eventItems = [];
            snapshot.data.forEach((event) {
              eventItems.add(SearchResultItem(
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
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  searchString,
                  style: TextStyle(
                      fontFamily: globals.montserrat,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      // Sort menu
                      Container(
                        padding: EdgeInsets.only(left: 15),
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
                                //margin: EdgeInsets.only(left: 5),
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
                        child: ListView.builder(
                          itemCount: eventItems.length,
                          itemBuilder: (context, index) {
                            return eventItems[index];
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
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  searchString,
                  style: TextStyle(
                      fontFamily: globals.montserrat,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(30),
                    child: Text(
                      "No events found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: globals.montserrat,
                          fontWeight: globals.fontWeight,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
        });
  }
}
