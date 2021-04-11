import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class SearchItem extends StatefulWidget {
  final String title;
  final String description;
  final String type;
  final String fee;
  final String age;
  final String date;
  final String time;
  final String location;
  final GeoPoint locationPoint;
  final List<dynamic> urls;
  final String id;
  final String posteruid;

  SearchItem(
      {Key key,
      this.title,
      this.description,
      this.type,
      this.fee,
      this.age,
      this.date,
      this.time,
      this.location,
      this.locationPoint,
      this.urls,
      this.id,
      this.posteruid})
      : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState(title, description, type,
      fee, age, date, time, location, locationPoint, urls, id, posteruid);
}

class _SearchItemState extends State<SearchItem> {
  final String title;
  final String description;
  final String type;
  final String fee;
  final String age;
  final String date;
  final String time;
  final String location;
  final GeoPoint locationPoint;
  final List<dynamic> urls;
  final String id;
  final String posteruid;

  _SearchItemState(
      this.title,
      this.description,
      this.type,
      this.fee,
      this.age,
      this.date,
      this.time,
      this.location,
      this.locationPoint,
      this.urls,
      this.id,
      this.posteruid);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemHeight = height * 0.337;
    double itemWidth = width * 0.466;
    double shadedHeight = height * 0.06;

    print("Height: $itemHeight\nWidth: $itemWidth");

    return Container(
        height: itemHeight,
        width: itemWidth,
        decoration: BoxDecoration(
            color: Colors.blue,
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
                    colors: <Color>[Colors.black45, Colors.transparent])),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Villa White Party",
                  style: TextStyle(
                      fontFamily: globals.montserrat,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }
}
