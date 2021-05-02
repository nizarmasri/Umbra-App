import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

class TicketCancelAlert extends StatelessWidget {
  @override
  TextStyle temp = TextStyle(
    color: Colors.white,
    fontFamily: globals.montserrat,
  );

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Reservation Cancelling', style: temp),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("Are you sure you want to cancel your reservation?",
                style: temp),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
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
