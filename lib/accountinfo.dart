import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
  }

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _namecontroller;
  TextEditingController _numbercontroller;

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
      IconData icon,
      String defvalue,
      TextEditingController controller,
      MaskTextInputFormatter number,
      TextInputType type}) {
    controller = new TextEditingController(text: defvalue);
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: TextField(
          inputFormatters: [
            number,
          ],
          keyboardType: type,
          controller: controller,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
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

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Account Information",
              ),
              backgroundColor: Colors.black,
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              // decoration: BoxDecoration(color: Colors.green),
              child: Column(
                children: [
                  avatar(
                      letter: snapshot.data
                          .data()["name"][0]
                          .toString()
                          .toUpperCase()),
                  newInput(
                      hint: "Name",
                      icon: Icons.person,
                      defvalue: snapshot.data.data()["name"],
                      controller: _namecontroller),
                  newInput(
                      hint: "Number",
                      icon: Icons.phone,
                      defvalue: snapshot.data.data()["number"],
                      controller: _numbercontroller,
                      type: TextInputType.phone,
                      number: maskTextInputFormatter),
                  Container(
                    child: InkWell(
                      focusColor: Colors.white,
                      onTap: () {
                        print("Submit");
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Center(
                          child: Text("SUBMIT",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
