import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class EventDetails extends StatefulWidget {
  final String title;
  final String description;
  final String type;
  final String fee;
  final String age;
  final String date;
  final String time;
  final String location;

  EventDetails(
      {Key key,
      this.title,
      this.description,
      this.type,
      this.fee,
      this.age,
      this.date,
      this.time,
      this.location})
      : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState(
      title, description, type, fee, age, date, time, location);
}

class _EventDetailsState extends State<EventDetails> {
  final String title;
  final String description;
  final String type;
  final String fee;
  final String age;
  final String date;
  final String time;
  final String location;

  _EventDetailsState(this.title, this.description, this.type, this.fee,
      this.age, this.date, this.time, this.location);

  double titleTextSize = 25;
  double descTextSize = 16;
  double ageTextSize = 25;
  double typeTextSize = 18;
  double feeTextSize = 24;
  double currencyTextSize = 12;
  double dateTextSize = 20;
  double timeTextSize = 22.5;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double detailsHeight = height * 0.5;
    double infoSquaresSize = height * 0.114;
    double infoRectsHeight = height * 0.114;
    double infoRectsWidth = height * 0.171;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
            child: ListView(
          children: [
            // Details
            Container(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  // Title Text
                  Container(
                    margin: EdgeInsets.all(20),
                    width: width,
                    child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: globals.montserrat,
                          fontSize: titleTextSize,
                          color: Colors.white),
                    ),
                  ),
                  // Description Text
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: width,
                    child: Text(
                      description,
                      style: TextStyle(
                          fontFamily: globals.montserrat,
                          fontWeight: globals.fontWeight,
                          fontSize: descTextSize,
                          color: Colors.white),
                    ),
                  ),
                  // Age, Type, Fee squares
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Age
                          Container(
                            height: infoSquaresSize,
                            width: infoSquaresSize,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    age,
                                    style: TextStyle(
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight,
                                        fontSize: ageTextSize,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Type
                          Container(
                            height: infoSquaresSize,
                            width: infoSquaresSize,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    type,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight,
                                        fontSize: typeTextSize,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Fee
                          Container(
                            height: infoSquaresSize,
                            width: infoSquaresSize,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: fee,
                                      style: TextStyle(
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight,
                                          fontSize: feeTextSize,
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: "\nLBP",
                                      style: TextStyle(
                                          fontFamily: globals.montserrat,
                                          fontWeight: FontWeight.bold,
                                          fontSize: currencyTextSize,
                                          color: Colors.white),
                                    ),
                                  ]),
                                )),
                              ),
                            ),
                          ),
                        ],
                      )),
                  // Date and Time squares
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Date
                          Container(
                            height: infoRectsHeight,
                            width: infoRectsWidth,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight,
                                        fontSize: dateTextSize,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Time
                          Container(
                            height: infoRectsHeight,
                            width: infoRectsWidth,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    time,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight,
                                        fontSize: timeTextSize,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            // Images
            Container()
          ],
        )),
      ),
    );
  }
}
