import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getStatistics() async{
    List<dynamic> attending = data['attending'];

    List<DocumentSnapshot> attendees = [];
      await fb.collection("users").where('__name__', whereIn: attending).get().then((value){
        value.docs.forEach((attendee) {
          attendees.add(attendee);
        });
      });

    return attendees;
  }

  List<int> calculateTotalByGender(List<DocumentSnapshot> attendees) {
    int totalMales = 0;
    int totalFemales = 0;
    int totalOthers = 0;

    attendees.forEach((attendee) {
      if(attendee['gender'] == 'Male')
        totalMales++;
      else if (attendee['gender'] == 'Female')
        totalFemales++;
      else if (attendee['gender'] == 'Other')
        totalOthers++;
    });

    return [totalMales, totalFemales, totalOthers];
  }

  int calculateAvgAge(List<DocumentSnapshot> attendees){
    int avgAge = 0;
    attendees.forEach((attendee) {
      DateTime birthday = attendee['birthday'].toDate();
      avgAge += calculateAge(birthday);
    });
    if (avgAge == 0 || attendees.length == 0)
      return 0;
    return avgAge ~/ attendees.length;
  }

  List<int> calculatePercentages (List<DocumentSnapshot> attendees) {
    int malePercentage = 0;
    int femalePercentage = 0;
    int otherPercentage = 0;

    attendees.forEach((attendee) {
      if(attendee['gender'] == 'Male')
        malePercentage++;
      else if (attendee['gender'] == 'Female')
        femalePercentage++;
      else if (attendee['gender'] == 'Other')
        otherPercentage++;
    });

    if(attendees.length == 0) {
      malePercentage = 0;
      femalePercentage = 0;
      otherPercentage = 0;
    }
    else {
      print([malePercentage, femalePercentage, otherPercentage]);
      malePercentage = ((malePercentage / attendees.length) * 100).toInt();
      femalePercentage = ((femalePercentage / attendees.length) * 100).toInt();
      otherPercentage = ((otherPercentage / attendees.length) * 100).toInt();
    }


    return [malePercentage, femalePercentage, otherPercentage];
  }

  List<int> calculateAvgAgeByGender (List<DocumentSnapshot> attendees) {
    int avgMaleAge = 0;
    int avgFemaleAge = 0;
    int avgOtherAge = 0;

    int totalMale = 0;
    int totalFemale = 0;
    int totalOther = 0;


    attendees.forEach((attendee) {
      if(attendee['gender'] == 'Male') {
        totalMale++;
        avgMaleAge += calculateAge(attendee['birthday'].toDate());
      }
      else if (attendee['gender'] == 'Female') {
        totalFemale++;
        avgFemaleAge += calculateAge(attendee['birthday'].toDate());
      }
      else if (attendee['gender'] == 'Other') {
        totalOther++;
        avgOtherAge += calculateAge(attendee['birthday'].toDate());
      }
    });

    if(totalMale == 0)
      avgMaleAge = 0;
    else
      avgMaleAge = avgMaleAge ~/ totalMale;

    if (totalFemale == 0)
      avgFemaleAge = 0;
    else
      avgFemaleAge = avgFemaleAge ~/ totalFemale;

    if (totalOther == 0)
      avgOtherAge = 0;
    else
      avgOtherAge = avgOtherAge ~/ totalOther;

    return [avgMaleAge, avgFemaleAge, avgFemaleAge];
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  void initState() {
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
        child: FutureBuilder(
          future: getStatistics(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){

            List<dynamic> numAttendees = data['attending'];
            bool isEmpty = false;
            if(numAttendees.length == 0)
              isEmpty = true;

            List<int> avgGenderAges;
            int avgAge;
            int totalAttendees;
            List<int> totalGenders;
            List<int> genderPercentages;

            if(!isEmpty){
              if (!snapshot.hasData) {
                return Center(
                  child: globals.spinner
                );
              }
              avgGenderAges = calculateAvgAgeByGender(snapshot.data);
              avgAge = calculateAvgAge(snapshot.data);
              totalAttendees = snapshot.data.length;
              totalGenders = calculateTotalByGender(snapshot.data);
              genderPercentages = calculatePercentages(snapshot.data);
              print(genderPercentages.toString());
            }

            else{
              avgGenderAges = [0, 0, 0];
              avgAge = 0;
              totalAttendees = 0;
              totalGenders = [0, 0, 0];
              genderPercentages = [0, 0, 0];
            }

            int avgMaleAge = avgGenderAges[0];
            int avgFemaleAge = avgGenderAges[1];
            int avgOtherAge = avgGenderAges[2];

            int totalMales = totalGenders[0];
            int totalFemales = totalGenders[1];
            int totalOthers = totalGenders[2];

            int malePercentage = genderPercentages[0];
            int femalePercentage = genderPercentages[1];
            int otherPercentage = genderPercentages[2];

            return Container(
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
                                          text: totalAttendees.toString(),
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
                                          text: avgAge.toString(),
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
                            percent: malePercentage / 100,
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
                              malePercentage.toString() + "%",
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
                                text: " - Total: " + totalMales.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals
                                        .montserrat,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                  text: '\n - Avg age: ' + avgMaleAge.toString(),
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
                            percent: femalePercentage / 100,
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
                              femalePercentage.toString() + '%',
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
                                text: " - Total: " + totalFemales.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals
                                        .montserrat,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                  text: '\n - Avg age: ' + avgFemaleAge.toString(),
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
                            percent: otherPercentage / 100,
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
                              otherPercentage.toString() + '%',
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
                                text: " - Total: " + totalOthers.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals
                                        .montserrat,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                  text: '\n - Avg age: ' + avgOtherAge.toString(),
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
            );
          },
        ),
      ),
    );
  }
}
