import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:events/globals.dart' as globals;

class EventStatistics extends StatefulWidget {
  final QueryDocumentSnapshot data;
  EventStatistics({Key key, this.data}) : super(key: key);

  @override
  _EventStatisticsState createState() => _EventStatisticsState(data);
}

class _EventStatisticsState extends State<EventStatistics> {
  final QueryDocumentSnapshot data;
  _EventStatisticsState(this.data);

  String title;
  String description;
  String type;
  String fee;
  String age;
  String date;
  String time;
  String location;
  GeoPoint locationPoint;
  List<dynamic> urls;
  String id;
  String posteruid;

  List<dynamic> attending;

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
    attending = data['attending'];

  }

  FirebaseFirestore fb = FirebaseFirestore.instance;

  int attendingTotal;
  int attendingMale;
  int attendingFemale;
  int attendingOther;
  int ageAvg;

  double malePercentage;
  double femalePercentage;
  double otherPercentage;

  Future<void> getStatistics() async{
    attendingTotal = attending.length;
    List<dynamic> ages = [];
    attending.forEach((var uid) async {
      await fb.collection("users").doc(uid).get().then((value){
        if(value.data()['gender'] == 'male')
          attendingMale++;
        else if(value.data()['gender'] == 'female')
          attendingFemale++;
        else if(value.data()['gender'] == 'other')
          attendingOther++;

        ages.add(value.data()['age']);
      });
    });

    // Calc age avg
    ageAvg = 0;
    ages.forEach((var age) {
      ageAvg += age;
    });
    ageAvg = ageAvg ~/ ages.length;

    // Calc gender percentages
    malePercentage = attendingMale / attendingTotal;
    femalePercentage = attendingFemale / attendingTotal;
    otherPercentage = attendingOther / attendingTotal;

  }

  @override
  void initState() {
    getData();
    getStatistics();
    super.initState();
  }

  double titleTextSize = 23;
  double attendingTextSize = 23;
  double totalTextSize = 15;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double infoRectHeight = height * 0.114;
    double infoRectWidth = width * 0.4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Statistics",
          style: TextStyle(
              fontFamily: globals.montserrat,
              fontSize: titleTextSize,
              color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              // Attending Text
              Container(
                margin: EdgeInsets.all(20),
                width: width,
                child: Text(
                  "Attending",
                  style: TextStyle(
                      fontFamily: globals.montserrat,
                      fontSize: titleTextSize,
                      color: Colors.white),
                ),
              ),
              // Number of attending
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Total
                      Container(
                        height: infoRectHeight,
                        width: infoRectWidth,
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
                                      text: "298",
                                      style: TextStyle(
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight,
                                          fontSize: attendingTextSize,
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: "\ntotal",
                                      style: TextStyle(
                                          fontFamily: globals.montserrat,
                                          fontWeight: FontWeight.bold,
                                          fontSize: totalTextSize,
                                          color: Colors.white),
                                    ),
                                  ]),
                                )),
                          ),
                        ),
                      ),
                      // Age
                      Container(
                    height: infoRectHeight,
                    width: infoRectWidth,
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
                                  text: "21",
                                  style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight,
                                      fontSize: attendingTextSize,
                                      color: Colors.white),
                                ),
                                TextSpan(
                                  text: "\navg age",
                                  style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontWeight: FontWeight.bold,
                                      fontSize: totalTextSize,
                                      color: Colors.white),
                                ),
                              ]),
                            )),
                      ),
                    ),
                  ),
                    ],
                  )),
              // Male Percent indicator
              Container(
                margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                width: width,
                child: Row(
                  children: [
                    // Indicator
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 5.0,
                        percent: 0.64,
                        backgroundColor: Colors.white,
                        header: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Male",
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                        center: Text(
                            "64%",
                            style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 20,
                              color: Colors.white
                            ),
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                    ),
                    // Info
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      padding: EdgeInsets.only(top: 30),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <
                            TextSpan>[
                          TextSpan(
                            text: " - Total: 113",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: globals
                                    .montserrat,
                                fontSize: 16),
                          ),
                          TextSpan(
                              text: '\n - Avg age: 22',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: globals
                                      .montserrat,
                                  fontSize: 16)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              // Female Percent indicator
              Container(
                margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                width: width,
                child: Row(
                  children: [
                    // Indicator
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 5.0,
                        percent: 0.32,
                        backgroundColor: Colors.white,
                        header: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Female",
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                        center: Text(
                          "32%",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                    ),
                    // Info
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      padding: EdgeInsets.only(top: 30),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <
                            TextSpan>[
                          TextSpan(
                            text: " - Total: 57",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: globals
                                    .montserrat,
                                fontSize: 16),
                          ),
                          TextSpan(
                              text: '\n - Avg age: 19',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: globals
                                      .montserrat,
                                  fontSize: 16)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              // Other Percent indicator
              Container(
                margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                width: width,
                child: Row(
                  children: [
                    // Indicator
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 5.0,
                        percent: 0.04,
                        backgroundColor: Colors.white,
                        header: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Other",
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                        center: Text(
                          "4%",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                    ),
                    // Info
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      padding: EdgeInsets.only(top: 30),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <
                            TextSpan>[
                          TextSpan(
                            text: " - Total: 7",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: globals
                                    .montserrat,
                                fontSize: 16),
                          ),
                          TextSpan(
                              text: '\n - Avg age: 20',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: globals
                                      .montserrat,
                                  fontSize: 16)),
                        ]),
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
