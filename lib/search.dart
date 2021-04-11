import 'package:events/searchItem.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double inputSize = 17;

  final TextEditingController searchController = TextEditingController();

  List<String> keyWords = [
    'Pub',
    'Club',
    'House Party',
    'Gig',
    'Free',
    'Near me',
    'RNB',
    'Techno',
    'Metal',
    '21 +'
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double searchFieldWidth = width * 0.9;
    double searchFieldHeight = height * 0.07;
    double gridHeight = height * 0.1;
    double keyWordsWidth = width * 0.2;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                  child: Column(
                children: [
                  // Search Field
                  Container(
                    height: searchFieldHeight,
                    width: searchFieldWidth,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        title: TextField(
                          controller: searchController,
                          cursorColor: Colors.white,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: inputSize,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight),
                          decoration: InputDecoration(
                              hintText: "Search for events",
                              hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: inputSize,
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight),
                              border: InputBorder.none,
                              focusColor: Colors.black,
                              fillColor: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // Key Words Grid
                  Container(
                    height: gridHeight,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 4 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: keyWords.length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              keyWords[index],
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 10.5,
                                  color: Colors.white),
                            ),
                          );
                        }),
                  ),
                  // Search Items Grid
                  Container(
                      height: height * 0.7,
                      margin: EdgeInsets.all(13),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 2 / 2.9),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, index) {
                          return SearchItem();
                        },
                      ))
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
