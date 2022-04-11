import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final String type;
  final String fee;
  final String age;
  final String date;
  final String time;
  final String location;
  final GeoPoint locationPoint;
  final List<dynamic> urls;
  final String id;
  final String posterUid;
  final int tickets;
  final List<dynamic> attendees;

  factory Event.initialize() {
    return Event();
  }

  const Event(
      {this.title,
      this.description,
      this.type,
      this.fee,
      this.age,
      this.date,
      this.time,
      this.location,
      this.locationPoint,
      this.urls,
      this.id,
      this.posterUid,
      this.tickets,
      this.attendees});




}
