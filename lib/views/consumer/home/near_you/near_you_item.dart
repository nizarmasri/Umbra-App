import 'package:events/domains/event.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class NearYouItem extends StatefulWidget {
  final Event event;

  NearYouItem({Key? key,
        required this.event})
      : super(key: key);

  @override
  _NearYouItemState createState() => _NearYouItemState(event);
}

class _NearYouItemState extends State<NearYouItem> {
  final Event event;

  navigateToEventDetailsPage(Event event) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(event: event)));
  }

  _NearYouItemState(this.event);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemHeight = height * 0.2;
    double itemWidth = width * 0.8;
    double shadedHeight = height * 0.075;

    return GestureDetector(
      onTap: () {
        navigateToEventDetailsPage(event);
      },
      child: Container(
          height: itemHeight,
          width: itemWidth,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage((event.urls.length != 0)
                      ? event.urls[0]
                      : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg'))),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: itemWidth,
              height: shadedHeight,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(0)),
              /*gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.black,
                        Colors.transparent
                      ]
                  )*/
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: event.title,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: "\n" + event.type + "  |  " + event.date,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 13,
                                  color: Colors.black87),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: event.date,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87),
                            ),
                            TextSpan(
                              text: "\n" + event.age,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 13,
                                  color: Colors.black87),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
