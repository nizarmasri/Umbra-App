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

  String errorBirthday = "";
  String phonenumbererror = "";

  int page = 1;
  String name1 = "";
  String gender1 = "Male";
  String phonenumber1 = "";
  final _controller = new PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});

  DateTime selectedDate = DateTime.now();
  DateTime dateLimit = DateTime.utc(2002);
  bool changed = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        birthdayController.text = selectedDate.toString().substring(0, 10);
        changed = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: globals.background,
                  fit: BoxFit.fill,
                )),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.black87, Colors.black87])),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: height * 0.15, top: height * 0.2),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "u",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 110,
                                  color: Colors.white24)),
                          TextSpan(
                              text: "mbra",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 30,
                                  color: Colors.white70))
                        ]),
                      ),
                    ),
                  ),
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
              ),
            ),
          ),
        ));
  }

  double inputSize = 18;
  TextEditingController birthdayController = TextEditingController();

  Widget name() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.9;
    double btnHeight = height * 0.07;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          // Name text field
          Container(
            height: btnHeight,
            width: btnWidth,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: 15),
            child: Center(
              child: ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                title: TextField(
                  onChanged: (text) {
                    setState(() {
                      name1 = text;
                    });
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: inputSize,
                      fontFamily: globals.montserrat,
                      fontWeight: globals.fontWeight),
                  decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: inputSize,
                          fontFamily: globals.montserrat,
                          fontWeight: globals.fontWeight),
                      border: InputBorder.none,
                      focusColor: Colors.black,
                      fillColor: Colors.black),
                ),
              ),
            ),
          ),
          // Birthday field
          Container(
            height: btnHeight,
            width: btnWidth,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: 15),
            child: Center(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  title: TextField(
                    enabled: false,
                    controller: birthdayController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: inputSize,
                        fontFamily: globals.montserrat,
                        fontWeight: globals.fontWeight),
                    decoration: InputDecoration(
                        hintText: "Birthday",
                        hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: inputSize,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                        border: InputBorder.none,
                        focusColor: Colors.black,
                        fillColor: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Text(errorBirthday,
              style: TextStyle(
                color: Colors.red,
              )),
        ],
      ),
    );
  }

  Widget gender() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.9;
    double btnHeight = height * 0.07;
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: btnHeight,
        width: btnWidth,
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(bottom: 15),
        child: Center(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: width*0.06),
                child: Text(
                  "Gender : ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: inputSize,
                      fontFamily: globals.montserrat,
                      fontWeight: globals.fontWeight),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width*0.04),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: gender1,
                    dropdownColor: Colors.white10,
                    onChanged: (newValue) {
                      setState(() {
                        gender1 = newValue;
                      });
                    },
                    icon: Icon(Icons.arrow_downward, color: Colors.white54,),
                    iconSize: 15,
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: inputSize,
                        fontFamily: globals.montserrat,
                        fontWeight: globals.fontWeight
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
                  ),
                ),
              )
            ],
          )
        ),
      ),

    ]));
  }

  Widget phoneNumber() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double btnWidth = width * 0.9;
    double btnHeight = height * 0.07;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: btnHeight,
                width: btnWidth,
                decoration: BoxDecoration(
                    color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(bottom: 15),
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    title: TextField(
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
                          fontSize: inputSize,
                          fontFamily: globals.montserrat,
                          fontWeight: globals.fontWeight),
                      decoration: InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: inputSize,
                              fontFamily: globals.montserrat,
                              fontWeight: globals.fontWeight),
                          border: InputBorder.none,
                          focusColor: Colors.black,
                          fillColor: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          phonenumbererror,
          style: TextStyle(color: Colors.red),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white70,
          ),
          child: TextButton(
            onPressed: () async {
              if (name1.isEmpty || !changed || phonenumber1.isEmpty) {
                setState(() {
                  phonenumbererror = "Please fill in the required information.";
                });
                return;
              }
              if (selectedDate.isAfter(dateLimit)) {
                setState(() {
                  errorBirthday = "You must be older than 18 to sign up.";
                });
                _currentPageNotifier.value = 1;
                _controller.jumpTo(0);
                return;
              }
              if (phonenumber1.length < 8) {
                return;
              }
              List<dynamic> attending = [];
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'gender': gender1,
                'name': name1.trim(),
                'birthday': selectedDate,
                'number': phonenumber1,
                'new': false,
                'dp': '',
                'instagram': '',
                'twitter': '',
                'attending': attending,
                'booked' : attending
              });
            },
            child: Text(
              "Create Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: inputSize,
                  fontFamily: globals.montserrat,
                  fontWeight: globals.fontWeight),
            ),
          ),
        )
      ],
    );
  }
}
