import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/libOrg/TicketCancelAlert.dart';
import 'package:events/libOrg/ticketAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events/libOrg/eventDetails.dart';
import 'package:events/globals.dart' as globals;

class SearchResultItem extends StatefulWidget {
  final QueryDocumentSnapshot data;

  SearchResultItem({Key key, this.data}) : super(key: key);

  @override
  _SearchResultItemState createState() => _SearchResultItemState(data);
}

class _SearchResultItemState extends State<SearchResultItem>
    with AutomaticKeepAliveClientMixin {
  final QueryDocumentSnapshot data;

  get wantKeepAlive => true;

  String title;
  String description;
  String type;
  String fee;
  String age;
  var date;
  String time;
  String location;
  GeoPoint locationPoint;
  List<dynamic> urls;
  String id;
  String posteruid;

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
  }

  navigateToEventDetailsPage(QueryDocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  data: data,
                ))).then((value) => setState(() {}));
  }

  _SearchResultItemState(this.data);

  Icon soldOutIcon = Icon(
    Icons.cancel_outlined,
    color: Colors.red,
  );

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

  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<void> checkIsAttendOrBooked() async {
    await fb.collection("users").doc(uid).get().then((value) {
      setState(() {
        if (value.data()['attending'].contains(id)) isAttend = true;
        if (value.data()['booked'].contains(id)) isBooked = true;
      });
    });
  }

  @override
  void initState() {
    getData();
    checkIsAttendOrBooked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double picSquaresSize = height * 0.13;
    double itemHeight = height * 0.25;

    return GestureDetector(
      onTap: () {
        navigateToEventDetailsPage(data);
      },
      child: Container(
        width: width,
        height: itemHeight,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
        child: Column(
          children: [
            if (urls == null || urls.length == 0)
              // no pics
              Container(
                height: picSquaresSize,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white10, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      'https://i.pinimg.com/originals/85/6f/31/856f31d9f475501c7552c97dbe727319.jpg',
                      filterQuality: FilterQuality.low,
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white12,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            // pics
            if (urls != null && urls.length != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // pic 1
                  Container(
                    height: picSquaresSize,
                    width: picSquaresSize,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (urls != null && urls.length != 0) ? urls[0] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  // pic 2
                  Container(
                    height: picSquaresSize,
                    width: picSquaresSize,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (urls != null && urls.length > 1) ? urls[1] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  // pic 3
                  Container(
                    height: picSquaresSize,
                    width: picSquaresSize,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white10, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          (urls != null && urls.length > 2) ? urls[2] : '',
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white12,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            // info
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: title,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "\n" + type + "  |  " + date,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 14,
                                color: Colors.white54),
                          ),
                          TextSpan(
                            text: "\n" + location,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight,
                                fontSize: 14,
                                color: Colors.white54),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          TicketAlert alert =
                              TicketAlert(limit: data["ticketsleft"]);
                          TicketCancelAlert cancelAlert = TicketCancelAlert();

                          if (!isAttend) {
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
                                DocumentSnapshot user =
                                    await fb.collection("users").doc(uid).get();

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

                                fb.collection("users").doc(uid).update(
                                    {'attending': FieldValue.arrayUnion(ids)});
                                fb.collection("events").doc(id).update({
                                  'attending': FieldValue.arrayUnion(uids),
                                  'ticketsleft': FieldValue.increment(-value),
                                });
                              }
                            });
                          } else {
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

                                print(reservation['amount']);

                                fb.collection("users").doc(uid).update(
                                    {'attending': FieldValue.arrayRemove(ids)});
                                fb.collection("events").doc(id).update({
                                  'attending': FieldValue.arrayRemove(uids),
                                  'ticketsleft': FieldValue.increment(
                                      reservation['amount']),
                                });

                                fb
                                    .collection("reservations")
                                    .doc(id)
                                    .collection("attendees")
                                    .doc(uid)
                                    .delete();
                              }
                            });
                          }
                        },
                        child: Container(
                            child: data["ticketsleft"] == 0
                                ? soldOutIcon
                                : (isAttend)
                                    ? isAttendIcon
                                    : notAttendIcon),
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
                                  {'booked': FieldValue.arrayRemove(ids)});
                          });
                        },
                        child: Container(
                            child: (isBooked) ? isBookedIcon : notBookedIcon),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
