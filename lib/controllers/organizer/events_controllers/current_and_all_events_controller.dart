import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/organizer/add_event/addEventForm.dart';
import 'package:events/views/organizer/events/event_item.dart';
import 'package:events/views/organizer/event_information/eventDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CurrentAndAllEventsController extends GetxController  {
  var eventItems = <EventItem>[].obs;

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  DateTime dateChecker;
  var sortBy = 'Ascending'.obs;

  final loading = true.obs;
  var events;

  @override
  onReady() async {
    try{
    } catch(e){
      throw Exception(e);
    } finally {
      loading(false);
    }
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  Future<List<QueryDocumentSnapshot>> fetchCurrentEvents() async {
    eventItems.value = [];
    List<QueryDocumentSnapshot> events = [];
    await fb
        .collection("events")
        .where('poster', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        dateChecker = event.data()['date'].toDate();
        if (dateChecker.isAfter(DateTime.now())) events.add(event);
      });
    });
    events.sort((a, b) => a['date'].compareTo(b['date']));
    return events;
  }

  Future<List<QueryDocumentSnapshot>> fetchAllEvents() async {
    List<QueryDocumentSnapshot> events = [];
    await fb
        .collection("events")
        .where('poster', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((event) {
        events.add(event);
      });
    });
    events.sort((a, b) => b['date'].compareTo(a['date']));

    return events;
  }

  navigateToEventDetailsPage(BuildContext context, QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
              data: data,
            )));
  }

  navigateToAddEventForm(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddEventForm()));
  }

}
