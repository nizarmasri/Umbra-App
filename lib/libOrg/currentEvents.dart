import 'package:events/libOrg/addEventForm.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class CurrentEventsPage extends StatefulWidget {
  @override
  _CurrentEventsPageState createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  navigateToAddEventForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddEventForm()));
  }

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
    double nearyouCarouselHeight = height * 0.8;
    double nearyouItemHeight = height * 0.17;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, top: 15),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: con),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.0),
                          height: nearyouItemHeight,
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
          ],
        )),
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
}
