import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:events/globals.dart' as globals;

class NearyouItem extends StatefulWidget {
  final QueryDocumentSnapshot data;

  NearyouItem(
      {Key key,
        this.data})
      : super(key: key);

  @override
  _NearyouItemState createState() => _NearyouItemState(data);
}

class _NearyouItemState extends State<NearyouItem> {
  final QueryDocumentSnapshot data;

  String title;
  String description;
  String type;
  String fee;
  String age;
  var date;
  String time;
  String location;
  GeoPoint locationPoint;
  List<dynamic> urls;
  String id;
  String posteruid;

  void getData() {
    DateTime dateFormatted = data['date'].toDate();

    title = data['title'];
    description = data['description'];
    type = data['type'];
    fee = data['fee'];
    age = data['age'];
    date = DateFormat.MMMd().format(dateFormatted);
    time = data['time'];
    location = data['locationName'];
    locationPoint = data['location']['geopoint'];
    urls = data['urls'];
    id = data.id;
    posteruid = data['poster'];
  }

  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(data: data,)));
  }

  _NearyouItemState(this.data);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemHeight = height * 0.2;
    double itemWidth = width * 0.8;
    double shadedHeight = height * 0.085;

    getData();

    return GestureDetector(
      onTap: () {
        navigateToEventDetailsPage(data);
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
                  image: NetworkImage((urls != null && urls.length != 0)
                      ? urls[0]
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
                              text: title,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: "\n" + type + "  |  " + date,
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
                              text: date,
                              style: TextStyle(
                                  fontFamily: globals
                                      .montserrat,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87),
                            ),
                            TextSpan(
                              text: "\n" + age,
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
