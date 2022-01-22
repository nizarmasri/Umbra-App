import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:events/globals.dart' as globals;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountInfoOrg extends StatefulWidget {
  @override
  _AccountInfoOrgState createState() => _AccountInfoOrgState();
}

class _AccountInfoOrgState extends State<AccountInfoOrg> {
  @override
  void initState() {
    super.initState();
  }

  double inputSize = 17;

  bool loading = false;
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatter2 = MaskTextInputFormatter();
  TextEditingController _namecontroller;
  TextEditingController _numbercontroller;
  TextEditingController _twittercontroller;
  TextEditingController _instagramcontroller;

  String uid = FirebaseAuth.instance.currentUser.uid;

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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
          width: 200,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white10),
          child: Center(
            child: Text("Save",
                style: TextStyle(
                    fontFamily: globals.montserrat, color: Colors.white)),
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
                  new TextEditingController(text: snapshot.data["name"]);
              _numbercontroller = new TextEditingController(
                  text: snapshot.data["number"]);
              _twittercontroller = new TextEditingController(
                  text: snapshot.data["twitter"]);
              _instagramcontroller = new TextEditingController(
                  text: snapshot.data["instagram"]);
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  title: Text(
                    "Account Information",
                    style: TextStyle(fontFamily: globals.montserrat),
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
                          controller: _namecontroller,
                          mask: maskTextInputFormatter2,
                        ),
                        newInput(
                          hint: "Number",
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          controller: _numbercontroller,
                          type: TextInputType.phone,
                          mask: maskTextInputFormatter,
                        ),
                        newInput(
                            hint: "Twitter",
                            icon: Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.white,
                            ),
                            controller: _twittercontroller,
                            mask: maskTextInputFormatter2),
                        newInput(
                          hint: "Instagram",
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                          ),
                          controller: _instagramcontroller,
                          mask: maskTextInputFormatter2,
                        ),
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
