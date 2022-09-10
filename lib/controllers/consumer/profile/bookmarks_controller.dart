import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/domains/event.dart';
import 'package:events/views/organizer/events/event_item.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BookmarksController extends GetxController {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  navigateToEventDetailsPage(BuildContext context, Event event) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
              event: event,
                )));
  }

  List<EventItem> eventItems = [];

  FirebaseFirestore fb = FirebaseFirestore.instance;
  DateTime? dateChecker;

  Future<List<QueryDocumentSnapshot>> getEvents() async {
    List<QueryDocumentSnapshot> events = [];
    List<dynamic>? eventIds = [];

    await fb.collection('users').doc(uid).get().then((value) {
      eventIds = value.data()!['booked'];
    });

    await fb
        .collection("events")
        .where('__name__', whereIn: eventIds)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        events.add(event);
      });
    });
    return events;
  }
}
