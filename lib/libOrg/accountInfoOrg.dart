import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../globals.dart' as globals;

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.9;
    double titleFieldHeight = height * 0.1;

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
                            letter: snapshot.data
                                .data()["name"][0]
                                .toString()
                                .toUpperCase()),
                        Container(
                          height: titleFieldHeight,
                          width: textFieldWidth,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              title: TextField(
                                controller: _namecontroller,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: inputSize,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                decoration: InputDecoration(
                                    hintText: "Full Name",
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
                          height: titleFieldHeight,
                          width: textFieldWidth,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              title: TextField(
                                inputFormatters: [
                                  maskTextInputFormatter,
                                ],
                                controller: _numbercontroller,
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
                        /*
                        newInput(
                            hint: "Name",
                            icon: Icons.person,
                            defvalue: snapshot.data.data()["name"],
                            controller: _namecontroller,
                            mask: maskTextInputFormatter2),
                        newInput(
                            hint: "Number",
                            icon: Icons.phone,
                            defvalue: snapshot.data.data()["number"],
                            controller: _numbercontroller,
                            type: TextInputType.phone,
                            mask: maskTextInputFormatter),
                            */

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
