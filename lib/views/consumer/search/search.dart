import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/search/search_controller.dart';
import 'package:events/domains/event.dart';
import 'package:events/views/consumer/search/search_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:events/globals.dart' as globals;

class SearchPage extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.fetchEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: globals.spinner);
          }

          List<QueryDocumentSnapshot> data =
              snapshot.data as List<QueryDocumentSnapshot>;

          if (data != null && data.length != 0) {
            data.forEach((event) {
              controller.searchItems
                  .add(SearchItemWidget(event: Event.fromSnapshot(event)));
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
                          height: Get.height * 0.07,
                          width: Get.width * 0.9,
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
                                controller: controller.searchController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: controller.inputSize,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                decoration: InputDecoration(
                                    hintText: "Search for events",
                                    hintStyle: TextStyle(
                                        color: Colors.white38,
                                        fontSize: controller.inputSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                    border: InputBorder.none,
                                    focusColor: Colors.black,
                                    fillColor: Colors.black),
                                onSubmitted: (searchText) {
                                  controller.navigateToSearchResultsPage(
                                      context, searchText);
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
                              itemCount: controller.keyWords.length,
                              itemBuilder: (BuildContext context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.navigateToSearchResultsPage(
                                        context, controller.keyWords[index]);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      controller.keyWords[index],
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
                            height: Get.height * 0.7,
                            margin: EdgeInsets.all(13),
                            child: SmartRefresher(
                              enablePullDown: true,
                              controller: controller.refreshController,
                              onRefresh: controller.onRefresh,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                        childAspectRatio: 2 / 2.9),
                                itemCount: controller.searchItems.length,
                                itemBuilder: (BuildContext context, index) {
                                  return controller.searchItems[index];
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
