import 'package:awesome_loader/awesome_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/libOrg/addEventForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:events/organizeraccount.dart';
import 'package:events/libOrg/eventStatistics.dart';
import 'package:numberpicker/numberpicker.dart';
import 'ticketAlert.dart';
import 'TicketCancelAlert.dart';
import 'attendeeList.dart';

class EventDetails extends StatefulWidget {
  final QueryDocumentSnapshot data;

  EventDetails({Key key, this.data}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState(data);
}

class _EventDetailsState extends State<EventDetails> {
  String title;
  String description;
  String type;
  String fee;
  String age;
  String date;
  String time;
  String location;
  GeoPoint locationPoint;
  List<dynamic> urls;
  String id;
  String posteruid;
  int tickets;
  List<dynamic> attendees = [];

  final QueryDocumentSnapshot data;

  _EventDetailsState(this.data);

  void getData() {
    DateTime dateFormatted = data['date'].toDate();

    title = data['title'];
    description = data['description'];
    type = data['type'];
    fee = data['fee'];
    age = data['age'];
    date = DateFormat.MMMd().format(dateFormatted);
    time = data['time'];
    location = data['locationName'];
    locationPoint = data['location']['geopoint'];
    urls = data['urls'];
    id = data.id;
    posteruid = data['poster'];
    tickets = data['ticketsleft'];
    attendees = data['attending'];
  }

  double titleTextSize = 25;
  double descTextSize = 16;
  double ageTextSize = 20;
  double typeTextSize = 15;
  double feeTextSize = 21;
  double currencyTextSize = 10;
  double dateTextSize = 17;
  double timeTextSize = 19.5;

  LatLng markerPos;
  Marker marker;
  List<Marker> setMarker = [];

  void setMarkerPos() {
    markerPos = LatLng(locationPoint.latitude, locationPoint.longitude);
    marker =
        Marker(markerId: MarkerId(markerPos.toString()), position: markerPos);
    setMarker = [];
    setMarker.add(marker);
  }

  static Future<void> openMaps(double lat, double lng) async {
    String mapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not open maps.';
    }
  }

  List<Container> images = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;

  bool isOrg = false;

  Future<bool> checkIsOrg() async {
    await fb.collection("users").doc(uid).get().then((value) {
      if (value.data()["organizer"] == true)
        setState(() {
          isOrg = true;
        });
    });
    return isOrg;
  }

  List<dynamic> tokens;

  Future<void> checkIsAttendOrBooked() async {
    await fb.collection("users").doc(uid).get().then((value) {
      setState(() {
        if (value.data()['attending'].contains(id)) isAttend = true;
        if (value.data()['booked'].contains(id)) isBooked = true;
        tokens = value.data()['tokens'];
      });
    });
  }

  Icon notAttendIcon = Icon(
    Icons.add_circle_outline_rounded,
    color: Colors.green,
    size: 20,
  );
  Icon isAttendIcon = Icon(
    Icons.add_circle_rounded,
    color: Colors.green,
    size: 20,
  );
  bool isAttend = false;

  Icon notBookedIcon = Icon(
    Icons.bookmark_border,
    color: Colors.blue,
    size: 20,
  );

  Icon isBookedIcon = Icon(
    Icons.bookmark,
    color: Colors.blue,
    size: 20,
  );

  bool isBooked = false;

  @override
  void initState() {
    getData();
    checkIsAttendOrBooked();
    setMarkerPos();
    checkIsOrg();
    super.initState();
  }

