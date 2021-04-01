import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
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

  List<EventItem> eventItems;

  EventItem event1 = EventItem(
    title: "Bodo Pub",
    description: "Special night at Bodo pub today! Happy hour from 9 till 12 am with guest artists. Hope to see you there!",
    age: "18 +",
    type: "Pub",
    date: "April 14",
    time: "8:00 PM",
    location: "Mar Mikhael",
  );

  EventItem event2 = EventItem(
    title: "BO18",
    description: "Techno night at BO18!! Open drinks until 10 pm and special performance by DJ Dawg!",
    age: "21 +",
    type: "Club",
    date: "April 17",
    time: "9:00 PM",
    location: "Manara",
  );

  EventItem event3 = EventItem(
    title: "Party at Sayegh's",
    description: "Crazy house party at the Sayegh villa, everyone is welcome",
    age: "21 +",
    type: "Club",
    date: "April 17",
    time: "9:00 PM",
    location: "Manara",
  );


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
