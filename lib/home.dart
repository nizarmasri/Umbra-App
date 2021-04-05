import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'globals.dart' as globals;
import 'package:events/libOrg/services/geolocator_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double featureCarouselHeight = height * 0.5;
    double foryouCarouselHeight = height * 0.35;
    double nearyouCarouselHeight = height * 0.33;
    double nearyouItemHeight = height * 0.14;
    double infoHeight = height * 0.25;

    return _currentPosition != null
        ? Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                child: ListView(
                  children: [
                    // Featured text
                    /*Container(
                margin: EdgeInsets.only(top: 18, left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Featured",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: globals.montserrat,
                      //fontWeight: globals.fontWeight,
                      fontSize: 25,
                      color: Colors.white
                    ),
                  ),
                ),
              ),*/
                    // Featured carousel
                    Container(
                      child: GFCarousel(
                        height: featureCarouselHeight,
                        enableInfiniteScroll: true,
                        viewportFraction: 1.0,
                        activeIndicator: Colors.white,
                        pagination: true,
                        items: containers.map(
                          (con) {
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: con),
                            );
                          },
                        ).toList(),
                        onPageChanged: (index) {
                          setState(() {
                            index;
                          });
                        },
                      ),
                    ),
                    // For you text
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
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
                            return Text("No events near you");
                          } else {
                            List<Container> ads = [];
                            print(snapshot.data.length);
                            var j;
                            if (snapshot.data.length > 5) {
                              j = 5;
                            } else {
                              j = snapshot.data.length;
                            }
                            for (var i = 0; i < j; i++) {
                              if (!snapshot.data[i]["urls"].isEmpty) {
                                ads.add(
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data[i]["urls"][0]),
                                              fit: BoxFit.fill)),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white30,
                                          ),
                                          padding: EdgeInsets.all(7),
                                          child: Row(
                                            children: [
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
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              } else {
                                ads.add(Container(
                                  color: Colors.red,
                                  child: Center(
                                      child: Text(snapshot.data[i]["title"])),
                                ));
                              }
                            }
                            print(snapshot.data);
                            return Container(
                              child: GFCarousel(
                                height: foryouCarouselHeight,
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
                    Container(
                      child: GFCarousel(
                        height: nearyouCarouselHeight,
                        enableInfiniteScroll: true,
                        viewportFraction: 1.0,
                        activeIndicator: Colors.white,
                        aspectRatio: 1,
                        items: tiles.map(
                          (con) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(3.0),
                                  height: nearyouItemHeight,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: con),
                                ),
                                Container(
                                  margin: EdgeInsets.all(3.0),
                                  height: nearyouItemHeight,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: con),
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
