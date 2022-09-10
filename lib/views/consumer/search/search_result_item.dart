import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class SearchResultItem extends StatelessWidget {
  final QueryDocumentSnapshot? data;

  SearchResultItem({Key? key, this.data}) : super(key: key);

  navigateToEventDetailsPage(BuildContext context, QueryDocumentSnapshot? data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  data: data,
                )));
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateFormatted = data!['date'].toDate();
    final String? title = data!['title'];
    final String type = data!['type'];
    final date = DateFormat.MMMd().format(dateFormatted);
    final String location = data!['locationName'];
    final List<dynamic>? urls = data!['urls'];

    return GestureDetector(
      onTap: () => navigateToEventDetailsPage(context, data),
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Column(
          children: [
            if (urls == null || urls.length == 0)
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
            if (urls != null && urls.length != 0)
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
                          (urls != null && urls.length != 0) ? urls[0] : '',
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
                          (urls != null && urls.length > 1) ? urls[1] : '',
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
                          (urls != null && urls.length > 2) ? urls[2] : '',
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
                            text: title,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "\n" + type + "  |  " + date,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 14,
                                color: Colors.white54),
                          ),
                          TextSpan(
                            text: "\n" + location,
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
