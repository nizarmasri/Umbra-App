import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class EventItem extends StatefulWidget {
  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
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
              "The One",
              style: TextStyle(
                  fontFamily: globals.montserrat, fontSize: 17, color: Colors.white),
            ),
            subtitle: Text(
              "Club\nBeirut",
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
