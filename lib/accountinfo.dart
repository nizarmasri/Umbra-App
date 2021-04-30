import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'globals.dart' as globals;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
            final upload = await firebaseStorageRef
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

  @override
  Widget build(BuildContext context) {
    return !loading
        ? FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('users').doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              _namecontroller =
                  TextEditingController(text: snapshot.data.data()["name"]);
              _numbercontroller =
                  TextEditingController(text: snapshot.data.data()["number"]);
              _twittercontroller =
                  TextEditingController(text: snapshot.data.data()["twitter"]);
              _instagramcontroller = TextEditingController(
                  text: snapshot.data.data()["instagram"]);
              return Scaffold(
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
                            letter: snapshot.data
                                .data()["name"][0]
                                .toString()
                                .toUpperCase(),
                            existingPicture:
                                snapshot.data.data()['dp'].toString()),
                        newInput(
                            hint: "Name",
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            defvalue: snapshot.data.data()["name"],
                            controller: _namecontroller,
                            mask: maskTextInputFormatter2),
                        newInput(
                            hint: "Number",
                            icon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            defvalue: snapshot.data.data()["number"],
                            controller: _numbercontroller,
                            type: TextInputType.phone,
                            mask: maskTextInputFormatter),
                        newInput(
                            hint: "Twitter",
                            icon: Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.white,
                            ),
                            defvalue: snapshot.data.data()["twitter"],
                            controller: _twittercontroller,
                            mask: maskTextInputFormatter2),
                        newInput(
                            hint: "Instagram",
                            icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                            ),
                            defvalue: snapshot.data.data()["instagram"],
                            controller: _instagramcontroller,
                            mask: maskTextInputFormatter2),
                        button(uid: uid),
                      ],
                    ),
                  ),
                ),
              );
            })
        : globals.spinner;
  }
}
