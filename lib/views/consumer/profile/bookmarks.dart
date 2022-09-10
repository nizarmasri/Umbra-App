import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/profile/bookmarks_controller.dart';
import 'package:events/domains/event.dart';
import 'package:events/views/organizer/events/event_item.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class Bookmarks extends GetView<BookmarksController> {
  @override
  Widget build(BuildContext context) {
    controller.eventItems = [];
    return FutureBuilder(
        future: controller.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: globals.spinner);
          }

          List<QueryDocumentSnapshot> data =
              snapshot.data as List<QueryDocumentSnapshot>;

          if (data != null && data.length != 0) {
            data.forEach((event) {
              controller.eventItems.add(EventItem(
                data: event,
              ));
            });

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  "Bookmarks",
                  style: TextStyle(
                      fontFamily: globals.montserrat,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        height: Get.height * 0.8,
                        child: ListView.builder(
                          itemCount: controller.eventItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: controller.eventItems[index],
                              onTap: () {
                                controller.navigateToEventDetailsPage(
                                    context, Event.fromSnapshot(controller.eventItems[index].data!));
                              },
                            );
                          },
                        ),
                      )
                    ],
                  )),
                ),
              ),
            );
          } else
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bookmarks",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          "You do not have any bookmarks",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        });
  }
}
