import 'package:events/libOrg/addEventForm.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class CurrentEventsPage extends StatefulWidget {
  @override
  _CurrentEventsPageState createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  navigateToAddEventForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddEventForm()));
  }

  navigateToEventDetailsPage(String title, String description, String age,
      String type, String fee, String date, String time, String location) {
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
                )));
  }

  List<EventItem> eventItems = [];

  EventItem event1 = EventItem(
    title: "Bodo Pub",
    description:
        "Special night at Bodo pub today! Happy hour from 9 till 12 am with guest artists. Hope to see you there!",
    age: "18 +",
    type: "Pub",
    fee: "-",
    date: "April 14",
    time: "8:00 PM",
    location: "Mar Mikhael",
  );

  EventItem event2 = EventItem(
    title: "BO18",
    description:
        "Techno night at BO18!! Open drinks until 10 pm and special performance by DJ Dawg!",
    age: "21 +",
    type: "Club",
    fee: "100k",
    date: "April 17",
    time: "9:00 PM",
    location: "Manara",
  );

  EventItem event3 = EventItem(
    title: "Party at Sayegh's",
    description: "Crazy house party at the Sayegh villa, open drinks all night! "
        "There's also a swimming pool and we'll be playing RNB and techno. Everyone is welcome!",
    age: "21 +",
    type: "House Party",
    fee: "50k",
    date: "April 23",
    time: "10:00 PM",
    location: "Rabieh",
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double listHeight = height * 0.8;

    eventItems.add(event1);
    eventItems.add(event2);
    eventItems.add(event3);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
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
                          eventItems[index].location
                      );
                    },
                  );
                },
              ),
            )
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
