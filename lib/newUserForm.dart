import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'globals.dart' as globals;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewUserForm extends StatefulWidget {
  @override
  final uid;

  NewUserForm({Key key, this.uid}) : super(key: key);

  _NewUserFormState createState() => _NewUserFormState(uid);
}

class _NewUserFormState extends State<NewUserForm> {
  final uid;

  _NewUserFormState(this.uid);
  int page = 1;
  String birthday1;
  String name1;
  String gender1 = "Male";
  String phonenumber1;
  final _controller = new PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
                children: <Widget>[name(), gender(), phoneNumber()],
                controller: _controller,
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                }),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 15.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CirclePageIndicator(
                  itemCount: 3,
                  currentPageNotifier: _currentPageNotifier,
                ),
              ),
            )
          ],
        ));
  }

  Widget name() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please insert your name.",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border(bottom: BorderSide(color: Colors.white))),
            margin: EdgeInsets.all(20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  name1 = text;
                });
              },
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
              decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: globals.montserrat,
                      fontWeight: globals.fontWeight),
                  border: InputBorder.none,
                  focusColor: Colors.black,
                  fillColor: Colors.black),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border(bottom: BorderSide(color: Colors.white))),
            margin: EdgeInsets.all(20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  birthday1 = text;
                });
              },
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
              decoration: InputDecoration(
                  hintText: "Birthday",
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: globals.montserrat,
                      fontWeight: globals.fontWeight),
                  border: InputBorder.none,
                  focusColor: Colors.black,
                  fillColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget gender() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Gender",
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      DropdownButton<String>(
        value: gender1,
        onChanged: (newValue) {
          setState(() {
            gender1 = newValue;
          });
        },
        icon: const Icon(Icons.arrow_downward),
        iconSize: 15,
        elevation: 16,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w300,
        ),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        items: <String>['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ]));
  }

  Widget phoneNumber() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please insert your phone number.",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(bottom: BorderSide(color: Colors.white))),
                child: TextField(
                  onChanged: (newValue) {
                    setState(() {
                      phonenumber1 = newValue;
                    });
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    maskTextInputFormatter,
                  ],
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: globals.montserrat,
                      fontWeight: globals.fontWeight),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: globals.montserrat,
                          fontWeight: globals.fontWeight),
                      border: InputBorder.none,
                      focusColor: Colors.black,
                      fillColor: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set({
                'gender': gender1,
                'name': name1,
                'birthday': birthday1,
                'number': phonenumber1,
                'new': false,
              });
            },
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
          ),
        )
      ],
    );
  }
}
