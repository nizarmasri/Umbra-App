import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;


class AllEventsPage extends StatefulWidget {
  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
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
