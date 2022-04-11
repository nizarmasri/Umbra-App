import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:events/views/consumer/search/search_result_item.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var currentPosition = Position().obs;
  var forYouItems = <SearchResultItem>[].obs;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;
  var items = 4.obs;
  var geo = Geoflutterfire();

  final nearYouLoading = false.obs;
  final forYouLoading = false.obs;
  final featuredLoading = false.obs;
  final loading = false.obs;

  var stream = Stream.empty();

  @override
  onReady() async {
    super.onReady();
    try {
      geo = Geoflutterfire();
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        currentPosition.value = position;
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      Exception(e);
    } finally {
      loading(true);
    }
  }

  navigateToEventDetailsPage(BuildContext context, QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
              data: data,
            )));
  }

  locationStream() => geo
      .collection(
          collectionRef: FirebaseFirestore.instance.collection('events'))
      .within(
          center: geo.point(
              latitude: currentPosition.value.latitude,
              longitude: currentPosition.value.longitude),
          radius: 100,
          field: "location");

  @override
  onClose() {
    super.onClose();
  }

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String dateConverter(Timestamp eventDate, String time) {
    DateTime converted = eventDate.toDate();
    return months[converted.month] +
        " " +
        converted.day.toString() +
        ", " +
        converted.year.toString() +
        "  |  " +
        time;
  }

  int countSimilarOccurrences(List<String> list, String wordB) {
    if (list == null || list.isEmpty) {
      return 0;
    }

    // If wordB is at least 80% similar to wordA, increment foundElements
    var foundElements = list.where((wordA) =>
        wordA.toUpperCase().similarityTo(wordB.toUpperCase()) >= 0.8);
    return foundElements.length;
  }

  Future<void> changeDate() async {
    await fb.collection("events").get().then((value) {
      value.docs.forEach((event) async {
        var random = Random();
        var day = 1 + random.nextInt(30);
        var month = 1 + random.nextInt(12);
        await fb
            .collection('events')
            .doc(event.id)
            .update({'date': DateTime(2023, month, day)});
        //allEvents.add(event);
      });
    });
    /*
    allEvents.forEach((element) async {
      await fb.collection('events').doc(element).update({
        'date': DateTime(2023)
      });
    });

     */
  }

  bool forYouAlgorithm(
      List<QueryDocumentSnapshot> eventsA, QueryDocumentSnapshot eventB) {
    // Description of event to be analyzed
    String eventBDesc = eventB['description'];

    // List of descriptions of events to compare to
    // (events user attended)
    List<String> eventsADesc = [];
    eventsA.forEach((event) {
      eventsADesc.add(event['description']);
    });

    // counter for number of words eventB has in common with eventA
    int eventBLocalCounter = 0;
    // counter for number of eventA's eventB is similar to
    int eventBCounter = 0;

    // Compare each eventA to the eventB
    eventsADesc.forEach((eventA) {
      eventBLocalCounter = 0;

      // Create list of individual words for each event description
      List<String> eventAWords = eventA.split(" ");
      List<String> eventBWords = eventBDesc.split(" ");

      // Calculate 20% of the number of words in eventA
      int twentyPercent = (eventAWords.length * 0.2).toInt();

      // Check if words in eventB description are 80% similar to words in eventA description
      // Increment eventB_localCounter if it is similar
      eventBWords.forEach((wordB) {
        if (countSimilarOccurrences(eventAWords, wordB) == 1)
          eventBLocalCounter++;
      });

      // if the number of similar words in eventB to eventA is greater than 20% of total words in eventA
      // increment eventB_counter
      if (eventBLocalCounter >= twentyPercent) eventBCounter++;
    });

    // if eventB is similar to at least 2 eventA's, return true
    if (eventBCounter >= 2)
      return true;
    else
      return false;
  }

  Future<List<QueryDocumentSnapshot>> getForYouEvents() async {
    // All posted events that user is not attending
    List<QueryDocumentSnapshot> allEvents = [];
    // Latest 5 attending events
    List<QueryDocumentSnapshot> latestAttendingEvents = [];
    // Final list of events on for you
    List<QueryDocumentSnapshot> forYouEvents = [];

    // Get the IDs of all events user is attending
    List<dynamic> attendingEventsIds = [];
    await fb.collection("users").doc(uid).get().then((value) {
      attendingEventsIds = value.data()['attending'];
    });

    if (attendingEventsIds.length > 0) {
      // Get all events user is not attending
      await fb
          .collection("events")
          .where('__name__', whereNotIn: attendingEventsIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) allEvents.add(event);
        });
      });

      // Get the documents of all events user is attending
      List<dynamic> attendingEvents = [];
      await fb
          .collection("events")
          .where('__name__', whereIn: attendingEventsIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          attendingEvents.add(event);
        });

        // Sort events from newest to oldest
        attendingEvents.sort((a, b) => b['date'].compareTo(a['date']));

        // Sets number of latest event to 5 or lower
        int numberOfLatest = 0;
        if (attendingEvents.length >= 5)
          numberOfLatest = 5;
        else
          numberOfLatest = attendingEvents.length;

        // Add the latest 5 or less events to latest events list
        for (int i = 0; i < numberOfLatest; i++) {
          latestAttendingEvents.add(attendingEvents[i]);
        }
      });

      // compares all events to the 5 latest events
      // if true, add event to for you events list
      allEvents.forEach((event) {
        if (forYouAlgorithm(latestAttendingEvents, event) == true)
          forYouEvents.add(event);
      });
    } else {
      // Get all events user is not attending
      await fb.collection("events").get().then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) allEvents.add(event);
        });
      });
    }

    forYouEvents += allEvents;
    // return the for you events concatenated with the rest of the events
    return forYouEvents;
  }

  Future<void> updateTickets() async {
    FirebaseFirestore fb = FirebaseFirestore.instance;

    List<dynamic> names = [];
    await fb.collection('events').get().then((value) {
      value.docs.forEach((element) {
        names.add(element.id);
      });
    });

    names.forEach((element) async {
      await fb.collection('events').doc(element).update({'ticketsleft': 100});
    });
  }
}
