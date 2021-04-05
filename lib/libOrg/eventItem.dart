import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class EventItem extends StatefulWidget {
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

  EventItem(
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
      this.urls})
      : super(key: key);

  @override
  _EventItemState createState() => _EventItemState(title, description, type,
      fee, age, date, time, location, locationPoint, urls);
}

class _EventItemState extends State<EventItem> {
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

  _EventItemState(this.title, this.description, this.type, this.fee, this.age,
      this.date, this.time, this.location, this.locationPoint, this.urls);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double tileHeight = height * 0.13;
    double imageHeight = height * 0.13;
    double tileWidth = width * 0.62;
    double imageWidth = width * 0.3;

    return Container(
      margin: EdgeInsets.only(left: 3, right: 3, bottom: 13),
      height: tileHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
              height: imageHeight,
              width: imageWidth,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(0)),
                child: Image.network(
                    (urls != null && urls.length != 0)
                        ? urls[0]
                        : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                    filterQuality: FilterQuality.low,
                    fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                        Widget child, ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white12,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                }),
              )),
          // Info List Tile
          Container(
            height: tileHeight,
            width: tileWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
            ),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                    fontFamily: globals.montserrat,
                    fontSize: 17,
                    color: Colors.white),
              ),
              subtitle: Text(
                type + "\n" + location,
                style: TextStyle(
                    fontFamily: globals.montserrat,
                    fontSize: 15,
                    fontWeight: globals.fontWeight,
                    color: Colors.white),
              ),
              tileColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}
