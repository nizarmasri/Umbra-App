import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';

class AddEventForm extends StatefulWidget {
  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {

  double inputSize = 17;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double textFieldHeight = height * 0.1;
    double descTextFieldHeight = height * 0.2;
    double ageTextWidth = width * 0.25;
    double ageFieldWidth = width * 0.6;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 15, bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add Event",
                      style: TextStyle(
                          fontFamily: globals.montserrat,
                          fontSize: 30,
                          color: Colors.white
                      ),
                    ),
                  ),
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
                              textAlign: TextAlign.center,
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
                          child: ListTile(
                            title: TextField(
                              controller: titleController,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: inputSize,
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight),
                              decoration: InputDecoration(
                                  hintText: "ex: 18+",
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
                ],
              ),
            ),
          )
      ),
    );
  }
}
