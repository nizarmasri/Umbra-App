import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Text(
            "Account Page",
            style: globals.style,
          ),
        ),
      ),
    );  }
}
