import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditProfileController extends GetxController {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final double inputSize = 17;

  final loading = true.obs;
  final maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatter2 = MaskTextInputFormatter();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  RxList<Asset> images = <Asset>[].obs as RxList<Asset>;

  @override
  onReady() async {
    loading(true);
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  get fetchUser =>
      FirebaseFirestore.instance.collection('users').doc(uid).get();

  Future<void> pickImage() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } catch (e) {
      throw Exception(e);
    }

    //if (!mounted) return;

    images.value = resultList;
  }
}
