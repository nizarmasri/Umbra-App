import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final tokenlist;
  final organizerUid;

  const Notifications({Key key, this.tokenlist, this.organizerUid})
      : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  bool subscribed = true;
  String token;

  void checkToken() async {
    String newtoken = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = newtoken;
      if (!widget.tokenlist.contains(newtoken)) {
        subscribed = false;
      }
    });
  }

  void subscribe() {
    firebase.collection("users").doc(widget.organizerUid).update({
      "subscribers": subscribed
          ? FieldValue.arrayRemove([token])
          : FieldValue.arrayUnion([token])
    }).then((value) => {
          setState(() {
            subscribed = !subscribed;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Alert(subscribed);
            }).then((value) => {
              if (value) {subscribe()}
            })
      },
      iconSize: 35,
      icon: Icon(
        Icons.notifications_active,
        color: subscribed ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class Alert extends StatelessWidget {
  String toSubscribe =
      "Are you sure you want to recieve notifications from this organizer?";
  String toUnsubscribe =
      "Are you sure you want to disable notifications from this organizer?";
  final bool subscribed;
  Alert(this.subscribed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        subscribed ? "Disable Notifications" : "Enable Notifications",
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              subscribed ? toUnsubscribe : toSubscribe,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
