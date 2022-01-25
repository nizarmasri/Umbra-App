import 'package:events/controllers/consumer/attend/attend_controller.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AttendedEventsPage extends StatefulWidget {
  @override
  _AttendedEventsPageState createState() => _AttendedEventsPageState();
}

class _AttendedEventsPageState extends State<AttendedEventsPage> {
  final controller = Get.put(AttendController());

  @override
  Widget build(BuildContext context) {
    controller.eventItems.value = [];

    return FutureBuilder(
        future: controller.fetchAttendedEvents(),
        builder: (context, snapshot) {
          if (snapshot.data != null && controller.eventItems.isNotEmpty) {
            if (!snapshot.hasData) {
              return Center(
                child: globals.spinner,
              );
            }
            controller.eventItems.value = [];
            snapshot.data.forEach((event) {
              controller.eventItems.add(EventItem(
                data: event,
                key: Key(event['title'] + event['date'].toString()),
              ));
            });

            if (controller.sortBy.value == 'Descending')
              controller.eventItems
                  .sort((a, b) => b.data['date'].compareTo(a.data['date']));
            else if (controller.sortBy.value == 'Ascending')
              controller.eventItems
                  .sort((a, b) => a.data['date'].compareTo(b.data['date']));

            RefreshController _refreshController =
            RefreshController(initialRefresh: false);
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20),
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
                                          onChanged: (String value) {
                                            setState(() {
                                              controller.sortBy.value = value;
                                            });
                                          },
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height * 0.75,
                            child: SmartRefresher(
                              enablePullDown: true,
                              controller: _refreshController,
                              onRefresh: () async {
                                // monitor network fetch
                                await Future.delayed(Duration(milliseconds: 1000));
                                // if failed,use refreshFailed()
                                _refreshController.refreshCompleted();
                              },
                              child: ListView.builder(
                                itemCount: controller.eventItems.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: controller.eventItems[index],
                                    onTap: () {
                                      controller.navigateToEventDetailsPage(context,
                                          controller.eventItems[index].data);
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            );
          } else {
            RefreshController _refreshController =
            RefreshController(initialRefresh: false);
            return Scaffold(
              body: SafeArea(
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: () async {
                    // monitor network fetch
                    await Future.delayed(Duration(milliseconds: 1000));
                    // if failed,use refreshFailed()
                    _refreshController.refreshCompleted();
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(30),
                      child: Text(
                        "You have not attended any events",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
