import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class CurrentEventsPage extends StatefulWidget {
  @override
  _CurrentEventsPageState createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
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
    );
  }
}
