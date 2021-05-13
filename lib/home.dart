import 'package:awesome_loader/awesome_loader.dart';
import 'package:events/navigator.dart';
import 'package:events/nearyouItem.dart';
import 'package:events/searchResultItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'globals.dart' as globals;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:string_similarity/string_similarity.dart';

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
            builder: (context) => EventDetails(
                  data: data,
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
        "  |  " +
        time;
  }

  int countSimilarOccurrences(List<String> list, String wordB) {
    if (list == null || list.isEmpty) {
      return 0;
    }

    // If wordB is at least 80% similar to wordA, increment foundElements
    var foundElements = list.where((wordA) =>
        wordA.toUpperCase().similarityTo(wordB.toUpperCase()) >= 0.8);
    return foundElements.length;
  }

  bool forYouAlgorithm(
      List<QueryDocumentSnapshot> eventsA, QueryDocumentSnapshot eventB) {
    // Description of event to be analyzed
    String eventB_Desc = eventB['description'];

    // List of descriptions of events to compare to
    // (events user attended)
    List<String> eventsA_Desc = [];
    eventsA.forEach((event) {
      eventsA_Desc.add(event['description']);
    });

    // counter for number of words eventB has in common with eventA
    int eventB_localCounter = 0;
    // counter for number of eventA's eventB is similar to
    int eventB_counter = 0;

    // Compare each eventA to the eventB
    eventsA_Desc.forEach((eventA) {
      eventB_localCounter = 0;

      // Create list of individual words for each event description
      List<String> eventA_words = eventA.split(" ");
      List<String> eventB_words = eventB_Desc.split(" ");

      // Calculate 20% of the number of words in eventA
      int twentyPercent = (eventA_words.length * 0.2).toInt();

      // Check if words in eventB description are 80% similar to words in eventA description
      // Increment eventB_localCounter if it is similar
      eventB_words.forEach((wordB) {
        if (countSimilarOccurrences(eventA_words, wordB) == 1)
          eventB_localCounter++;
      });

      // if the number of similar words in eventB to eventA is greater than 20% of total words in eventA
      // increment eventB_counter
      if (eventB_localCounter >= twentyPercent) eventB_counter++;
    });

    // if eventB is similar to at least 2 eventA's, return true
    if (eventB_counter >= 2)
      return true;
    else
      return false;
  }

  List<SearchResultItem> foryouItems = [];
  FirebaseFirestore fb = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;

  Future<List<QueryDocumentSnapshot>> getForyouEvents() async {
    // All posted events that user is not attending
    List<QueryDocumentSnapshot> allEvents = [];
    // Latest 5 attending events
    List<QueryDocumentSnapshot> latestAttendingEvents = [];
    // Final list of events on for you
    List<QueryDocumentSnapshot> foryouEvents = [];

    // Get the IDs of all events user is attending
    List<dynamic> attendingEventsIds = [];
    await fb.collection("users").doc(uid).get().then((value) {
      attendingEventsIds = value.data()['attending'];
    });

    // Get all events user is not attending
    await fb
        .collection("events")
        .where('__name__', whereNotIn: attendingEventsIds)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        allEvents.add(event);
      });
    });

    // Get the documents of all events user is attending
    List<dynamic> attendingEvents = [];
    await fb
        .collection("events")
        .where('__name__', whereIn: attendingEventsIds)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        attendingEvents.add(event);
      });

      // Sort events from newest to oldest
      attendingEvents.sort((a, b) => b['date'].compareTo(a['date']));

      // Sets number of latest event to 5 or lower
      int numberOfLatest = 0;
      if (attendingEvents.length >= 5)
        numberOfLatest = 5;
      else
        numberOfLatest = attendingEvents.length;

      // Add the latest 5 or less events to latest events list
      for (int i = 0; i < numberOfLatest; i++)
        latestAttendingEvents.add(attendingEvents[i]);
    });

    // compares all events to the 5 latest events
    // if true, add event to for you events list
    allEvents.forEach((event) {
      if (forYouAlgorithm(latestAttendingEvents, event) == true)
        foryouEvents.add(event);
    });

    // return the for you events
    return allEvents;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<Null> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      items = 4;
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => NavigatorPage(),
            transitionDuration: Duration(seconds: 0)));
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      items = items + 3;
    });
    print("ima gay");
    _refreshController.loadComplete();
  }

  int items = 4;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double featureCarouselHeight = height * 0.5;
    double foryouCarouselHeight = height * 0.4;
    double nearyouCarouselHeight = height * 0.3;
    double infoHeight = height * 0.25;

    return _currentPosition != null
        ? Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView(
                    children: [
                      // Featured carousel
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("events")
                            .where('featured', isEqualTo: true)
                            .limit(5)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: AwesomeLoader(
                                loaderType: AwesomeLoader.AwesomeLoader2,
                                color: Colors.white,
                              ),
                            );
                          }

                          List<Container> featuredEvents = [];

                          snapshot.data.docs.forEach((var doc) {
                            featuredEvents.add(Container(
                              key: Key(doc['title'] + doc.id),
                              margin: EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  navigateToEventDetailsPage(doc);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  !doc["urls"].isEmpty
                                                      ? doc["urls"][0]
                                                      : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                                                ),
                                                fit: BoxFit.cover)),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            width: width,
                                            // height: featureCarouselHeight * 0.33,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: <Color>[
                                                  Colors.black87,
                                                  Colors.transparent
                                                ])),
                                            child: RichText(
                                              textAlign: TextAlign.start,
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: doc["title"],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          globals.montserrat,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                                TextSpan(
                                                    text: '\n' +
                                                        dateConverter(
                                                            doc["date"],
                                                            doc["time"]),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            globals.montserrat,
                                                        fontWeight:
                                                            globals.fontWeight,
                                                        fontSize: 15)),
                                                TextSpan(
                                                    text: '\n' +
                                                        doc["locationName"]
                                                            .split(",")[0],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            globals.montserrat,
                                                        fontWeight:
                                                            globals.fontWeight,
                                                        fontSize: 15))
                                              ]),
                                            ),
                                          ),
                                        )),
                                  ]),
                                ),
                              ),
                            ));
                          });

                          return Container(
                            height: foryouCarouselHeight,
                            child: CarouselSlider(
                              items: featuredEvents,
                              options: CarouselOptions(
                                autoPlay: true,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                viewportFraction: 1,
                                height: foryouCarouselHeight,
                                enlargeCenterPage: true,
                                pauseAutoPlayOnTouch: true,
                              ),
                            ),
                          );
                        },
                      ),
                      // Near you text
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 10, bottom: 10),
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
                        margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
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

                          if (snapshot.data != null &&
                              snapshot.data.length != 0) {
                            snapshot.data.forEach((event) {
                              foryouItems.add(SearchResultItem(
                                data: event,
                                key: Key(event['title'] + event.id),
                              ));
                            });

                            print(snapshot.data[0]['date']);
                            print(Timestamp.now());

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: items,
                              itemBuilder: (context, index) {
                                return foryouItems[index];
                              },
                            );
                          } else
                            return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : globals.spinner;
  }
}
