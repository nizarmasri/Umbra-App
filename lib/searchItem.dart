import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:events/globals.dart' as globals;

class SearchItem extends StatefulWidget {
  final QueryDocumentSnapshot data;

  SearchItem(
      {Key key,
      this.data})
      : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState(data);
}

class _SearchItemState extends State<SearchItem> {
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
    id = data['id'];
    posteruid = data['poster'];
  }

  navigateToEventDetailsPage(
      String title,
      String description,
      String age,
      String type,
      String fee,
      String date,
      String time,
      String location,
      GeoPoint locationPoint,
      List<dynamic> urls,
      String id,
      String posteruid) {
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
              locationPoint: locationPoint,
              urls: urls,
              id: id,
              posteruid: posteruid,
            )));
  }

  _SearchItemState(this.data);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemHeight = height * 0.337;
    double itemWidth = width * 0.466;
    double shadedHeight = height * 0.06;

    getData();

    return GestureDetector(
      onTap: () {
        navigateToEventDetailsPage(
          title,
          description,
          age,
          type,
          fee,
          date,
          time,
          location,
          locationPoint,
          urls,
          id,
          posteruid
        );
      },
      child: Container(
          height: itemHeight,
          width: itemWidth,
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
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.black45,
                    Colors.transparent
                  ]
                )
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style:
                        TextStyle(fontFamily: globals.montserrat, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
