import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Text(
            "Events Page",
            style: globals.style,
          ),
        ),
      ),
    );  }
}
