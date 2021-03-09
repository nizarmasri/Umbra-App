import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Text(
            "Search Page",
            style: globals.style,
          ),
        ),
      ),
    );  }
}
