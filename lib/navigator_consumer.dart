import 'package:events/views/consumer/attend/attend_navigator.dart';
import 'package:events/views/consumer/search/search.dart';
import 'package:flutter/material.dart';
import 'views/consumer/profile/settings.dart';
import 'package:events/views/consumer/home/home.dart';

class NavigatorPage extends StatefulWidget {
  final uid;

  NavigatorPage({Key key, this.uid}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState(uid);
}

class _NavigatorPageState extends State<NavigatorPage> {
  final uid;

  _NavigatorPageState(this.uid);

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AttendNavigatorPage(),
    SearchPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> saveTokenToDatabase(Future<String> token) async {
    // Assume user is logged in for this example
    /*String newToken = await token;
    String userId = uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([newToken]),
    });*/
  }

  void initState() {
    super.initState();
    /*Future<String> token = FirebaseMessaging.instance.getToken();
    saveTokenToDatabase(token);*/
  }

  Widget currentScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Colors.white38,
              ),
              label: ''),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.view_list,
                color: Colors.white,
              ),
              icon: Icon(Icons.view_list_outlined, color: Colors.white38),
              label: ''),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              icon: Icon(Icons.search, color: Colors.white38),
              label: ''),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Icon(Icons.person_outline, color: Colors.white38),
              label: '')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.black,
    );
  }
}
