import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/globals.dart' as globals;

class EventItem extends StatefulWidget {
  final QueryDocumentSnapshot data;

  EventItem({Key key, this.data}) : super(key: key);

  @override
  _EventItemState createState() => _EventItemState(data);
}

class _EventItemState extends State<EventItem> {
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

  final QueryDocumentSnapshot data;

  _EventItemState(this.data);

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
    posteruid = data['poster'];
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Color tileColor = Colors.white10;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double tileHeight = height * 0.13;
    double imageHeight = height * 0.13;
    double tileWidth = width * 0.62;
    double imageWidth = width * 0.3;

    return Container(
      margin: EdgeInsets.only(left: 3, right: 3, bottom: 14),
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    topLeft: Radius.circular(0),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: title,
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white)),
                    TextSpan(
                        text: "\n" + type + "	• " + date,
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontSize: 13,
                            fontWeight: globals.fontWeight,
                            color: Colors.white)),
                    TextSpan(
                        text: "\n" + location,
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontSize: 13,
                            fontWeight: globals.fontWeight,
                            color: Colors.white)),

                  ]),
                ),
              )),
        ],
      ),
    );
  }
}
