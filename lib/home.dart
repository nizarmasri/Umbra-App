import 'package:awesome_loader/awesome_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/foryouItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'globals.dart' as globals;
import 'package:events/libOrg/services/geolocator_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:events/libOrg/eventDetails.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;

  List<Container> containers = [
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.white,
    )
  ];

  double imageSize = 0;

  final geo = Geoflutterfire();

  Position _currentPosition = null;

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(data: data,)));
  }

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String dateConverter(Timestamp eventDate, String time) {
    DateTime converted = eventDate.toDate();
    return months[converted.month] +
        " " +
        converted.day.toString() +
        ", " +
        converted.year.toString() +
        " @ " +
        time;
  }

  List<EventItem> foryouItems = [];
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getForyouEvents() async {
    List<QueryDocumentSnapshot> events = [];

    await fb
        .collection("events")
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
    double width = MediaQuery.of(context).size.width;
    double featureCarouselHeight = height * 0.5;
    double foryouCarouselHeight = height * 0.33;
    double nearyouCarouselHeight = height * 0.3;
    double infoHeight = height * 0.25;

    return _currentPosition != null
        ? Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                child: ListView(
                  children: [
                    // Featured text

                    // Featured carousel
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("events")
                          .limit(4)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        } else {
                          return Container(
                            child: GFCarousel(
                              height: featureCarouselHeight,
                              enableInfiniteScroll: true,
                              viewportFraction: 1.0,
                              activeIndicator: Colors.white,
                              pagination: true,
                              items: snapshot.data.docs.map(
                                (con) {
                                  return Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: Stack(children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white10,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      !con["urls"].isEmpty
                                                          ? con["urls"][0]
                                                          : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                                                    ),
                                                    fit: BoxFit.fill)),
                                            child: Container()),
                                        Container(
                                          color: Colors.black38,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 30, top: 30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                con["title"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        globals.montserrat,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30),
                                              ),
                                              Text(
                                                dateConverter(
                                                    con["date"], con["time"]),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        globals.montserrat,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                con["locationName"]
                                                    .split(",")[0],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        globals.montserrat,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                                },
                              ).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  index;
                                });
                              },
                            ),
                          );
                        }
                      },
                    ),
                    // Near you text
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Near You",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              //fontWeight: globals.fontWeight,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // Near You carousel
                    StreamBuilder(
                        stream: geo
                            .collection(
                                collectionRef: FirebaseFirestore.instance
                                    .collection('events'))
                            .within(
                                center: geo.point(
                                    latitude: _currentPosition.latitude,
                                    longitude: _currentPosition.longitude),
                                radius: 10,
                                field: "location"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Text(
                              "No events near you",
                              style: TextStyle(color: Colors.white),
                            );
                          } else {
                            List<NearyouItem> ads = [];
                            var j;
                            if (snapshot.data.length > 5) {
                              j = 5;
                            } else {
                              j = snapshot.data.length;
                            }
                            for (var i = 0; i < j; i++) {
                              ads.add(NearyouItem(data: snapshot.data[i]));
                            }
                            return Container(
                              child: GFCarousel(
                                height: nearyouCarouselHeight,
                                enableInfiniteScroll: true,
                                viewportFraction: 0.8,
                                activeIndicator: Colors.white,
                                items: ads.map(
                                  (con) {
                                    return Container(child: con);
                                  },
                                ).toList(),
                                onPageChanged: (index) {},
                              ),
                            );
                          }
                        }),
                    // For you text
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "For You",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              //fontWeight: globals.fontWeight,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    // For You carousel
                    FutureBuilder(
                      future: getForyouEvents(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return Center(
                            child: AwesomeLoader(
                              loaderType: AwesomeLoader.AwesomeLoader2,
                              color: Colors.white,
                            ),
                          );
                        }

                        if (snapshot.data != null && snapshot.data.length != 0){
                          snapshot.data.forEach((event) {
                            foryouItems.add(EventItem(
                              data: event,
                            ));
                          });
                          return Container(
                            height: height,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),                              itemCount: foryouItems.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: foryouItems[index],
                                  onTap: () {
                                    navigateToEventDetailsPage(
                                        foryouItems[index].data);
                                  },
                                );
                              },
                            ),
                          );
                        }

                        else
                          return Container();

                      },
                    ),

                  ],
                ),
              ),
            ),
          )
        : globals.spinner;
  }
}
