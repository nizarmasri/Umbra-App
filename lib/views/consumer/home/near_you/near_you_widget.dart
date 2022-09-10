import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/home/home_controller.dart';
import 'package:events/domains/event.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/carousel/gf_carousel.dart';

import 'near_you_item.dart';

class NearYouWidget extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return (controller.currentPosition.value.longitude != null && controller.currentPosition.value.latitude != null && controller.loading.value)
        ? StreamBuilder(
            stream: controller.locationStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null || snapshot.data.length <= 0) {
                return Container();
              } else {
                List<NearYouItem> events = [];
                for (var i = 0; i < snapshot.data.length; i++) {
                  DateTime dateChecker =
                      snapshot.data[i]['date'].toDate();
                  if (dateChecker.isAfter(DateTime.now()))
                    events.add(NearYouItem(event: Event.fromSnapshot(snapshot as QueryDocumentSnapshot)));
                }
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Near You",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              //fontWeight: globals.fontWeight,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      child: GFCarousel(
                        enableInfiniteScroll: true,
                        viewportFraction: 0.8,
                        activeIndicator: Colors.white,
                        items: events.map(
                          (con) {
                            return Container(child: con);
                          },
                        ).toList(),
                        onPageChanged: (index) {},
                      ),
                    ),
                  ],
                );
              }
            })
        : Container();
  }
}
