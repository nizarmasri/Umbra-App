import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/domains/event.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class SearchResultItem extends StatelessWidget {
  final Event event;

  SearchResultItem({Key? key, required this.event}) : super(key: key);

  navigateToEventDetailsPage(BuildContext context, Event event) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  event: event,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToEventDetailsPage(context, event),
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Column(
          children: [
            if (event.urls == null || event.urls.length == 0)
              Container(
                height: Get.height * 0.13,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white10, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                      filterQuality: FilterQuality.low,
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white12,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            if (event.urls != null && event.urls.length != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // pic 1
                  Container(
                    height: Get.height * 0.13,
                    width: Get.height * 0.13,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (event.urls != null && event.urls.length != 0) ? event.urls[0] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.13,
                    width: Get.height * 0.13,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (event.urls != null && event.urls.length > 1) ? event.urls[1] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.13,
                    width: Get.height * 0.13,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (event.urls != null && event.urls.length > 2) ? event.urls[2] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: event.title,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "\n" + event.type + "  |  " + event.date,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 14,
                                color: Colors.white54),
                          ),
                          TextSpan(
                            text: "\n" + event.location,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 14,
                                color: Colors.white54),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
