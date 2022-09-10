import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/domains/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../views/organizer/add_event/addEventForm.dart';
import '../../../views/organizer/event_information/attendeeList.dart';
import '../../../views/organizer/event_information/eventStatistics.dart';
import '../../../views/organizer/profile/organizeraccount.dart';

class EventDetailsController extends GetxController {
  var event = Event.initialize();

  EventDetailsController({required this.event});

  late LatLng markerPos;
  Marker? marker;
  List<Marker?> setMarker = [];
  List<Container> images = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;
  final isOrg = false.obs;
  RxList<dynamic> tokens = [].obs;
  final isAttend = false.obs;
  final isBooked = false.obs;

  final notAttendIcon = Icon(
    Icons.add_circle_outline_rounded,
    color: Colors.green,
    size: 20,
  );
  final isAttendIcon = Icon(
    Icons.add_circle_rounded,
    color: Colors.green,
    size: 20,
  );
  final notBookedIcon = Icon(
    Icons.bookmark_border,
    color: Colors.blue,
    size: 20,
  );
  final isBookedIcon = Icon(
    Icons.bookmark,
    color: Colors.blue,
    size: 20,
  );

  @override
  onReady() async {
    checkIsAttendOrBooked();
    setMarkerPos();
    checkIsOrg();
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  void setMarkerPos() {
    markerPos =
        LatLng(event.locationPoint.latitude, event.locationPoint.longitude);
    marker =
        Marker(markerId: MarkerId(markerPos.toString()), position: markerPos);
    setMarker = [];
    setMarker.add(marker);
  }

  Future<bool> checkIsOrg() async {
    await fb.collection("users").doc(uid).get().then((value) {
      if (value.data()!["organizer"] == true) isOrg(true);
    });
    return isOrg.value;
  }

  Future<void> checkIsAttendOrBooked() async {
    await fb.collection("users").doc(uid).get().then((value) {
      if (value.data()!['attending'].contains(event.id)) isAttend(true);
      if (value.data()!['booked'].contains(event.id)) isBooked(true);
      tokens.value = value.data()!['tokens'];
    });
  }

  navigateToOrganizerPage(String? organizerUid, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrganizerPage(
                  organizeruid: organizerUid,
                )));
  }

  navigateToEventStatistics(Event event, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EventStatistics(event: event)));
  }

  navigateToEdit(Event event, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEventForm(
                  event: event,
                )));
  }

  navigateToAttendees(var id, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AttendeeList(
                  id: id,
                )));
  }
}
