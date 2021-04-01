import 'package:events/libOrg/blocs/application_bloc.dart';
import 'package:events/libOrg/eventLocation.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class AddEventForm extends StatefulWidget {
  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  double inputSize = 17;
  double feeText = 14.5;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  List<Marker> location;

  String _age;
  String _type;

  bool loading = false;

  navigateToLocationPage() async {
    final chosenLocation = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventLocation()));
    setState(() {
      location = chosenLocation;
      if (location != null) print(location[0].position);
    });
  }

  String _error = 'No Error Dectected';
  List<Asset> images = <Asset>[];

  Widget buildGridView() {
    return GridView.count(
      primary: false,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return InkWell(
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(asset);
            }));
          },
        );
      }),
    );
  }

  String urls;

  Container button({String uid}) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      child: InkWell(
        focusColor: Colors.white,
        onTap: () async {
          setState(() {
            loading = true;
          });
          FirebaseFirestore fb = FirebaseFirestore.instance;

          await fb.collection('events').add({
            'title': titleController.text,
            //   'description': descController.text,
            //   'age': _age,
            //   'date': selectedDate,
            //   'time': selectedTime.toString().substring(10, 15),
            //   'poster': uid,
            //  'location': GeoPoint(
            //      location[0].position.latitude, location[0].position.longitude),
          }).then((value) async {
            final id = value.id;
            images.asMap().forEach((index, value) async {
              final firebaseStorageRef =
                  FirebaseStorage.instance.ref().child('$id/$index');
              final upload = firebaseStorageRef
                  .putData((await value.getByteData()).buffer.asUint8List())
                  .then((value) async {
                String url = await firebaseStorageRef.getDownloadURL();
                print(url);
                await fb.collection('events').doc(id).update({
                  'urls': FieldValue.arrayUnion([url]),
                });
              });
            });
          }).then((value) {
            Navigator.pop(context);
          });
        },
        child: Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: Center(
            child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  DateTime selectedDate = DateTime.now();
  DateTime dateLimit = DateTime.now();
  bool changedDate = false;

  int calculateHeight(int length) {
    if (length == 0) {
      return length;
    } else {
      return (length / 3).ceil() * 120;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        changedDate = true;
      });
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  bool changedTime = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        changedTime = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double titleFieldHeight = height * 0.1;
    double descTextFieldHeight = height * 0.2;
    double btnsHeight = height * 0.07;
    double btnsTextWidth = width * 0.3;
    double btnsWidth = width * 0.5;

    return !loading
        ? Scaffold(
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
                      // Add event text
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
                      // Title field
                      Container(
                        height: titleFieldHeight,
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
                              textAlignVertical: TextAlignVertical.top,
                              expands: true,
                              maxLines: null,
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
                      // Event Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Type:",
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
                            height: btnsHeight,
                            width: btnsWidth,
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                                child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _type,
                                style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontSize: 16,
                                  fontWeight: globals.fontWeight,
                                  color: Colors.white,
                                ),
                                //elevation: 5,
                                items: <String>[
                                  'Club',
                                  'Pub',
                                  'Gig',
                                  'House Party',
                                ].map<DropdownMenuItem<String>>((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Choose a type",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: globals.fontWeight,
                                      fontFamily: globals.montserrat),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    _type = value;
                                  });
                                },
                              ),
                            )),
                          ),
                        ],
                      ),
                      // Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Date Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Date:",
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
                          // Calendar button
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              height: btnsHeight,
                              width: btnsWidth,
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Center(
                                child: !changedDate
                                    ? Icon(
                                        Icons.calendar_today_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      )
                                    : Text(
                                        selectedDate
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            fontFamily: globals.montserrat,
                                            fontWeight: globals.fontWeight,
                                            fontSize: inputSize,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Time Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Time:",
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
                          // Time button
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: Container(
                              height: btnsHeight,
                              width: btnsWidth,
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Center(
                                  child: !changedTime
                                      ? Icon(
                                          Icons.access_time,
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      : Text(
                                          selectedTime
                                              .toString()
                                              .substring(10, 15),
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: inputSize,
                                              color: Colors.white),
                                        )),
                            ),
                          ),
                        ],
                      ),
                      // Entrance fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Entrance Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  "Entrance:",
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
                          // Fee Text Field
                          Container(
                            height: btnsHeight,
                            width: btnsWidth,
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                title: TextField(
                                  controller: feeController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: inputSize,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  decoration: InputDecoration(
                                      hintText: "Fee (optional)",
                                      icon: Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white38,
                                          fontSize: feeText,
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
                      // Age
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
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
                            height: btnsHeight,
                            width: btnsWidth,
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
                                  color: Colors.white,
                                ),
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
                            height: btnsHeight,
                            width: btnsTextWidth,
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
                            onTap: () {
                              navigateToLocationPage();
                            },
                            child: Container(
                              height: btnsHeight,
                              width: btnsWidth,
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
                      ElevatedButton(
                        child: Text("Pick images"),
                        onPressed: () async {
                          loadAssets();
                        },
                      ),
                      Container(
                          height: calculateHeight(images.length).toDouble(),
                          width: width,
                          child: buildGridView()),
                      button(uid: uid),
                    ],
                  ),
                ),
              ),
            )),
          )
        : globals.spinner;
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(this.asset);

  final Asset asset;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: AssetThumb(
              asset: asset,
              width: asset.originalWidth,
              height: asset.originalHeight,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
