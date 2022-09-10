import 'package:events/domains/event.dart';
import 'package:events/views/organizer/add_event/eventLocation.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class AddEventForm extends StatefulWidget {
  final Event event;

  AddEventForm({Key? key, required this.event}) : super(key: key);

  @override
  _AddEventFormState createState() => _AddEventFormState(event);
}

class _AddEventFormState extends State<AddEventForm> {
  final Event event;

  _AddEventFormState(this.event);

  bool hasData = false;

  final geo = Geoflutterfire();
  double inputSize = 16;
  double italicTextSize = 14;
  double titleSize = 25;
  double feeText = 14.5;
  Color boxesColor = Colors.black;
  Color dividerColor = Colors.white12;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController ticketsLeftController = TextEditingController();

  List<Marker>? location;
  String? locationName = "Choose event location";
  Color locationTextColor = Colors.white24;

  String? _age;
  String? _type;

  bool loading = false;

  navigateToLocationPage() async {
    final chosenLocation = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventLocation()));
    setState(() {
      location = chosenLocation[0];
      locationName = chosenLocation[1];
      if (location != null) print(location![0].position);
      print(locationName!.split(",")[0]);
      locationTextColor = Colors.white;
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

  List<String> urls = [];

  String submitError = "";
  bool filledForm = true;

  bool checkSubmit() {
    List<String?> values = [
      titleController.text,
      descController.text,
      _age,
      _type,
      selectedDate.toString(),
      selectedTimeFormatted,
      location.toString(),
      feeController.text,
      ticketsLeftController.text,
    ];

    bool tempCheck = true;

    for (int i = 0; i < values.length; i++) {
      setState(() {
        if (values[i] == null ||
            values[i] == "" ||
            values[i] == "null" ||
            values[i] == timeNow.toString().substring(10, 15) ||
            values[i] == dateLimit.toString()) {
          filledForm = false;
          tempCheck = false;
          if (i == 0)
            submitError += "Title cannot be empty\n";
          else if (i == 1)
            submitError += "Description cannot be empty\n";
          else if (i == 2)
            submitError += "Please pick an age\n";
          else if (i == 3)
            submitError += "Please pick a type\n";
          else if (i == 4)
            submitError += "Please pick a date\n";
          else if (i == 5)
            submitError += "Please pick a time\n";
          else if (i == 6)
            submitError += "Please pick a location\n";
          else if (i == 7)
            feeController.text = "Free";
          else if (i == 8) ticketsLeftController.text = " ";
        } else if (tempCheck == true) filledForm = true;
      });
    }
    print(filledForm);
    return filledForm;
  }

  Future<void> submitEvent() async {
    submitError = "";

    int reservations;
    if (!needsReservation || ticketsLeftController.text == "") {
      reservations = -1;
      ticketsLeftController.text = " ";
    } else
      reservations = int.parse(ticketsLeftController.text);

    if (checkSubmit()) {
      setState(() {
        loading = true;
      });
      FirebaseFirestore fb = FirebaseFirestore.instance;

      GeoFirePoint myLocation = geo.point(
          latitude: location![0].position.latitude,
          longitude: location![0].position.longitude);

      if (hasData) {
        await fb.collection('events').doc(event.id).update({
          'title': titleController.text,
          'description': descController.text,
          'age': _age,
          'type': _type,
          'date': selectedDate,
          'time': selectedTimeFormatted,
          'location': myLocation.data,
          'locationName': locationName,
          'fee': feeController.text,
          'ticketsleft': reservations
        }).then((value) async {
          final id = event.id;
          List<String> ids = [id];
          await fb
              .collection('users')
              .doc(uid)
              .update({'events': FieldValue.arrayUnion(ids)});
          for (var entry in images.asMap().entries) {
            int entryIndex = entry.key;
            final firebaseStorageRef =
                FirebaseStorage.instance.ref().child('$id/$entryIndex');
            final dynamic upload = await firebaseStorageRef
                .putData((await entry.value.getByteData(quality: 50))
                    .buffer
                    .asUint8List())
                .then((value) async {
              urls.add(await firebaseStorageRef.getDownloadURL());
            });
          }
          return {"urls": urls, "id": id};
        }).then((value) async {
          await fb.collection('events').doc(event.id).update({
            'urls': FieldValue.arrayUnion(value["urls"] as List<dynamic>),
          });
          return false;
        }).then((value) {
          Navigator.pop(context);
        });
      } else {
        List<dynamic> attending = [];
        await fb.collection('events').add({
          'title': titleController.text,
          'description': descController.text,
          'age': _age,
          'attending': attending,
          'type': _type,
          'date': selectedDate,
          'time': selectedTime.toString().substring(10, 15),
          'poster': uid,
          'location': myLocation.data,
          'locationName': locationName,
          'fee': feeController.text,
          'ticketsleft': reservations
        }).then((value) async {
          final id = value.id;
          List<String> ids = [id];
          await fb
              .collection('users')
              .doc(uid)
              .update({'events': FieldValue.arrayUnion(ids)});
          for (var entry in images.asMap().entries) {
            int entryIndex = entry.key;
            final firebaseStorageRef =
                FirebaseStorage.instance.ref().child('$id/$entryIndex');
            final dynamic upload = await firebaseStorageRef
                .putData((await entry.value.getByteData(quality: 50))
                    .buffer
                    .asUint8List())
                .then((value) async {
              urls.add(await firebaseStorageRef.getDownloadURL());
            });
          }
          return {"urls": urls, "id": id};
        }).then((value) async {
          await fb.collection('events').doc(value["id"] as String?).update({
            'urls': FieldValue.arrayUnion(value["urls"] as List<dynamic>),
          });
          return false;
        }).then((value) {
          Navigator.pop(context);
        });
      }
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String color = "#2b2b2b";
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
            backgroundColor: color,
            selectionFillColor: color,
            selectionStrokeColor: color),
        materialOptions: MaterialOptions(
          actionBarColor: color,
          actionBarTitle: "Pick images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          statusBarColor: color,
          selectCircleStrokeColor: color,
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

  DateTime? selectedDate = DateTime.now();
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
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        changedDate = true;
      });
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay timeNow = TimeOfDay.now();
  String? selectedTimeFormatted = "";
  bool changedTime = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        changedTime = true;
      });
    selectedTimeFormatted = selectedTime.toString().substring(10, 15);
  }

  bool isFree = true;
  bool needsReservation = true;

  void checkEdit() {
    if (event != null)
      hasData = true;
    else
      hasData = false;

    if (hasData) {
      DateTime? dateFormatted = DateTime.tryParse(event.date);
      changedDate = true;
      changedTime = true;

      if (event.fee == 'Free')
        isFree = true;
      else
        isFree = false;

      location = [];

      titleController.text = event.title;
      descController.text = event.description;
      _age = event.age;
      _type = event.type;
      selectedDate = dateFormatted;
      selectedTimeFormatted = event.time;
      location!.add(Marker(
          markerId: MarkerId(event.location),
          position: LatLng(
              event.locationPoint.latitude, event.locationPoint.longitude)));
      locationName = event.location;
      feeController.text = event.fee;

      if (event.tickets == -1) ticketsLeftController.text = "";
    }
  }

  void deleteEvent() {}

  @override
  void initState() {
    checkEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double titleFieldHeight = height * 0.1;
    double descTextFieldHeight = height * 0.2;
    double btnsHeight = height * 0.07;
    double btnsTextWidth = width * 0.2;
    double btnsWidth = width * 0.5;

    return !loading
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                GestureDetector(
                  onTap: () {
                    submitEvent();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                )
              ],
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
                      if (!filledForm)
                        Container(
                          padding:
                              EdgeInsets.only(left: 15, top: 5, bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            submitError,
                            style: TextStyle(
                                fontFamily: globals.montserrat,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        ),
                      // Title field
                      Container(
                        height: titleFieldHeight,
                        width: textFieldWidth,
                        decoration: BoxDecoration(
                            color: boxesColor,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(bottom: 0),
                        child: Center(
                            child: TextField(
                          controller: titleController,
                          cursorColor: Colors.white,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
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
                        )),
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Description
                      Container(
                        height: titleFieldHeight,
                        width: textFieldWidth,
                        decoration: BoxDecoration(
                          color: boxesColor,
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Center(
                          child: TextField(
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
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Event Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Type Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            color: Colors.black,
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                                child: Icon(
                              Icons.liquor,
                              color: Colors.white70,
                            )),
                          ),
                          // Type picker
                          Container(
                            height: btnsHeight,
                            width: btnsWidth,
                            color: boxesColor,
                            margin: EdgeInsets.only(bottom: 15),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.grey[900],
                                icon: Icon(
                                  Icons.arrow_downward_outlined,
                                  size: 0,
                                  color: Colors.transparent,
                                ),
                                value: _type,
                                style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontSize: 16,
                                  fontWeight: globals.fontWeight,
                                  color: Colors.white70,
                                ),
                                //elevation: 5,
                                items: <String>[
                                  'Club',
                                  'Pub',
                                  'Gig',
                                  'House Party',
                                  'Concert',
                                  'Trivia night',
                                  'Viewing party',
                                  'Gathering'
                                ].map<DropdownMenuItem<String>>((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Pick a type",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: italicTextSize,
                                      fontWeight: globals.fontWeight,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: globals.montserrat),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _type = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Date Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Container(
                                height: btnsHeight,
                                width: btnsTextWidth,
                                color: Colors.black,
                                margin: EdgeInsets.only(bottom: 15),
                                child: Center(
                                    child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white70,
                                )),
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
                                  color: boxesColor,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: !changedDate
                                    ? Text(
                                        "Pick a date",
                                        style: TextStyle(
                                            fontFamily: globals.montserrat,
                                            fontWeight: globals.fontWeight,
                                            fontStyle: FontStyle.italic,
                                            fontSize: italicTextSize,
                                            color: Colors.white70),
                                      )
                                    : Text(
                                        selectedDate
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            fontFamily: globals.montserrat,
                                            fontWeight: globals.fontWeight,
                                            fontSize: inputSize,
                                            color: Colors.white70),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Container(
                                height: btnsHeight,
                                width: btnsTextWidth,
                                color: Colors.black,
                                margin: EdgeInsets.only(bottom: 15),
                                child: Center(
                                    child: Icon(
                                  Icons.access_time,
                                  color: Colors.white70,
                                )),
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
                                  color: boxesColor,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: !changedTime
                                      ? Text(
                                          "Pick a time",
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontStyle: FontStyle.italic,
                                              fontSize: italicTextSize,
                                              color: Colors.white70),
                                        )
                                      : Text(
                                          selectedTimeFormatted!,
                                          style: TextStyle(
                                              fontFamily: globals.montserrat,
                                              fontWeight: globals.fontWeight,
                                              fontSize: inputSize,
                                              color: Colors.white70),
                                        )),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Age
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Age Text
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            color: Colors.black,
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                                child: Icon(
                              Icons.security_outlined,
                              color: Colors.white70,
                            )),
                          ),
                          // Age picker
                          Container(
                            height: btnsHeight,
                            width: btnsWidth,
                            decoration: BoxDecoration(
                                color: boxesColor,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.grey[900],
                                    icon: Icon(
                                      Icons.arrow_downward,
                                      size: 0,
                                      color: Colors.transparent,
                                    ),
                                    value: _age,
                                    style: TextStyle(
                                      fontFamily: globals.montserrat,
                                      fontSize: inputSize,
                                      fontWeight: globals.fontWeight,
                                      color: Colors.white70,
                                    ),
                                    //elevation: 5,
                                    items: <String>[
                                      'All ages',
                                      '13 +',
                                      '16 +',
                                      '18 +',
                                      '21 +',
                                      '23 +',
                                    ].map<DropdownMenuItem<String>>(
                                        (String age) {
                                      return DropdownMenuItem<String>(
                                        value: age,
                                        child: Text(age),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Pick an age",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: italicTextSize,
                                          fontWeight: globals.fontWeight,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: globals.montserrat),
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _age = value;
                                      });
                                    },
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Entrance fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            color: Colors.black,
                            child: Center(
                                child: Icon(
                              Icons.attach_money_outlined,
                              color: Colors.white70,
                            )),
                          ),
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            padding: EdgeInsets.only(right: width * 0.11),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Free",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: inputSize,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              ),
                            ),
                          ),
                          Container(
                            child: Switch(
                              value: isFree,
                              onChanged: (value) {
                                setState(() {
                                  isFree = !isFree;
                                });
                              },
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      if (!isFree)
                        Container(
                          height: btnsHeight,
                          width: textFieldWidth,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListTile(
                              title: TextField(
                                keyboardType: TextInputType.number,
                                controller: feeController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: inputSize,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                decoration: InputDecoration(
                                    hintText: "Price",
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
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),
                      // Reservations
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth,
                            color: Colors.black,
                            child: Center(
                                child: Icon(
                              Icons.event_seat_outlined,
                              color: Colors.white70,
                            )),
                          ),
                          Container(
                            height: btnsHeight,
                            width: btnsTextWidth * 1.8,
                            padding: EdgeInsets.only(right: width * 0.11),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Reservations",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: inputSize,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              ),
                            ),
                          ),
                          Container(
                            child: Switch(
                              value: needsReservation,
                              onChanged: (value) {
                                setState(() {
                                  needsReservation = !needsReservation;
                                });
                              },
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      if (!needsReservation)
                        Container(
                          height: btnsHeight,
                          width: textFieldWidth,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListTile(
                              title: TextField(
                                keyboardType: TextInputType.number,
                                controller: ticketsLeftController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: inputSize,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                decoration: InputDecoration(
                                    hintText: "Capacity",
                                    icon: Icon(
                                      Icons.group_outlined,
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
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),

                      // Maps
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Location button
                          GestureDetector(
                            onTap: () {
                              navigateToLocationPage();
                            },
                            child: Container(
                              height: btnsHeight,
                              width: textFieldWidth,
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              child: Container(
                                  child: Center(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.pin_drop_outlined,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  title: Text(
                                    locationName!,
                                    style: TextStyle(
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight,
                                        color: locationTextColor),
                                  ),
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: dividerColor,
                        thickness: 1,
                      ),

                      // Pick images button
                      GestureDetector(
                        onTap: () async {
                          loadAssets();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Colors.white10),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Grid of images
                      Container(
                          height:
                              calculateHeight(images.length).toDouble() + 70,
                          width: width * 0.95,
                          margin: EdgeInsets.only(top: 10),
                          child: buildGridView()),
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
              width: asset.originalWidth!,
              height: asset.originalHeight!,
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
