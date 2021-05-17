import 'package:awesome_loader/awesome_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/searchItem.dart';
import 'package:flutter/material.dart';
import 'package:events/searchResults.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getEvents() async {
    List<QueryDocumentSnapshot> events = [];

    await fb
        .collection("events")
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .get()
        .then((value) {
      value.docs.forEach((event) {
        events.add(event);
      });
    });

    return events;
  }

  List<SearchItem> searchItems = [];

  navigateToSearchResultsPage(String searchString) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResultsPage(
                  searchString: searchString,
                )));
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<Null> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

    setState(() {   });
  }

  @override
  Widget build(BuildContext context) {
    searchItems = [];

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double searchFieldWidth = width * 0.9;
    double searchFieldHeight = height * 0.07;
    double gridHeight = height * 0.1;
    double keyWordsWidth = width * 0.2;

    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader2,
                color: Colors.white,
              ),
            );
          }

          if (snapshot.data != null && snapshot.data.length != 0) {
            snapshot.data.forEach((event) {
              searchItems.add(SearchItem(data: event));
            });
          }

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
                                onSubmitted: (searchText) {
                                  navigateToSearchResultsPage(searchText);
                                },
                              ),
                            ),
                          ),
                        ),
                        // Key Words Grid
                        Container(
                          //  height: gridHeight,
                          child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 4 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: keyWords.length,
                              itemBuilder: (BuildContext context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    navigateToSearchResultsPage(
                                        keyWords[index]);
                                  },
                                  child: Container(
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
                                  ),
                                );
                              }),
                        ),
                        // Search Items Grid
                        Container(
                            height: height * 0.7,
                            margin: EdgeInsets.all(13),
                            child: SmartRefresher(
                              enablePullDown: true,
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                        childAspectRatio: 2 / 2.9),
                                itemCount: searchItems.length,
                                itemBuilder: (BuildContext context, index) {
                                  return searchItems[index];
                                },
                              ),
                            ))
                      ],
                    )),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
