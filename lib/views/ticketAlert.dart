import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:numberpicker/numberpicker.dart';

class TicketAlert extends StatefulWidget {
  @override
  final limit;
  const TicketAlert({Key? key, this.limit}) : super(key: key);
  _TicketAlertState createState() => _TicketAlertState(this.limit);
}

class _TicketAlertState extends State<TicketAlert> {
  final limit;
  _TicketAlertState(this.limit);


  @override
  TextStyle temp = TextStyle(
    color: Colors.white,
    fontFamily: globals.montserrat,
  );

  int _tickets = 1;
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Reservation', style: temp),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("How many tickets would you like to reserve?", style: temp),
              NumberPicker(
                  value: _tickets,
                  minValue: 1,
                  maxValue: limit > 2 ? 3 : limit,
                  step: 1,
                  haptics: true,
                  textStyle: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _tickets = value;
                    });
                    print(_tickets);
                  }),
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
              Navigator.of(context).pop(_tickets);
            },
          ),
        ],
      ),
    );
  }
}
