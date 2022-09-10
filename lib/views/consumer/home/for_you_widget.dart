import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/home/home_controller.dart';
import 'package:events/domains/event.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

import '../search/search_result_item.dart';

class ForYouWidget extends StatelessWidget {
  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getForYouEvents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<QueryDocumentSnapshot> data =
        snapshot.data as List<QueryDocumentSnapshot>;

        if (data != null && data.length != 0) {
          data.forEach((event) {
            controller.forYouItems.add(SearchResultItem(
              event: Event.fromSnapshot(event),
              key: Key(event['title'] + event.id),
            ));
          });

          controller.items.value = controller.forYouItems.length ~/ 4;
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "For You",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: globals.montserrat,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.items.value,
                itemBuilder: (context, index) {
                  return controller.forYouItems[index];
                },
              ),
            ],
          );
        } else
          return Container();
      },
    );
  }
}
