import 'package:events/controllers/consumer/attend/attend_controller.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events/views/attend/attendedEvents.dart';
import 'package:events/views/attend/attendingEvents.dart';

class AttendNavigatorPage extends StatelessWidget {
  final uid;
  final attendingController = Get.put(AttendController());

  AttendNavigatorPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AttendController());
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: PreferredSize(
                preferredSize: Size(Get.width, Get.height * 0.02),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TabBar(
                    isScrollable: false,
                    indicator: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))
                    ),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                        fontFamily: globals.montserrat,
                        fontWeight: globals.fontWeight,
                        fontSize: 25),
                    unselectedLabelColor: Colors.white38,
                    unselectedLabelStyle: TextStyle(
                        fontFamily: globals.montserrat,
                        fontWeight: globals.fontWeight,
                        fontSize: 25),
                    tabs: [
                      Tab(text: 'Attending'),
                      Tab(text: 'Attended'),
                    ],
                  ),
                ),
              )),
          body: TabBarView(
            children: [
              AttendingEventsPage(),
              AttendedEventsPage()
            ],
          ),
        ),
      ),
    );
  }
}
