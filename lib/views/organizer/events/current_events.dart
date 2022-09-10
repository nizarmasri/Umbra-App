import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/organizer/events_controllers/current_and_all_events_controller.dart';
import 'package:events/views/organizer/events/event_item.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class CurrentEventsPage extends StatefulWidget {
  @override
  State<CurrentEventsPage> createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  final controller = Get.put(CurrentAndAllEventsController());

  @override
  Widget build(BuildContext context) {
    controller.eventItems.value = [];
    return FutureBuilder(
        future: controller.fetchCurrentEvents(),
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
                      // Title field
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "On-Going Events",
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),

                      // Sort menu
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
                            Obx(
                              () => Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
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
                                  )),
                            )
                          ],
                        ),
                      ),

                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.eventItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: controller.eventItems[index],
                              onTap: () async {
                                controller.navigateToEventDetailsPage(
                                    context, controller.eventItems[index].data);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  )),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.white10,
                onPressed: () async {
                  controller.navigateToAddEventForm(context);
                },
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
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.white10,
                onPressed: () {
                  controller.navigateToAddEventForm(context);
                },
              ),
            );
        });
  }
}
