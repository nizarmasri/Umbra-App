import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class SearchItem extends StatelessWidget {
  final QueryDocumentSnapshot data;

  SearchItem({Key key, this.data}) : super(key: key);

  navigateToEventDetailsPage(BuildContext context, QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  data: data,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final String title = data['title'];
    final List<dynamic> urls = data['urls'];

    return GestureDetector(
      onTap: () => navigateToEventDetailsPage(context, data),
      child: Container(
          height: Get.height * 0.337,
          width: Get.width * 0.466,
          decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage((urls != null && urls.length != 0)
                      ? urls[0]
                      : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg'))),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: Get.width * 0.466,
              height: Get.height * 0.06,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.black45, Colors.transparent])),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: globals.montserrat,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
