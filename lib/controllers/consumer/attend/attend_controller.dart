import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:events/libOrg/eventItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AttendController extends GetxController {
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

  Future<List<QueryDocumentSnapshot>> fetchAttendingEvents() async {
    List<QueryDocumentSnapshot> events = [];
    List<dynamic> eventIds = [];

    await fb.collection('users').doc(uid).get().then((value) {
      eventIds = value.data()['attending'];
    });

    // Handles up to 20 events attending
    // Loop code for > 20 not implemented
    if (eventIds.length > 10) {
      List<dynamic> currentList = [];
      for (int i = 0; i < 10; i++) {
        currentList.add(eventIds[i]);
      }
      await fb
          .collection("events")
          .where('__name__', whereIn: currentList)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) events.add(event);
        });
      });

      int currentSize = eventIds.length - 10;
      if (currentSize > 10) {
        bool isLessThanTen = false;
        while (isLessThanTen == false) {}
      } else if (currentSize > 0) {
        currentList = [];
        for (int i = 10; i < currentSize + 10; i++) {
          currentList.add(eventIds[i]);
        }
        await fb
            .collection("events")
            .where('__name__', whereIn: currentList)
            .get()
            .then((value) {
          value.docs.forEach((event) {
            DateTime dateChecker = event.data()['date'].toDate();
            if (dateChecker.isAfter(DateTime.now())) events.add(event);
          });
        });
      }
      events.sort((a, b) => b['date'].compareTo(a['date']));
    } else if (eventIds.length > 0) {
      await fb
          .collection("events")
          .where('__name__', whereIn: eventIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isAfter(DateTime.now())) events.add(event);
        });
      });
      events.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      events = null;
    }

    return events;
  }

  Future<List<QueryDocumentSnapshot>> fetchAttendedEvents() async {
    List<QueryDocumentSnapshot> events = [];
    List<dynamic> eventIds = [];

    await fb.collection('users').doc(uid).get().then((value) {
      eventIds = value.data()['attending'];
    });

    if (eventIds.length > 10) {
      List<dynamic> currentList = [];
      for (int i = 0; i < 10; i++) {
        currentList.add(eventIds[i]);
      }
      await fb
          .collection("events")
          .where('__name__', whereIn: currentList)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isBefore(DateTime.now())) events.add(event);
        });
      });

      int currentSize = eventIds.length - 10;
      if (currentSize > 10) {
        bool isLessThanTen = false;
        while (isLessThanTen == false) {}
      } else if (currentSize > 0) {
        currentList = [];
        for (int i = 10; i < currentSize + 10; i++) {
          currentList.add(eventIds[i]);
        }
        await fb
            .collection("events")
            .where('__name__', whereIn: currentList)
            .get()
            .then((value) {
          value.docs.forEach((event) {
            DateTime dateChecker = event.data()['date'].toDate();
            if (dateChecker.isBefore(DateTime.now())) events.add(event);
          });
        });
      }
      events.sort((a, b) => b['date'].compareTo(a['date']));
    } else if (eventIds.length > 0) {
      await fb
          .collection("events")
          .where('__name__', whereIn: eventIds)
          .get()
          .then((value) {
        value.docs.forEach((event) {
          DateTime dateChecker = event.data()['date'].toDate();
          if (dateChecker.isBefore(DateTime.now())) events.add(event);
        });
      });
      events.sort((a, b) => b['date'].compareTo(a['date']));
    } else {
      events = null;
    }

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

}