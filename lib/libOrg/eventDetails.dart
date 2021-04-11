import 'package:awesome_loader/awesome_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
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
  final String posteruid;

  EventDetails({Key key,
    this.title,
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
    this.posteruid})
      : super(key: key);

  @override
  _EventDetailsState createState() =>
      _EventDetailsState(
          title,
          description,
          type,
          fee,
          age,
          date,
          time,
          location,
          locationPoint,
          urls,
          id,
          posteruid);
}

class _EventDetailsState extends State<EventDetails> {
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
  final String posteruid;

  _EventDetailsState(this.title,
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
      this.posteruid);

  double titleTextSize = 25;
  double descTextSize = 16;
  double ageTextSize = 25;
  double typeTextSize = 18;
  double feeTextSize = 24;
  double currencyTextSize = 12;
  double dateTextSize = 20;
  double timeTextSize = 22.5;

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
      if (value.data()["organizer"] == false)
        setState(() {
          isOrg = false;
        });
    });
    return isOrg;
  }

  Future<void> checkIsAttendOrBooked() async {
    await fb.collection("users").doc(uid).get().then((value) {
      if (value.data()['attending'].contains(id)) isAttend = true;
      if (value.data()['booked'].contains(id)) isBooked = true;
    });
  }

  Icon notAttendIcon = Icon(
    Icons.add_circle_outline_rounded,
    color: Colors.green,
  );
  Icon isAttendIcon = Icon(
    Icons.add_circle_rounded,
    color: Colors.green,
  );
  bool isAttend = false;

  Icon notBookedIcon = Icon(
    Icons.bookmark_border,
    color: Colors.blue,
  );

  Icon isBookedIcon = Icon(
    Icons.bookmark,
    color: Colors.blue,
  );

  bool isBooked = false;

  @override
  void initState() {
    setMarkerPos();
    checkIsOrg();
    checkIsAttendOrBooked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double infoSquaresSize = height * 0.114;
    double infoRectsHeight = height * 0.114;
    double infoRectsWidth = height * 0.171;
    double mapHeight = height * 0.2;
    double imagesHeight = height * 0.3;
    print(posteruid);
    String feeCheck = "";
    if (fee == "")
      feeCheck = "-";
    else
      feeCheck = fee;

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
                  child: Column(
                    children: [
                      // Title Text
                      Container(
                        margin: EdgeInsets.all(20),
                        width: width,
                        child: Text(
                          title,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: titleTextSize,
                              color: Colors.white),
                        ),
                      ),
                      if (!isOrg)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAttend = !isAttend;
                                  List<String> ids = [id];
                                  if (isAttend)
                                    fb.collection("users").doc(uid).update(
                                        {
                                          'attending': FieldValue.arrayUnion(
                                              ids)
                                        });
                                  else
                                    fb.collection("users").doc(uid).update(
                                        {
                                          'attending': FieldValue.arrayRemove(
                                              ids)
                                        });
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 20, right: 10),
                                  height: infoSquaresSize / 2,
                                  width: infoSquaresSize * 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white12,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                            (isAttend) ? "Attending" : "Attend",
                                            style: TextStyle(
                                                fontFamily: globals.montserrat,
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
                                    fb.collection("users").doc(uid).update(
                                        {'booked': FieldValue.arrayUnion(ids)});
                                  else
                                    fb.collection("users").doc(uid).update(
                                        {
                                          'booked': FieldValue.arrayRemove(ids)
                                        });
                                });
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20, left: 10),
                                  height: infoSquaresSize / 2,
                                  width: infoSquaresSize * 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white12,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text((isBooked)
                                            ? "Bookmarked"
                                            : "Bookmark",
                                            style: TextStyle(
                                                fontFamily: globals.montserrat,
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
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                                        borderRadius: BorderRadius.circular(
                                            10)),
                                    child: Center(
                                      child: Text(
                                        age,
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
                                        borderRadius: BorderRadius.circular(
                                            10)),
                                    child: Center(
                                      child: Text(
                                        type,
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
                                        borderRadius: BorderRadius.circular(
                                            10)),
                                    child: Center(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: feeCheck,
                                              style: TextStyle(
                                                  fontFamily: globals
                                                      .montserrat,
                                                  fontWeight: globals
                                                      .fontWeight,
                                                  fontSize: feeTextSize,
                                                  color: Colors.white),
                                            ),
                                            TextSpan(
                                              text: "\nLBP",
                                              style: TextStyle(
                                                  fontFamily: globals
                                                      .montserrat,
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
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                                        borderRadius: BorderRadius.circular(
                                            10)),
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
                                        borderRadius: BorderRadius.circular(
                                            10)),
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
                  ),
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
                        margin: EdgeInsets.only(left: 20, right: 20),
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
                            return Center(
                              child: AwesomeLoader(
                                loaderType: AwesomeLoader.AwesomeLoader2,
                                color: Colors.white,
                              ),
                            );
                          }

                          return Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white12
                              ),
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: Text(
                                          snapshot.data.data()["name"][0],
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: 20,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                          snapshot.data.data()["name"],
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: 20,
                                              color: Colors.white
                                          ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launch("tel://" +
                                            snapshot.data.data()["number"]);
                                      },
                                      child: Align(
                                          child: Icon(
                                              Icons.phone, color: Colors.green),
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
