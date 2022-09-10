import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class FeaturedWidget extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("events")
          .where('featured', isEqualTo: true)
          .limit(5)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        else controller.featuredLoading(true);

        List<Container> featuredEvents = [];

        snapshot.data!.docs.forEach((var doc) {
          featuredEvents.add(Container(
            key: Key(doc['title'] + doc.id),
            child: GestureDetector(
              onTap: () {
                //controller.navigateToEventDetailsPage(context, doc);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          image: DecorationImage(
                              image: NetworkImage(
                                !doc["urls"].isEmpty
                                    ? doc["urls"][0]
                                    : 'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                              ),
                              fit: BoxFit.cover)),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: Get.width,
                          height: Get.height * 0.33,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                Colors.black,
                                Colors.transparent
                              ])),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: doc["title"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: globals.montserrat,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 33),
                              ),
                              TextSpan(
                                  text: '\n' +
                                      controller.dateConverter(
                                          doc["date"], doc["time"]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight,
                                      fontSize: 18)),
                              TextSpan(
                                  text:
                                      '\n' + doc["locationName"].split(",")[0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight,
                                      fontSize: 18))
                            ]),
                          ),
                        ),
                      )),
                ]),
              ),
            ),
          ));
        });

        return Container(
          height: Get.height * 0.4,
          child: CarouselSlider(
            items: featuredEvents,
            options: CarouselOptions(
              autoPlay: true,
              initialPage: 0,
              enableInfiniteScroll: true,
              viewportFraction: 1,
              height: Get.height * 0.4,
              enlargeCenterPage: true,
              pauseAutoPlayOnTouch: true,
            ),
          ),
        );
      },
    );
  }
}
