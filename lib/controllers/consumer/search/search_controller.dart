import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/consumer/search/search_item.dart';
import 'package:events/views/consumer/search/search_results.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchController extends GetxController {
  final double inputSize = 17;
  var searchItems = <SearchItem>[].obs;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  @override
  onReady() async {
    searchItems.value = [];
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

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


  Future<List<QueryDocumentSnapshot>> fetchEvents() async {
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

  navigateToSearchResultsPage(BuildContext context, String searchString) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResultsPage(
              searchString: searchString,
            )));
  }

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

}