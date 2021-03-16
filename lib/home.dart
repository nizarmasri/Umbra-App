import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;

  List<Container> containers = [
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.red,
    )
  ];


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double carouselHeight = height * 0.6;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child:  GFCarousel(
                  height: carouselHeight,
                  enableInfiniteScroll: true,
                  viewportFraction: 1.0,
                  activeIndicator: Colors.white,
                  pagination: true,
                  items: containers.map(
                        (con) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: con
                        ),
                      );
                    },
                  ).toList(),
                  onPageChanged: (index) {
                    setState(() {
                      index;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
