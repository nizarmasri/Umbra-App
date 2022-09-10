import 'package:events/controllers/consumer/profile/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:events/globals.dart' as globals;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends GetView<EditProfileController> {
  @override
  Widget build(BuildContext context) {
    controller.loading(true);
    return Obx(() =>
    controller.loading.value
        ? FutureBuilder(
            future: controller.fetchUser,
            builder: (context2, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: globals.spinner);
              } else {
                QueryDocumentSnapshot data = snapshot.data as QueryDocumentSnapshot;
                controller.nameController.text = data["name"];
                controller.numberController.text = data["number"];
                controller.twitterController.text = data["twitter"];
                controller.instagramController.text = data["instagram"];
                return snapshot.data == null
                    ? globals.spinner
                    : Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          title: Text(
                            "Account Information",
                          ),
                          backgroundColor: Colors.black,
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: Obx(
                                        () => CircleAvatar(
                                          radius: 75,
                                          backgroundColor:
                                              Colors.brown.shade800,
                                          backgroundImage:
                                              controller.images.isNotEmpty
                                                  ? AssetThumbImageProvider(
                                                      controller.images[0],
                                                      width: 200,
                                                      height: 200,
                                                      quality: 100,
                                                    )
                                                  : data['dp']
                                                              .toString() !=
                                                          ''
                                                      ? NetworkImage(data['dp']
                                                          .toString())
                                                      : '' as ImageProvider<Object>?,
                                          child: Text(
                                            controller.images.isEmpty &&
                                                    data['dp']
                                                            .toString() ==
                                                        ''
                                                ? data["name"][0]
                                                    .toString()
                                                    .toUpperCase()
                                                : "",
                                            style: TextStyle(fontSize: 80),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Center(
                                          child: IconButton(
                                        onPressed: () {
                                          controller.pickImage();
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                                customTextField(
                                    hint: "Name",
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    textController: controller.nameController,
                                    mask: controller.maskTextInputFormatter2),
                                customTextField(
                                    hint: "Number",
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    textController: controller.numberController,
                                    type: TextInputType.phone,
                                    mask: controller.maskTextInputFormatter),
                                customTextField(
                                    hint: "Twitter",
                                    icon: Icon(
                                      FontAwesomeIcons.twitter,
                                      color: Colors.white,
                                    ),
                                    textController:
                                        controller.twitterController,
                                    mask: controller.maskTextInputFormatter2),
                                customTextField(
                                    hint: "Instagram",
                                    icon: Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.white,
                                    ),
                                    textController:
                                        controller.instagramController,
                                    mask: controller.maskTextInputFormatter2),
                                submitButton(
                                    context: context, uid: controller.uid),
                              ],
                            ),
                          ),
                        ),
                      );
              }
            })
        : globals.spinner);
  }

  Container customTextField(
      {String? hint,
      Icon? icon,
      TextEditingController? textController,
      required MaskTextInputFormatter mask,
      TextInputType? type}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 15),
      child: Center(
        child: ListTile(
          leading: icon,
          title: TextField(
            inputFormatters: [
              mask,
            ],
            keyboardType: type,
            controller: textController,
            style: TextStyle(
                color: Colors.white,
                fontSize: controller.inputSize,
                fontFamily: globals.montserrat,
                fontWeight: globals.fontWeight),
            decoration: InputDecoration(
                hintText: hint,
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
    );
  }

  Container submitButton({BuildContext? context, String? uid}) {
    return Container(
      child: InkWell(
        focusColor: Colors.white,
        onTap: () async {
          controller.loading(false);
          if (controller.images.isNotEmpty) {
            final firebaseStorageRef =
                FirebaseStorage.instance.ref().child('profilepictures/$uid');
            await firebaseStorageRef
                .putData((await controller.images[0].getByteData(quality: 50))
                    .buffer
                    .asUint8List())
                .then((value) async {
              final url = await firebaseStorageRef.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'name': controller.nameController.text,
                'number': controller.numberController.text,
                'twitter': controller.twitterController.text,
                'instagram': controller.instagramController.text,
                'dp': url,
              }).then((value) {
                Navigator.pop(context!);
              });
            });
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
              'name': controller.nameController.text,
              'number': controller.numberController.text,
              'twitter': controller.twitterController.text,
              'instagram': controller.instagramController.text
            }).then((value) {
              Navigator.pop(context!);
            });
          }
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
}
