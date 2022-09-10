import 'package:events/controllers/entry/new_user_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewUserForm extends GetView<NewUserFormController> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: globals.background,
                  fit: BoxFit.fill,
                )),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.black87, Colors.black87])),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin:
                          EdgeInsets.only(bottom: height * 0, top: height * 0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "u",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 110,
                                  color: Colors.white24)),
                          TextSpan(
                              text: "mbra",
                              style: TextStyle(
                                  fontFamily: globals.montserrat,
                                  fontWeight: globals.fontWeight,
                                  fontSize: 30,
                                  color: Colors.white70))
                        ]),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name text field
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                              title: TextField(
                                onChanged: (text) {
                                  controller.name.value = text;
                                },
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: controller.inputSize,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        color: Colors.white38,
                                        fontSize: controller.inputSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                    border: InputBorder.none,
                                    focusColor: Colors.black,
                                    fillColor: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        // Birthday field
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                            child: GestureDetector(
                              onTap: () => controller.selectDate(context),
                              child: ListTile(
                                leading: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                title: TextField(
                                  enabled: false,
                                  controller: controller.birthdayController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: controller.inputSize,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  decoration: InputDecoration(
                                      hintText: "Birthday",
                                      hintStyle: TextStyle(
                                          color: Colors.white38,
                                          fontSize: controller.inputSize,
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight),
                                      border: InputBorder.none,
                                      focusColor: Colors.black,
                                      fillColor: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(controller.birthdayErrorMessage.value,
                              style: TextStyle(
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Center(
                              child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: Get.width * 0.06),
                                child: Text(
                                  "Gender : ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: controller.inputSize,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Get.width * 0.04),
                                child: DropdownButtonHideUnderline(
                                  child: Obx(
                                    () => DropdownButton<String>(
                                      value: controller.gender.value,
                                      dropdownColor: Colors.grey[900],
                                      onChanged: (newValue) {
                                        controller.gender.value = newValue!;
                                      },
                                      icon: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white54,
                                      ),
                                      iconSize: 15,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: controller.inputSize,
                                          fontFamily: globals.montserrat,
                                          fontWeight: globals.fontWeight),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      items: <String>[
                                        'Your gender...',
                                        'Male',
                                        'Female',
                                        'Other'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                        ),
                      ])),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: Get.height * 0.07,
                              width: Get.width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: Center(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  title: TextField(
                                    onChanged: (newValue) {
                                      controller.phoneNumber.value = newValue;
                                    },
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      controller.maskTextInputFormatter,
                                    ],
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: controller.inputSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                    decoration: InputDecoration(
                                        hintText: "Phone Number",
                                        hintStyle: TextStyle(
                                            color: Colors.white38,
                                            fontSize: controller.inputSize,
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
                      ),
                      Obx(
                        () => Text(
                          controller.phoneNumberErrorMessage.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                        ),
                        child: TextButton(
                          onPressed: () {
                            return controller.onPressed;
                          },
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: controller.inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
