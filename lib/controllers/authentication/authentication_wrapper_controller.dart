import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationWrapperController extends GetxController {
  final loaded = false.obs;
  final BuildContext? context;
  var snapshot;
  AuthenticationWrapperController({this.context});

  @override
  onReady() async {
    try {
      final firebaseUser = context!.watch<User>();
      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();
    } catch (e) {
      throw Exception(e);
    } finally {
      loaded(true);
    }

    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }
}
