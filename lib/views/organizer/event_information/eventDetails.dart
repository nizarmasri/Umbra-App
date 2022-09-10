import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/organizer/events_controllers/event_details_controller.dart';
import 'package:events/domains/event.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:events/views/ticketAlert.dart';
import 'package:events/views/TicketCancelAlert.dart';
import 'package:get/get.dart';

class EventDetails extends StatefulWidget {
  final Event event;

  EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState(event);
}

class _EventDetailsState extends State<EventDetails> {
  final Event event;

  _EventDetailsState(this.event);

  EventDetailsController controller =
      EventDetailsController(event: Event.initialize());

  double titleTextSize = 25;
  double descTextSize = 16;
  double ageTextSize = 20;
  double typeTextSize = 15;
  double feeTextSize = 21;
  double currencyTextSize = 10;
  double dateTextSize = 17;
  double timeTextSize = 19.5;

  @override
  void initState() {
    controller = Get.put(EventDetailsController(event: event));
    super.initState();
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

    String? feeCheck = "";
    if (controller.event.fee == "" || controller.event.fee == "Free")
      feeCheck = "-";
    else
      feeCheck = controller.event.fee;

    String? ageCheck = controller.event.age;
    if (controller.event.age == "All ages") {
      ageCheck = "All\nages";
      ageTextSize = 18;
    }
    String? typeCheck = controller.event.type;
    if (controller.event.type.contains(' ')) {
      typeCheck = typeCheck.replaceAll(' ', '\n');
    }

    controller.event.urls.forEach((url) {
      controller.images.add(Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Image.network(url,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                  Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          })));
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          if (controller.isOrg.value)
            IconButton(
                icon: Icon(Icons.group_outlined, color: Colors.white),
                onPressed: () {
                  controller.navigateToAttendees(controller.event, context);
                }),
          if (controller.isOrg.value)
            IconButton(
                icon: Icon(Icons.equalizer, color: Colors.white),
                onPressed: () {
                  controller.navigateToEventStatistics(
                      controller.event, context);
                }),
          if (controller.isOrg.value)
            IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {
                  controller.navigateToEdit(controller.event, context);
                }),
          if (controller.isOrg.value)
            IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  controller.navigateToEventStatistics(
                      controller.event, context);
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
                  stream: controller.fb
                      .collection("events")
                      .doc(controller.event.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: globals.spinner);
                    }
                    final result = snapshot.data as DocumentSnapshot;
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
                                controller.event.title,
                                style: TextStyle(
                                    fontFamily: globals.montserrat,
                                    fontSize: titleTextSize,
                                    color: Colors.white),
                              ),
                            ),
                            if (result["ticketsleft"] != -1)
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 0),
                                width: width,
                                child: Text(
                                  (result["ticketsleft"]?.toString())! +
                                      " tickets left",
                                  style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        if (!controller.isOrg.value)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              result["ticketsleft"] == 0
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
                                      onTap: () async {
                                        TicketAlert alert = TicketAlert(
                                            limit: result["ticketsleft"]);
                                        TicketCancelAlert cancelAlert =
                                            TicketCancelAlert();
                                        if (!controller.isAttend.value &&
                                            result["ticketsleft"] != -1) {
                                          return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              }).then((value) async {
                                            if (value != null) {
                                              setState(() {
                                                controller.isAttend(
                                                    !controller.isAttend.value);
                                              });
                                              List<String?> ids = [
                                                controller.event.id
                                              ];
                                              List<String> uids = [
                                                controller.uid
                                              ];
                                              DocumentSnapshot user =
                                                  await controller.fb
                                                      .collection("users")
                                                      .doc(controller.uid)
                                                      .get();

                                              controller.fb
                                                  .collection("reservations")
                                                  .doc(controller.event.id)
                                                  .collection("attendees")
                                                  .doc(controller.uid)
                                                  .set({
                                                'amount': value,
                                                'name': user['name'],
                                                'dp': user['dp'],
                                                'confirmed': 0
                                              });

                                              controller.fb
                                                  .collection("users")
                                                  .doc(controller.uid)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayUnion(ids)
                                              });
                                              controller.fb
                                                  .collection("events")
                                                  .doc(controller.event.id)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayUnion(uids),
                                                'ticketsleft':
                                                    FieldValue.increment(
                                                        -value),
                                                'tokens': FieldValue.arrayUnion(
                                                    controller.tokens)
                                              });
                                            }
                                          });
                                        } else if (controller.isAttend.value &&
                                            result["ticketsleft"] != -1) {
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return cancelAlert;
                                              }).then((value) async {
                                            if (value == true) {
                                              setState(() {
                                                controller.isAttend(
                                                    !controller.isAttend.value);
                                              });
                                              List<String?> ids = [
                                                controller.event.id
                                              ];
                                              List<String> uids = [
                                                controller.uid
                                              ];

                                              dynamic reservation =
                                                  await controller.fb
                                                      .collection(
                                                          "reservations")
                                                      .doc(controller.event.id)
                                                      .collection("attendees")
                                                      .doc(controller.uid)
                                                      .get();

                                              controller.fb
                                                  .collection("users")
                                                  .doc(controller.uid)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayRemove(ids)
                                              });
                                              controller.fb
                                                  .collection("events")
                                                  .doc(controller.event.id)
                                                  .update({
                                                'attending':
                                                    FieldValue.arrayRemove(
                                                        uids),
                                                'ticketsleft':
                                                    FieldValue.increment(
                                                        reservation['amount']),
                                                'tokens':
                                                    FieldValue.arrayRemove(
                                                        controller.tokens)
                                              });

                                              controller.fb
                                                  .collection("reservations")
                                                  .doc(controller.event.id)
                                                  .collection("attendees")
                                                  .doc(controller.uid)
                                                  .delete();
                                            }
                                          });
                                        } else if (!controller.isAttend.value &&
                                            result["ticketsleft"] == -1) {
                                          setState(() {
                                            controller.isAttend(
                                                !controller.isAttend.value);
                                          });
                                          List<String?> ids = [
                                            controller.event.id
                                          ];
                                          List<String> uids = [controller.uid];
                                          controller.fb
                                              .collection("users")
                                              .doc(controller.uid)
                                              .update({
                                            'attending':
                                                FieldValue.arrayUnion(ids)
                                          });
                                          controller.fb
                                              .collection("events")
                                              .doc(controller.event.id)
                                              .update({
                                            'attending':
                                                FieldValue.arrayUnion(uids),
                                          });
                                        } else if (controller.isAttend.value &&
                                            result["ticketsleft"] == -1) {
                                          setState(() {
                                            controller.isAttend(
                                                !controller.isAttend.value);
                                          });
                                          List<String?> ids = [
                                            controller.event.id
                                          ];
                                          List<String> uids = [controller.uid];

                                          controller.fb
                                              .collection("users")
                                              .doc(controller.uid)
                                              .update({
                                            'attending':
                                                FieldValue.arrayRemove(ids)
                                          });
                                          controller.fb
                                              .collection("events")
                                              .doc(controller.event.id)
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
                                                    (controller.isAttend.value)
                                                        ? "Attending "
                                                        : "Attend ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            globals.montserrat,
                                                        fontSize: 15,
                                                        color: Colors.green)),
                                                (controller.isAttend.value)
                                                    ? controller.isAttendIcon
                                                    : controller.notAttendIcon
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controller
                                        .isBooked(!controller.isBooked.value);
                                    List<String?> ids = [controller.event.id];
                                    if (controller.isBooked.value)
                                      controller.fb
                                          .collection("users")
                                          .doc(controller.uid)
                                          .update({
                                        'booked': FieldValue.arrayUnion(ids)
                                      });
                                    else
                                      controller.fb
                                          .collection("users")
                                          .doc(controller.uid)
                                          .update({
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
                                          Text(
                                              (controller.isBooked.value)
                                                  ? "Saved "
                                                  : "Save ",
                                              style: TextStyle(
                                                  fontFamily:
                                                      globals.montserrat,
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                          (controller.isBooked.value)
                                              ? controller.isBookedIcon
                                              : controller.notBookedIcon
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
                            controller.event.description,
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
                                          ageCheck!,
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
                                          typeCheck!,
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
                                          controller.event.date,
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
                                          controller.event.time,
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
                        markers: Set.from(controller.setMarker),
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                controller.event.locationPoint.latitude,
                                controller.event.locationPoint.longitude),
                            zoom: 15.3),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Images
            if (controller.event.urls != null &&
                controller.event.urls.length != 0)
              Container(
                width: width,
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: GFCarousel(
                  height: imagesHeight,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.8,
                  activeIndicator: Colors.white,
                  //aspectRatio: 1,
                  items: controller.images.map(
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
                        .doc(controller.event.posterUid)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: globals.spinner);
                      }

                      final DocumentSnapshot data =
                          snapshot.data as DocumentSnapshot;

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
                                    controller.navigateToOrganizerPage(
                                        controller.event.posterUid, context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: Text(
                                        snapshot.data != null
                                            ? data["name"][0]
                                            : "",
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
                                      controller.navigateToOrganizerPage(
                                          controller.event.posterUid, context);
                                    },
                                    child: Expanded(
                                      child: Text(
                                        data["name"],
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
                                    launch("tel://" + data["number"]);
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
