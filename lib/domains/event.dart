import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
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
  final String posterUid;
  final int tickets;
  final List<dynamic> attendees;

  factory Event.initialize() {
    return Event(
      id: 'not-initialized',
      title: '',
      description: '',
      type: '',
      fee: '',
      age: '',
      date: '',
      time: '',
      location: '',
      locationPoint: GeoPoint(0,0),
      urls: [],
      posterUid: '',
      tickets: 0,
      attendees: []
    );
  }

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.fee,
    required this.age,
    required this.date,
    required this.time,
    required this.location,
    required this.locationPoint,
    required this.urls,
    required this.posterUid,
    required this.tickets,
    required this.attendees});


}
