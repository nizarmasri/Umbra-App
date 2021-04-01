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

  EventDetails({Key key, this.title, this.description, this.type, this.fee, this.age, this.date, this.time, this.location}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState(title, description, type, fee, age, date, title, location);
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

  _EventDetailsState(this.title, this.description, this.type, this.fee, this.age, this.date, this.time, this.location);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
