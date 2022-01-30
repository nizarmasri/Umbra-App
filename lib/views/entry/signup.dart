import 'package:events/controllers/entry/login_signup_controller.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';

class SignUpPage extends GetView<LoginAndSignupController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                                  color: Colors.white70))
                        ]),
                      ),
                    ),
                    // Email
                    Container(
                      height: controller.btnHeight,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white12,
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
                    // Password
                    Container(
                      height: controller.btnHeight,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          title: TextField(
                            controller: controller.passwordController,
                            cursorColor: Colors.white,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
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
                    // Confirm Password
                    Container(
                      height: controller.btnHeight,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          title: TextField(
                            controller: controller.confirmPasswordController,
                            cursorColor: Colors.white,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: controller.inputSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                            decoration: InputDecoration(
                                hintText: "Confirm password",
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
                    // Sign up
                    Container(
                        height: controller.btnHeight,
                        width: Get.width * 0.9,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: ProgressButton(stateWidgets: {
                          ButtonState.idle: Text(
                            "Sign Up",
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
                            "Signed in",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: controller.loginSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                          ButtonState.fail: Text(
                            "Failed",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: controller.loginSize,
                                fontFamily: globals.montserrat,
                                fontWeight: globals.fontWeight),
                          ),
                        }, stateColors: {
                          ButtonState.idle: Colors.black,
                          ButtonState.loading: Colors.white12,
                          ButtonState.success: Colors.green,
                          ButtonState.fail: Colors.red,
                        }, onPressed: () => controller.signup(context))),
                    // Email error message
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
                    // Password error message
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          controller.msgPassword.value,
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
      ),
    );
  }
}
