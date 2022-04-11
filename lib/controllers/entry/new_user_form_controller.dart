import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewUserFormController extends GetxController {
  final String uid;

  NewUserFormController({this.uid});

  var birthdayErrorMessage = ''.obs;
  var phoneNumberErrorMessage = ''.obs;

  var name = ''.obs;
  var gender = 'Male'.obs;
  var phoneNumber = ''.obs;
  final maskTextInputFormatter = MaskTextInputFormatter(
      mask: "## ### ###", filter: {"#": RegExp(r'[0-9]')});
  final inputSize = 18.0;
  TextEditingController birthdayController = TextEditingController();

  var selectedDate = DateTime.now().obs;
  var changed = false.obs;

  @override
  onReady() async {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate.value)
      selectedDate.value = picked;
    birthdayController.text = selectedDate.toString().substring(0, 10);
    changed.value = true;
  }

  get onPressed async {
    if (name.isEmpty || !changed.value || phoneNumber.isEmpty || gender.value != 'Your gender...') {
      phoneNumberErrorMessage.value =
          "Please fill in the required information.";
      return;
    }
    if (phoneNumber.value.length < 8) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'gender': gender.value,
      'name': name.value.trim(),
      'birthday': selectedDate.value,
      'number': phoneNumber.value,
      'new': false,
      'dp': '',
      'instagram': '',
      'twitter': '',
      'attending': [],
      'booked': []
    });
  }
}
