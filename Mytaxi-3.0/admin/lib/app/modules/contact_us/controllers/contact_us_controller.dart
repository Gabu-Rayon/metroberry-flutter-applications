import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/contact_us_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';

class ContactUsController extends GetxController {
  RxString title = "Contact Us".tr.obs;

  Rx<TextEditingController> emailSubjectController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  Rx<ContactUsModel> contactUsModel = ContactUsModel().obs;

  setContactData() {
    if (emailSubjectController.value.text.isEmpty || emailController.value.text.isEmpty || phoneNumberController.value.text.isEmpty || addressController.value.text.isEmpty) {
      ShowToast.errorToast("Please fill all data".tr);
    } else {
      Constant.waitingLoader();
      contactUsModel.value.emailSubject = emailSubjectController.value.text;
      contactUsModel.value.email = emailController.value.text;
      contactUsModel.value.phoneNumber = phoneNumberController.value.text;
      contactUsModel.value.address = addressController.value.text;

      FireStoreUtils.setContactusSetting(contactUsModel.value).then((value) {
        Get.back();
        ShowToast.successToast("Contact data updated".tr);
      });
    }
  }

  getContactData() {
    FireStoreUtils.getContactusSetting().then((value) {
      if (value != null) {
        contactUsModel.value = value;
        emailSubjectController.value.text = contactUsModel.value.emailSubject!;
        emailController.value.text = contactUsModel.value.email!;
        phoneNumberController.value.text = contactUsModel.value.phoneNumber!;
        addressController.value.text = contactUsModel.value.address!;
      }
    });
  }

  @override
  void onInit() {
    getContactData();
    super.onInit();
  }
}
