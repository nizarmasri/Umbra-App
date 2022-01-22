import 'package:events/globals.dart' as globals;
import 'package:events/attendedEvents.dart';
import 'package:events/attendingEvents.dart';
import 'package:events/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'views/home/home.dart';

class AttendNavigatorPage extends StatefulWidget {
  final uid;

  AttendNavigatorPage({Key key, this.uid}) : super(key: key);

  @override
  _AttendNavigatorPageState createState() => _AttendNavigatorPageState(uid);
}

class _AttendNavigatorPageState extends State<AttendNavigatorPage> {
  final uid;

  _AttendNavigatorPageState(this.uid);

  static const String montserrat = "Montserrat";
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AttendingEventsPage(),
    AttendedEventsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget currentScreen;

  Color selectedColor = Colors.white;
  Color notSelectedColor = Colors.white38;
  Color attendingColor = Colors.white;
  Color attendedColor = Colors.white38;

  bool isAttending = true;
  bool isAttended = false;

  int selected = 0;

  Widget body = AttendingEventsPage();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: PreferredSize(
              preferredSize: Size(width, height * 0.02),
              child: Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          selected = 0;
                          if(selected == 0) {
                            isAttending = true;
                            isAttended = false;
                            body = AttendingEventsPage();
                          }

                          if(isAttending)
                            attendingColor = selectedColor;
                          else
                            attendingColor = notSelectedColor;

                          if(isAttended)
                            attendedColor = selectedColor;
                          else
                            attendedColor = notSelectedColor;
                        });
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Attending",
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 25,
                                color: attendingColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(onTap: (){
                      setState(() {
                        selected = 1;
                        if(selected == 1) {
                          isAttending = false;
                          isAttended = true;
                          body = AttendedEventsPage();
                        }

                        if(isAttending)
                          attendingColor = selectedColor;
                        else
                          attendingColor = notSelectedColor;

                        if(isAttended)
                          attendedColor = selectedColor;
                        else
                          attendedColor = notSelectedColor;
                      });
                    },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Attended",
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 25,
                                color: attendedColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
        body: body,
      ),
    );
  }
}
