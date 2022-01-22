import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'globals.dart' as globals;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
  }

  double inputSize = 17;

  String uid = FirebaseAuth.instance.currentUser.uid;

  bool loading = false;
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatter2 = MaskTextInputFormatter();
  TextEditingController _namecontroller;
  TextEditingController _numbercontroller;
  TextEditingController _twittercontroller;
  TextEditingController _instagramcontroller;

  String _error = 'No Error Dectected';
  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Container avatar({String letter, String existingPicture}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          forYouAlgorithm();
        },
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.brown.shade800,
                backgroundImage: images.isNotEmpty
                    ? AssetThumbImageProvider(
                        images[0],
                        width: 200,
                        height: 200,
                        quality: 100,
                      )
                    : existingPicture != ''
                        ? NetworkImage(existingPicture)
                        : null,
                child: Text(
                  images.isEmpty && existingPicture == '' ? letter : "",
                  style: TextStyle(fontSize: 80),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                  child: IconButton(
                onPressed: () {
                  loadAssets();
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Container newInput(
      {String hint,
      Icon icon,
      String defvalue,
      TextEditingController controller,
      MaskTextInputFormatter mask,
      TextInputType type,
      double height,
      double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 15),
      child: Center(
        child: ListTile(
          leading: icon,
          title: TextField(
            inputFormatters: [
              mask,
            ],
            keyboardType: type,
            controller: controller,
            style: TextStyle(
                color: Colors.white,
                fontSize: inputSize,
                fontFamily: globals.montserrat,
                fontWeight: globals.fontWeight),
            decoration: InputDecoration(
                hintText: hint,
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
    );
  }

  Container button({String uid}) {
    return Container(
      child: InkWell(
        focusColor: Colors.white,
        onTap: () async {
          setState(() {
            loading = true;
          });
          if (images.isNotEmpty) {
            final firebaseStorageRef =
                FirebaseStorage.instance.ref().child('profilepictures/$uid');
            await firebaseStorageRef
                .putData((await images[0].getByteData(quality: 50))
                    .buffer
                    .asUint8List())
                .then((value) async {
              final url = await firebaseStorageRef.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'name': _namecontroller.text,
                'number': _numbercontroller.text,
                'twitter': _twittercontroller.text,
                'instagram': _instagramcontroller.text,
                'dp': url,
              }).then((value) {
                Navigator.pop(context);
              });
            });
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
              'name': _namecontroller.text,
              'number': _numbercontroller.text,
              'twitter': _twittercontroller.text,
              'instagram': _instagramcontroller.text
            }).then((value) {
              Navigator.pop(context);
            });
          }
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

  int countSimilarOccurrences(List<String> list, String wordB) {
    if (list == null || list.isEmpty) {
      return 0;
    }
    var foundElements = list.where((wordA) =>
        wordA.toUpperCase().similarityTo(wordB.toUpperCase()) >= 0.8);
    return foundElements.length;
  }

  void forYouAlgorithm() {
    String eventA1 =
        "Best pub in Mar Mikhael, happy hour this Friday from 10 to 12!! Great RNB music from DJ Bobert.";
    String eventA2 =
        "this is the coolest pub in town if you come here you will have the best time of your life and drink so much that all you will think about is drinking so much";
    String eventA3 =
        "The national Lebanese Orchestra is performing at the Byblos music festival.";
    String eventA4 =
        "Come down and watch the big match with us this weekend down in Mar Mkhayel!";
    String eventA5 =
        "Lebanon will witness the sickest house party in decades welcome to Villa Saad, a party where everybody is welcome and there are opened drinks the whole night, free entry just come and enjoy";
    String eventB =
        "One of the most nostalgic pubs in MK, very chill and welcoming. Affordable prices with great quality!";

    int eventB_localCounter = 0;
    int eventB_counter = 0;

    List<String> attending = [eventA1, eventA2, eventA3, eventA4, eventA5];

    attending.forEach((eventA) {
      eventB_localCounter = 0;
      List<String> eventA_words = eventA.split(" ");
      List<String> eventB_words = eventB.split(" ");

      int twentyPercent = (eventA_words.length * 0.2).toInt();
      print("20% = " + twentyPercent.toString());

      eventB_words.forEach((wordB) {
        if (countSimilarOccurrences(eventA_words, wordB) == 1) {
          print(wordB);
          eventB_localCounter++;
        }
      });

      print("local = " + eventB_localCounter.toString());
      print("counter = " + eventB_counter.toString());

      if (eventB_localCounter >= twentyPercent) eventB_counter++;
    });

    if (eventB_counter >= 2) print("Add to for you");
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('users').doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: LiquidLinearProgressIndicator(
                  value: 0.25,
                  // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                  // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white,
                  // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.red,
                  borderWidth: 5.0,
                  borderRadius: 12.0,
                  direction: Axis.vertical,
                  // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text("Loading..."),
                ));
              } else {
                _namecontroller =
                    TextEditingController(text: snapshot.data["name"]);
                _numbercontroller =
                    TextEditingController(text: snapshot.data["number"]);
                _twittercontroller =
                    TextEditingController(text: snapshot.data["twitter"]);
                _instagramcontroller =
                    TextEditingController(text: snapshot.data["instagram"]);
                return snapshot.data == null
                    ? LiquidLinearProgressIndicator(
                        value: 0.25,
                        // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.pink),
                        // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white,
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.red,
                        borderWidth: 5.0,
                        borderRadius: 12.0,
                        direction: Axis.vertical,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                        center: Text("Loading..."),
                      )
                    : Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          title: Text(
                            "Account Information",
                          ),
                          backgroundColor: Colors.black,
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                avatar(
                                    letter: snapshot.data["name"][0]
                                        .toString()
                                        .toUpperCase(),
                                    existingPicture:
                                        snapshot.data['dp'].toString()),
                                newInput(
                                    hint: "Name",
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    defvalue: snapshot.data["name"],
                                    controller: _namecontroller,
                                    mask: maskTextInputFormatter2),
                                newInput(
                                    hint: "Number",
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    defvalue: snapshot.data["number"],
                                    controller: _numbercontroller,
                                    type: TextInputType.phone,
                                    mask: maskTextInputFormatter),
                                newInput(
                                    hint: "Twitter",
                                    icon: Icon(
                                      FontAwesomeIcons.twitter,
                                      color: Colors.white,
                                    ),
                                    defvalue: snapshot.data["twitter"],
                                    controller: _twittercontroller,
                                    mask: maskTextInputFormatter2),
                                newInput(
                                    hint: "Instagram",
                                    icon: Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.white,
                                    ),
                                    defvalue: snapshot.data["instagram"],
                                    controller: _instagramcontroller,
                                    mask: maskTextInputFormatter2),
                                button(uid: uid),
                              ],
                            ),
                          ),
                        ),
                      );
              }
            })
        : globals.spinner;
  }
}
