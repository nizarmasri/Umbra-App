import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/organizer/events_controllers/current_and_all_events_controller.dart';
import 'package:events/domains/event.dart';
import 'package:events/views/organizer/events/event_item.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class AllEventsPage extends StatefulWidget {
  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final controller = Get.put(CurrentAndAllEventsController());

  @override
  Widget build(BuildContext context) {
    controller.eventItems.value = [];
    return FutureBuilder(
        future: controller.fetchAllEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: globals.spinner);
          }

          List<QueryDocumentSnapshot> data =
          snapshot.data as List<QueryDocumentSnapshot>;

          if (data != null && data.length != 0) {
            controller.eventItems.value = [];
            data.forEach((event) {
              controller.eventItems.add(EventItem(
                data: event,
                key: Key(event['title'] + event['date'].toString()),
              ));
            });

            if (controller.sortBy.value == 'Descending')
              controller.eventItems
                  .sort((a, b) => b.data!['date'].compareTo(a.data!['date']));
            else if (controller.sortBy.value == 'Ascending')
              controller.eventItems
                  .sort((a, b) => a.data!['date'].compareTo(b.data!['date']));

            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "All Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Sort by ",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Container(
                                //margin: EdgeInsets.only(left: 5),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    //color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.grey[900],
                                    value: controller.sortBy.value,
                                    style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontSize: 15,
                                      fontWeight: globals.fontWeight,
                                      color: Colors.white,
                                    ),
                                    //elevation: 5,
                                    items: <String>[
                                      'Ascending',
                                      'Descending',
                                    ].map<DropdownMenuItem<String>>(
                                        (String sorting) {
                                      return DropdownMenuItem<String>(
                                        value: sorting,
                                        child: Text(sorting),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      controller.sortBy.value,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: globals.fontWeight,
                                          fontFamily: globals.montserrat),
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        controller.sortBy.value = value!;
                                      });
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.eventItems.length,
                          physics: NeverScrollableScrollPhysics(),
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
                          "Current Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          "You do not have any events in progress",
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
