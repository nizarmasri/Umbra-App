import 'package:flutter/material.dart';
import 'package:events/libOrg/account.dart';
import 'package:events/libOrg/currentEvents.dart';
import 'package:events/libOrg/allEvents.dart';

class NavigatorOrgPage extends StatefulWidget {
  final uid;

  NavigatorOrgPage({Key key, this.uid}) : super(key: key);

  @override
  _NavigatorOrgPageState createState() => _NavigatorOrgPageState(uid);
}

class _NavigatorOrgPageState extends State<NavigatorOrgPage> {
  final uid;

  _NavigatorOrgPageState(this.uid);

  int _selectedIndex = 2;

  static List<Widget> _widgetOptions = <Widget>[
    CurrentEventsPage(),
    AllEventsPage(),
    AccountOrgPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              title: Text("")),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.view_list,
                color: Colors.white,
              ),
              icon: Icon(Icons.view_list_outlined, color: Colors.white),
              title: Text("")),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Icon(Icons.person_outline, color: Colors.white),
              title: Text(""))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.black,
    );
  }
}
