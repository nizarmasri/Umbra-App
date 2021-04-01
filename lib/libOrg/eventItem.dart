import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class EventItem extends StatefulWidget {

  final String title;
  final String description;
  final String type;
  final String age;
  final String date;
  final String time;
  final String location;

  EventItem({Key key, this.title, this.description, this.type, this.age, this.date, this.time, this.location}) : super(key: key);

  @override
  _EventItemState createState() => _EventItemState(title, description, type, age, date, title, location);
}

class _EventItemState extends State<EventItem> {

  final String title;
  final String description;
  final String type;
  final String age;
  final String date;
  final String time;
  final String location;

  _EventItemState(this.title, this.description,this.type, this.age, this.date, this.time, this.location);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double nearyouItemHeight = height * 0.17;

    return Container(
      margin: EdgeInsets.all(3.0),
      height: nearyouItemHeight,
      child: ClipRRect(
          borderRadius:
          BorderRadius.all(Radius.circular(5.0)),
          child: GFListTile(
            avatar: GFImageOverlay(
              height: 100,
              width: 100,
              image: NetworkImage(
                  'https://st2.depositphotos.com/7867872/10618/i/950/depositphotos_106182598-stock-photo-night-club-party-event-concert.jpg'),
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontFamily: globals.montserrat, fontSize: 17, color: Colors.white),
            ),
            subtitle: Text(
              type,
              style: TextStyle(
                  fontFamily: globals.montserrat,
                  fontSize: 15,
                  fontWeight: globals.fontWeight,
                  color: Colors.white),
            ),
            color: Colors.white12,
          ),),
    );
  }
}
