import 'package:awesome_loader/awesome_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:events/libOrg/eventItem.dart';
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

  List<GFListTile> tiles = [
    GFListTile(
      avatar: GFImageOverlay(
        height: 100,
        width: 100,
        image: NetworkImage(
            'https://st2.depositphotos.com/7867872/10618/i/950/depositphotos_106182598-stock-photo-night-club-party-event-concert.jpg'),
      ),
      title: Text(
        "The One",
        style: TextStyle(
            fontFamily: globals.montserrat, fontSize: 17, color: Colors.white),
      ),
      subtitle: Text(
        "Club\nBeirut",
        style: TextStyle(
            fontFamily: globals.montserrat,
            fontSize: 15,
            fontWeight: globals.fontWeight,
            color: Colors.white),
      ),
      color: Colors.white12,
    ),
    GFListTile(
      avatar: Container(
        color: Colors.green,
      ),
      title: Text(
        "Pub",
        style: TextStyle(
            fontFamily: globals.montserrat, fontSize: 14, color: Colors.white),
      ),
      subtitle: Text(
        "Mar Mikhael",
        style: TextStyle(
            fontFamily: globals.montserrat,
            fontSize: 13,
            fontWeight: globals.fontWeight,
            color: Colors.white),
      ),
      color: Colors.white12,
    ),
    GFListTile(
      avatar: Container(
        color: Colors.red,
      ),
      title: Text(
        "Gig",
        style: TextStyle(
            fontFamily: globals.montserrat, fontSize: 14, color: Colors.white),
      ),
      subtitle: Text(
        "Hazmieh",
        style: TextStyle(
            fontFamily: globals.montserrat,
            fontSize: 13,
            fontWeight: globals.fontWeight,
            color: Colors.white),
      ),
      color: Colors.white12,
    ),
    GFListTile(
      avatar: Container(
        color: Colors.white,
      ),
      title: Text(
        "Pub",
        style: TextStyle(
            fontFamily: globals.montserrat, fontSize: 14, color: Colors.white),
      ),
      subtitle: Text(
        "Badaro",
        style: TextStyle(
            fontFamily: globals.montserrat,
            fontSize: 13,
            fontWeight: globals.fontWeight,
            color: Colors.white),
      ),
      color: Colors.white12,
    )
  ];

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
      List<dynamic> urls,
      String id,
      String posteruid) {
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
                  id: id,
                  posteruid: posteruid,
                )));
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double featureCarouselHeight = height * 0.5;
    double foryouCarouselHeight = height * 0.33;
    double nearyouCarouselHeight = height * 0.35;
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
                    // For you text
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
                    // For You carousel
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
                            List<Container> ads = [];
                            var j;
                            if (snapshot.data.length > 5) {
                              j = 5;
                            } else {
                              j = snapshot.data.length;
                            }
                            for (var i = 0; i < j; i++) {
                              if (!snapshot.data[i]["urls"].isEmpty) {
                                ads.add(Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data[i]["urls"][0]),
                                            fit: BoxFit.fill)),
                                    child: GestureDetector(
                                        onTap: () {
                                          DateTime date =
                                              snapshot.data[i]['date'].toDate();
                                          navigateToEventDetailsPage(
                                              snapshot.data[i]["title"],
                                              snapshot.data[i]["description"],
                                              snapshot.data[i]["age"],
                                              snapshot.data[i]["type"],
                                              snapshot.data[i]["fee"],
                                              DateFormat.MMMd().format(date),
                                              snapshot.data[i]["time"],
                                              snapshot.data[i]["locationName"],
                                              snapshot.data[i]["location"]
                                                  ['geopoint'],
                                              snapshot.data[i]["urls"],
                                              snapshot.data[i]["id"],
                                              snapshot.data[i]["poster"]);
                                        },
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                              ),
                                              padding: EdgeInsets.all(
                                                  foryouCarouselHeight / 16),
                                              child: Row(children: [
                                                Text(
                                                  snapshot.data[i]["title"] +
                                                      "\n" +
                                                      snapshot.data[i]
                                                          ["locationName"],
                                                  style: TextStyle(
                                                    fontFamily:
                                                        globals.montserrat,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ])),
                                        ))));
                              } else {
                                ads.add(Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg'),
                                            fit: BoxFit.fill)),
                                    child: GestureDetector(
                                      onTap: () {
                                        DateTime date =
                                            snapshot.data[i]['date'].toDate();
                                        navigateToEventDetailsPage(
                                            snapshot.data[i]["title"],
                                            snapshot.data[i]["description"],
                                            snapshot.data[i]["age"],
                                            snapshot.data[i]["type"],
                                            snapshot.data[i]["fee"],
                                            DateFormat.MMMd().format(date),
                                            snapshot.data[i]["time"],
                                            snapshot.data[i]["locationName"],
                                            snapshot.data[i]["location"]
                                                ['geopoint'],
                                            snapshot.data[i]["urls"],
                                            snapshot.data[i]["id"],
                                            snapshot.data[i]["poster"]);
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                          ),
                                          padding: EdgeInsets.all(
                                              foryouCarouselHeight / 16),
                                          child: Row(
                                            children: [
                                              Text(
                                                snapshot.data[i]["title"] +
                                                    "\n" +
                                                    snapshot.data[i]
                                                            ["locationName"]
                                                        .split(',')[0],
                                                style: TextStyle(
                                                  fontFamily:
                                                      globals.montserrat,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )));
                              }
                            }
                            return Container(
                              child: GFCarousel(
                                height: nearyouCarouselHeight,
                                enableInfiniteScroll: true,
                                viewportFraction: 0.8,
                                activeIndicator: Colors.white,
                                aspectRatio: 1,
                                items: ads.map(
                                  (con) {
                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: con),
                                    );
                                  },
                                ).toList(),
                                onPageChanged: (index) {},
                              ),
                            );
                          }
                        }),
                    // Near you text
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
                    // Near You carousel
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
                          int max = snapshot.data.docs.length;
                          int eventTop = -2;
                          int eventBottom = -1;

                          List<int> eventIndex = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++)
                            eventIndex.add(i);

                          return Container(
                            child: GFCarousel(
                              height: foryouCarouselHeight,
                              enableInfiniteScroll: false,
                              viewportFraction: 1.0,
                              activeIndicator: Colors.white,
                              items: eventIndex.map(
                                (con) {
                                  DateTime date = DateTime.now();
                                  eventTop += 2;
                                  eventBottom += 2;
                                  if (eventTop >= max) eventTop = 0;
                                  if (eventBottom >= max) eventBottom = 1;

                                  return Column(
                                    children: [
                                      if (eventTop < max)
                                        GestureDetector(
                                          onTap: () {
                                            print("top: $eventTop");
                                            DateTime date = snapshot
                                                .data.docs[con]['date']
                                                .toDate();
                                            navigateToEventDetailsPage(
                                                snapshot.data.docs[con]
                                                    ['title'],
                                                snapshot.data.docs[con]
                                                    ['description'],
                                                snapshot.data.docs[con]['age'],
                                                snapshot.data.docs[con]['type'],
                                                snapshot.data.docs[con]['fee'],
                                                snapshot.data.docs[con]['time'],
                                                DateFormat.MMMd().format(date),
                                                snapshot.data.docs[con]
                                                    ['locationName'],
                                                snapshot.data.docs[con]
                                                    ['location']['geopoint'],
                                                snapshot.data.docs[con]['urls'],
                                                snapshot.data.docs[con]['id'],
                                                snapshot.data.docs[con]
                                                    ["poster"]);
                                          },
                                          child: EventItem(
                                            title: snapshot.data.docs[con]
                                                ['title'],
                                            description: snapshot.data.docs[con]
                                                ['description'],
                                            age: snapshot.data.docs[con]['age'],
                                            type: snapshot.data.docs[con]
                                                ['type'],
                                            fee: snapshot.data.docs[con]['fee'],
                                            time: snapshot.data.docs[con]
                                                ['time'],
                                            date:
                                                DateFormat.MMMd().format(date),
                                            location: snapshot.data.docs[con]
                                                ['locationName'],
                                            locationPoint:
                                                snapshot.data.docs[con]
                                                    ['location']['geopoint'],
                                            urls: snapshot.data.docs[con]
                                                ['urls'],
                                            posteruid: snapshot.data.docs[con]
                                                ['poster'],
                                          ),
                                        ),
                                      if (eventBottom < max)
                                        GestureDetector(
                                          onTap: () {
                                            print("bottom: $eventBottom");

                                            DateTime date = snapshot
                                                .data.docs[eventBottom]['date']
                                                .toDate();
                                            navigateToEventDetailsPage(
                                                snapshot.data.docs[eventBottom]
                                                    ['title'],
                                                snapshot.data.docs[eventBottom]
                                                    ['description'],
                                                snapshot.data.docs[eventBottom]
                                                    ['age'],
                                                snapshot.data.docs[eventBottom]
                                                    ['type'],
                                                snapshot.data.docs[eventBottom]
                                                    ['fee'],
                                                snapshot.data.docs[eventBottom]
                                                    ['time'],
                                                DateFormat.MMMd().format(date),
                                                snapshot.data.docs[eventBottom]
                                                    ['locationName'],
                                                snapshot.data.docs[eventBottom]
                                                    ['location']['geopoint'],
                                                snapshot.data.docs[eventBottom]
                                                    ['urls'],
                                                snapshot.data.docs[eventBottom]
                                                    ['id'],
                                                snapshot.data.docs[eventBottom]
                                                    ['poster']);
                                          },
                                          child: EventItem(
                                            title: snapshot.data
                                                .docs[eventBottom]['title'],
                                            description:
                                                snapshot.data.docs[eventBottom]
                                                    ['description'],
                                            age: snapshot.data.docs[eventBottom]
                                                ['age'],
                                            type: snapshot
                                                .data.docs[eventBottom]['type'],
                                            fee: snapshot.data.docs[eventBottom]
                                                ['fee'],
                                            time: snapshot
                                                .data.docs[eventBottom]['time'],
                                            date:
                                                DateFormat.MMMd().format(date),
                                            location:
                                                snapshot.data.docs[eventBottom]
                                                    ['locationName'],
                                            locationPoint:
                                                snapshot.data.docs[eventBottom]
                                                    ['location']['geopoint'],
                                            urls: snapshot
                                                .data.docs[eventBottom]['urls'],
                                            posteruid: snapshot.data
                                                .docs[eventBottom]['poster'],
                                          ),
                                        ),
                                    ],
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
                    // Divider
                    Container(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1.0,
                      ),
                    ),
                    // Info section
                    Container(
                      color: Colors.white12,
                      height: infoHeight,
                      child: Column(
                        children: [
                          // Stay informed text
                          Container(
                            margin: EdgeInsets.only(top: 6, left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Stay Informed",
                                style: TextStyle(
                                    fontFamily: globals.montserrat,
                                    fontSize: 23,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          // Text grid of infos
                          Expanded(
                            child: GridView.count(
                              primary: false,
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              padding: EdgeInsets.zero,
                              childAspectRatio: 3,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 0, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Guidelines",
                                        style: globals.infoSectionStyle),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "About",
                                      style: globals.infoSectionStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Report",
                                      style: globals.infoSectionStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Contact",
                                      style: globals.infoSectionStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : globals.spinner;
  }
}