  navigateToOrganizerPage(String organizeruid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrganizerPage(
                  organizeruid: organizeruid,
                )));
  }

  navigateToEventStatistics(QueryDocumentSnapshot data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EventStatistics(data: data)));
  }

  navigateToEdit(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEventForm(
                  data: data,
                )));
  }

  navigateToAttendees(var id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AttendeeList(
                  id: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double infoSquaresSize = height * 0.11;
    double infoRectsHeight = height * 0.1;
    double infoRectsWidth = height * 0.171;
    double mapHeight = height * 0.2;
    double imagesHeight = height * 0.3;
    double btnsHeight = height * 0.057;
    double btnsWidth = height * 0.171;
    int _tickets = 0;

    String feeCheck = "";
    if (fee == "" || fee == "Free")
      feeCheck = "-";
    else
      feeCheck = fee;

    String ageCheck = age;
    if (age == "All ages") {
      ageCheck = "All\nages";
      ageTextSize = 18;
    }
    String typeCheck = type;
    if (type.contains(' ')) {
      typeCheck = typeCheck.replaceAll(' ', '\n');
    }

    urls.forEach((url) {
      images.add(Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Image.network(url,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                  Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          })));
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          if (isOrg)
            IconButton(
                icon: Icon(Icons.group_outlined, color: Colors.white),
                onPressed: () {
                  navigateToAttendees(data.id);
                }),
          if (isOrg)
            IconButton(
                icon: Icon(Icons.equalizer, color: Colors.white),
                onPressed: () {
                  navigateToEventStatistics(data);
                }),
          if (isOrg)
            IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {
                  navigateToEdit(data);
                }),
          if (isOrg)
            IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  navigateToEventStatistics(data);
                }),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            child: ListView(
          children: [
            // Details
            Container(
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: StreamBuilder(
                  stream: fb.collection("events").doc(id).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: globals.spinner);
                    }
                    return Column(
                      children: [
                        // Title Text
                        Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              width: width,
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontFamily: globals.montserrat,
                                    fontSize: titleTextSize,
                                    color: Colors.white),
                              ),
                            ),
                            if (snapshot.data.data()["ticketsleft"] != -1)
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 0),
                                width: width,
                                child: Text(
                                  snapshot.data
                                          .data()["ticketsleft"]
                                          .toString() +
                                      " tickets left",
                                  style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        if (!isOrg)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              snapshot.data.data()["ticketsleft"] == 0
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 20, right: 10),
                                        height: btnsHeight,
                                        width: btnsWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white12,
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("SOLD OUT",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          globals.montserrat,
                                                      fontWeight:
                                                          globals.fontWeight,
                                                      fontSize: 15,
                                                      color: Colors.red)),
                                              Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        TicketAlert alert = TicketAlert(
                                            limit: snapshot.data
                                                .data()["ticketsleft"]);
                                        TicketCancelAlert cancelAlert =
                                            TicketCancelAlert();
                                        if (!isAttend &&
                                            snapshot.data
                                                    .data()["ticketsleft"] !=
                                                -1) {
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              }).then((value) async {
                                            if (value != null) {
                                              setState(() {
                                                isAttend = !isAttend;
                                              });
                                              List<String> ids = [id];
                                              List<String> uids = [uid];
                                              DocumentSnapshot user = await fb
                                                  .collection("users")
                                                  .doc(uid)
                                                  .get();

                                              fb
                                                  .collection("reservations")
                                                  .doc(id)
                                                  .collection("attendees")
                                                  .doc(uid)
                                                  .set({
                                                'amount': value,
                                                'name': user['name'],
                                                'dp': user['dp'],
                                                'confirmed': 0
                                              });

                                              fb
                                                  .collection("users")
                                                  .doc(uid)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayUnion(ids)
                                              });
                                              fb
                                                  .collection("events")
                                                  .doc(id)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayUnion(uids),
                                                'ticketsleft':
                                                    FieldValue.increment(
                                                        -value),
                                                'tokens': FieldValue.arrayUnion(
                                                    tokens)
                                              });
                                            }
                                          });
                                        } else if (isAttend &&
                                            snapshot.data
                                                    .data()["ticketsleft"] !=
                                                -1) {
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return cancelAlert;
                                              }).then((value) async {
                                            if (value == true) {
                                              setState(() {
                                                isAttend = !isAttend;
                                              });
                                              List<String> ids = [id];
                                              List<String> uids = [uid];

                                              dynamic reservation = await fb
                                                  .collection("reservations")
                                                  .doc(id)
                                                  .collection("attendees")
                                                  .doc(uid)
                                                  .get();

                                              fb
                                                  .collection("users")
                                                  .doc(uid)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayRemove(ids)
                                              });
                                              fb
                                                  .collection("events")
                                                  .doc(id)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayRemove(
                                                        uids),
                                                'ticketsleft':
                                                    FieldValue.increment(
                                                        reservation['amount']),
                                                'tokens':
                                                    FieldValue.arrayRemove(
                                                        tokens)
                                              });

                                              fb
                                                  .collection("reservations")
                                                  .doc(id)
                                                  .collection("attendees")
                                                  .doc(uid)
                                                  .delete();
                                            }
                                          });
                                        } else if (!isAttend &&
                                            snapshot.data
                                                    .data()["ticketsleft"] ==
                                                -1) {
                                          setState(() {
                                            isAttend = !isAttend;
                                          });
                                          List<String> ids = [id];
                                          List<String> uids = [uid];
                                          fb
                                              .collection("users")
                                              .doc(uid)
                                              .update({
                                            'attending':
                                                FieldValue.arrayUnion(ids)
                                          });
                                          fb
                                              .collection("events")
                                              .doc(id)
                                              .update({
                                            'attending':
                                                FieldValue.arrayUnion(uids),
                                          });
                                        } else if (isAttend &&
                                            snapshot.data
                                                    .data()["ticketsleft"] ==
                                                -1) {
                                          setState(() {
                                            isAttend = !isAttend;
                                          });
                                          List<String> ids = [id];
                                          List<String> uids = [uid];

                                          fb
                                              .collection("users")
                                              .doc(uid)
                                              .update({
                                            'attending':
                                                FieldValue.arrayRemove(ids)
                                          });
                                          fb
                                              .collection("events")
                                              .doc(id)
                                              .update({
                                            'attending':
                                                FieldValue.arrayRemove(uids)
                                          });
                                        }
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              18, 15, 18, 15),
                                          margin: EdgeInsets.only(
                                              bottom: 20, right: 10, top: 10),
                                          //    height: infoSquaresSize / 2,
                                          //    width: infoSquaresSize * 1.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white12,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    (isAttend)
                                                        ? "Attending "
                                                        : "Attend ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            globals.montserrat,
                                                        fontSize: 15,
                                                        color: Colors.green)),
                                                (isAttend)
                                                    ? isAttendIcon
                                                    : notAttendIcon
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBooked = !isBooked;
                                    List<String> ids = [id];
                                    if (isBooked)
                                      fb.collection("users").doc(uid).update({
                                        'booked': FieldValue.arrayUnion(ids)
                                      });
                                    else
                                      fb.collection("users").doc(uid).update({
                                        'booked': FieldValue.arrayRemove(ids)
                                      });
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(18, 15, 18, 15),
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 10, top: 10),
                                    //   height: infoSquaresSize / 2,
                                    //   width: infoSquaresSize * 1.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white12,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text((isBooked) ? "Saved " : "Save ",
                                              style: TextStyle(
                                                  fontFamily:
                                                      globals.montserrat,
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                          (isBooked)
                                              ? isBookedIcon
                                              : notBookedIcon
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Description Text
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: width,
                          child: Text(
                            description,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: descTextSize,
                                color: Colors.white),
                          ),
                        ),
                        // Age, Type, Fee squares
                        Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Age
                                Container(
                                  height: infoSquaresSize,
                                  width: infoSquaresSize,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          ageCheck,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: ageTextSize,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Type
                                Container(
                                  height: infoSquaresSize,
                                  width: infoSquaresSize,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          typeCheck,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: typeTextSize,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Fee
                                Container(
                                  height: infoSquaresSize,
                                  width: infoSquaresSize,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                            text: feeCheck,
                                            style: TextStyle(
                                                fontFamily: globals.montserrat,
                                                fontWeight: globals.fontWeight,
                                                fontSize: feeTextSize,
                                                color: Colors.white),
                                          ),
                                          TextSpan(
                                            text: "\nLBP",
                                            style: TextStyle(
                                                fontFamily: globals.montserrat,
                                                fontWeight: FontWeight.bold,
                                                fontSize: currencyTextSize,
                                                color: Colors.white),
                                          ),
                                        ]),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        // Date and Time squares
                        Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Date
                                Container(
                                  height: infoRectsHeight,
                                  width: infoRectsWidth,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: dateTextSize,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Time
                                Container(
                                  height: infoRectsHeight,
                                  width: infoRectsWidth,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          time,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: timeTextSize,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  }),
            ),
            // Location
            Container(
              child: Column(
                children: [
                  // Location Text
                  Container(
                    margin: EdgeInsets.all(20),
                    width: width,
                    child: Text(
                      "Location",
                      style: TextStyle(
                          fontFamily: globals.montserrat,
                          fontSize: titleTextSize,
                          color: Colors.white),
                    ),
                  ),
                  // Map
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    height: mapHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        markers: Set.from(setMarker),
                        initialCameraPosition: CameraPosition(
                            target: LatLng(locationPoint.latitude,
                                locationPoint.longitude),
                            zoom: 15.3),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Images
            if (urls != null && urls.length != 0)
              Container(
                width: width,
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: GFCarousel(
                  height: imagesHeight,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.8,
                  activeIndicator: Colors.white,
                  //aspectRatio: 1,
                  items: images.map(
                    (con) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: con),
                      );
                    },
                  ).toList(),
                  onPageChanged: (index) {},
                ),
              ),
            // Divider
            Container(
              child: Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
            ),
            Container(
              color: Colors.white12,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6, left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Contact",
                        style: TextStyle(
                            fontFamily: globals.montserrat,
                            fontSize: 23,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  // Phone Number
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(posteruid)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: globals.spinner);
                      }

                      return Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 30),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white12),
                          child: Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    navigateToOrganizerPage(posteruid);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: Text(
                                        snapshot.data.data()["name"][0],
                                        style: TextStyle(
                                            fontFamily: globals.montserrat,
                                            fontWeight: globals.fontWeight,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      navigateToOrganizerPage(posteruid);
                                    },
                                    child: Expanded(
                                      child: Text(
                                        snapshot.data.data()["name"],
                                        style: TextStyle(
                                            fontFamily: globals.montserrat,
                                            fontWeight: globals.fontWeight,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch("tel://" +
                                        snapshot.data.data()["number"]);
                                  },
                                  child: Align(
                                      child: Icon(Icons.phone,
                                          color: Colors.green),
                                      alignment: Alignment.centerRight),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
