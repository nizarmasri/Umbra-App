import 'package:events/controllers/consumer/attend/attend_controller.dart';
import 'package:events/controllers/consumer/home/home_controller.dart';
import 'package:events/controllers/consumer/profile/settings_controller.dart';
import 'package:events/controllers/consumer/search/search_controller.dart';
import 'package:events/controllers/entry/login_signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/views/entry/entry_screen.dart';
import 'package:events/globals.dart' as globals;
import 'package:events/navigator.dart';
import 'package:events/libOrg/navigator.dart';
import 'package:events/views/entry/new_user_form.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationWrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      if (globals.isOrg) {
        return NavigatorOrgPage(uid: firebaseUser.uid);
      } else {
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return globals.spinner;
              }
              if (snapshot.data["new"]) {
                return NewUserForm(uid: firebaseUser.uid);
              } else {
                if (snapshot.data["organizer"]) {
                  return NavigatorOrgPage(uid: firebaseUser.uid);
                } else {
                  Get.put(HomeController());
                  Get.put(SearchController());
                  Get.put(AttendController());
                  Get.put(SettingsController());
                  return NavigatorPage(uid: firebaseUser.uid);
                }
              }
            });
      }
    }
    Get.put(LoginAndSignupController());
    return EntryScreen();
  }
}
