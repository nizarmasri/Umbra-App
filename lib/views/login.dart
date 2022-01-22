import 'package:events/controllers/consumer/login_controller.dart';
import 'package:events/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loader.value
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.black,
              ),
              body: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: globals.background,
                      fit: BoxFit.fill,
                    )),
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            margin: EdgeInsets.only(bottom: Get.height * 0.1),
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
                                        color: Colors.white70)),
                              ]),
                            ),
                          ),
                          // email field
                          Container(
                            height: controller.btnHeight,
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: ListTile(
                                leading: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                                title: TextField(
                                  controller: controller.emailController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: controller.inputSize,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  decoration: InputDecoration(
                                      hintText: "Email",
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
                          // password field
                          Container(
                            height: controller.btnHeight,
                            width: Get.width * 0.9,
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: ListTile(
                                leading: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                title: TextField(
                                  controller: controller.passwordController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: controller.inputSize,
                                      fontFamily: globals.montserrat,
                                      fontWeight: globals.fontWeight),
                                  decoration: InputDecoration(
                                      hintText: "Password",
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
                          // login button
                          Container(
                              height: controller.btnHeight,
                              width: Get.width * 0.9,
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white12),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ProgressButton(
                                stateWidgets: {
                                  ButtonState.idle: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: controller.loginSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                  ),
                                  ButtonState.loading: Text(
                                    "loading...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: controller.loginSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                  ),
                                  ButtonState.success: Text(
                                    "Logged in",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: controller.loginSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                  ),
                                  ButtonState.fail: Text(
                                    "failed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: controller.loginSize,
                                        fontFamily: globals.montserrat,
                                        fontWeight: globals.fontWeight),
                                  ),
                                },
                                stateColors: {
                                  ButtonState.idle: Colors.black,
                                  ButtonState.loading: Colors.white12,
                                  ButtonState.success: Colors.green,
                                  ButtonState.fail: Colors.red,
                                },
                                onPressed: () => controller.login(context),
                              )),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                controller.msg.value,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontFamily: globals.montserrat,
                                    fontWeight: globals.fontWeight),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
        : globals.spinner);
  }
}
