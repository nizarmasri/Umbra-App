import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:events/globals.dart' as globals;

import 'package:events/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginController extends GetxController {
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

  final double schedulerSize = 32;
  final double inputSize = 17;
  final double loginSize = 17;
  final double googleSize = 15;
  final double btnHeight = 60;

  var msg = "".obs;

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
}
