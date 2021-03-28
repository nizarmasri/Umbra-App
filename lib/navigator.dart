import 'package:events/events.dart';
import 'package:events/search.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'home.dart';

class NavigatorPage extends StatefulWidget {
  final uid;

  NavigatorPage({Key key, this.uid}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState(uid);
}

class _NavigatorPageState extends State<NavigatorPage> {
  final uid;

  _NavigatorPageState(this.uid);

  static const String montserrat = "Montserrat";
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    EventsPage(),
    SearchPage(),
    AccountPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget currentScreen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   body: _widgetOptions.elementAt(_selectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
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
                Icons.search,
                color: Colors.white,
              ),
              icon: Icon(Icons.search, color: Colors.white),
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
