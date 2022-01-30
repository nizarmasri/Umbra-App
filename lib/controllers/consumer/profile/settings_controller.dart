import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/profile/bookmarks_controller.dart';
import 'package:events/controllers/consumer/profile/edit_profile_controller.dart';
import 'package:events/views/consumer/profile/edit_profile.dart';
import 'package:events/views/consumer/profile/profile.dart';
import 'package:events/views/consumer/profile/bookmarks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  Rx get fetchUser =>
      (FirebaseFirestore.instance.collection('users').doc(uid).snapshots()).obs;

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchEvents() async {
    return (FirebaseFirestore.instance.collection('users').doc(uid).get());
  }

  navigateToBookmark(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Get.put(BookmarksController());
      return Bookmarks();
    }));
  }

  navigateToEditProfilePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Get.put(EditProfileController());
      return EditProfilePage();
    }));
  }

  navigateToProfilePage(BuildContext context, AsyncSnapshot snapshot) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  snapshot: snapshot,
                )));
  }
}
