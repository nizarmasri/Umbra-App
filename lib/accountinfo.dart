import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'globals.dart' as globals;

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
  }

  bool loading = false;
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatter2 = MaskTextInputFormatter();
  TextEditingController _namecontroller;
  TextEditingController _numbercontroller;
  TextEditingController _twittercontroller;
  TextEditingController _instagramcontroller;

  Container avatar({String letter}) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Center(
        child: CircleAvatar(
          radius: 75,
          backgroundColor: Colors.brown.shade800,
          child: Text(
            letter,
            style: TextStyle(fontSize: 80),
          ),
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
      TextInputType type}) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: TextField(
          inputFormatters: [
            mask,
          ],
          keyboardType: type,
          controller: controller,
          decoration: new InputDecoration(
            prefixIcon: icon,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            labelText: hint,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 3.0),
                borderRadius: BorderRadius.circular(10.0)),
          ),
          style:
              new TextStyle(fontSize: 15.0, height: 1.2, color: Colors.white)),
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
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'name': _namecontroller.text,
            'number': _numbercontroller.text,
            'twitter': _twittercontroller.text,
            'instagram': _instagramcontroller.text
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

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
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
                                .toUpperCase()),
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
                            controller: _twittercontroller),
                        newInput(
                            hint: "Instagram",
                            icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                            ),
                            defvalue: snapshot.data.data()["instagram"],
                            controller: _instagramcontroller),
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
