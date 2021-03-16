import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'globals.dart' as globals;

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double featureCarouselHeight = height * 0.5;
    double foryouCarouselHeight = height * 0.25;
    double nearyouCarouselHeight = height * 0.33;
    double infoHeight = height * 0.22;

    return Scaffold(
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
              Container(
                child: GFCarousel(
                  height: foryouCarouselHeight,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.6,
                  activeIndicator: Colors.white,
                  aspectRatio: 1,
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
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: con),
                          ),
                          Container(
                            margin: EdgeInsets.all(3.0),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
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
                              child: Text(
                                "Guidelines",
                                style: globals.infoSectionStyle
                              ),
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
    );
  }
}
