import 'package:events/libOrg/signup.dart';
import 'package:events/views/entry/login.dart';
import 'package:events/views/entry/signup.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

import 'package:events/views/authentication/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginAndSignupController extends GetxController {
  @override
  onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final double inputSize = 17;
  final double loginSize = 17;
  final double googleSize = 15;
  final double btnHeight = 60;

  var msg = "".obs;
  var msgPassword = "".obs;

  final signUpStyle1 = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300);
  final signUpStyle2 = TextStyle(
      color: Colors.red,
      fontSize: 15,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300);
  var loader = true.obs;

  login(BuildContext context) {
    loader.value = false;
    Future<List<String>> temp = context.read<AuthenticationService>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    temp.then((List<String> result) {
      msg.value = result[1];

      if (result[0] == "Signed in") {
        msg.value = " ";
        globals.isOrg = false;
        Navigator.pop(context);
      }
      if (result[0] == "Invalid email") {
        loader.value = true;
      }
    });
  }

  signup(BuildContext context) {
    if (passwordController.text != confirmPasswordController.text)
      msgPassword.value = "Passwords don't match";
    else {
      Future<String> temp = context.read<AuthenticationService>().signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          organizer: false);

      temp.then((String result) {
        if (result == "Invalid email")
          msg.value = result;
        else
          Navigator.pop(context);
      });
    }
  }


  navigateToSignUpPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  navigateToSignInPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  navigateToOrgSignupPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpOrgPage()));
  }
}
