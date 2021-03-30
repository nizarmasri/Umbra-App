
import 'package:events/libOrg/application_bloc.dart';
import 'package:events/libOrg/eventLocation.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';

class AddEventForm extends StatefulWidget {
  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  double inputSize = 17;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String _age;

  navigateToLocationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventLocation()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double textFieldHeight = height * 0.1;
    double descTextFieldHeight = height * 0.2;
    double ageTextWidth = width * 0.3;
    double ageFieldWidth = width * 0.5;
    double locTextWidth = width * 0.3;
    double locButtonWidth = width * 0.5;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Add event
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add Event",
                    style: TextStyle(
                        fontFamily: globals.montserrat,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ),
                // Title
                Container(
                  height: textFieldHeight,
                  width: textFieldWidth,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: ListTile(
                      title: TextField(
                        controller: titleController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: inputSize,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                        decoration: InputDecoration(
                            hintText: "Title",
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
                // Description
                Container(
                  height: descTextFieldHeight,
                  width: textFieldWidth,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: ListTile(
                      title: TextField(
                        controller: descController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: inputSize,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                        decoration: InputDecoration(
                            hintText: "Description",
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
                // Age
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: textFieldHeight,
                      width: ageTextWidth,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            "Age:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white38,
                                fontSize: inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: textFieldHeight,
                      width: ageFieldWidth,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                          child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _age,
                          style: TextStyle(
                              fontFamily: globals.montserrat,
                              fontSize: 16,
                              fontWeight: globals.fontWeight,
                              color: Colors.white),
                          //elevation: 5,
                          items: <String>[
                            'All ages',
                            '13 +',
                            '16 +',
                            '18 +',
                            '21 +',
                            '23 +',
                          ].map<DropdownMenuItem<String>>((String age) {
                            return DropdownMenuItem<String>(
                              value: age,
                              child: Text(age),
                            );
                          }).toList(),
                          hint: Text(
                            "Choose an age",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: globals.fontWeight,
                                fontFamily: globals.montserrat),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _age = value;
                            });
                          },
                        ),
                      )),
                    ),
                  ],
                ),
                // Maps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Location Text
                    Container(
                      height: textFieldHeight,
                      width: locTextWidth,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            "Location:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white38,
                                fontSize: inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        ),
                      ),
                    ),
                    // Location button
                    GestureDetector(
                      onTap: (){
                        navigateToLocationPage();
                      },
                      child: Container(
                        height: textFieldHeight,
                        width: locButtonWidth,
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Center(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.blue,
                              size: 30,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

