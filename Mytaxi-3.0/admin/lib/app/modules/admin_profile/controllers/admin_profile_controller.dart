// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';
import 'dart:io';

import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/modules/home/controllers/home_controller.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> profileFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFromKey = GlobalKey<FormState>();

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> contactNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  RxInt selectedTabIndex = 0.obs;

  HomeController homeController = Get.put(HomeController());
  RxString selectedTab = "profile".tr.obs;

  Rx<File> imagePath = File('').obs;

  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;

  RxBool uploading = false.obs;
  RxString title = "Change Password".tr.obs;
  RxString profileTitle = "Profile".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() {
    FireStoreUtils.getAdmin().then((value) {
      if (value != null) {
        nameController.value.text = value.name!;
        contactNumberController.value.text = value.contactNumber!;
        emailController.value.text = value.email!;
        imageController.value.text = value.image!;
      }
    });
  }

  pickPhoto() async {
    uploading.value = true;
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    File imageFile = File(img!.path);

    imageController.value.text = img.name;
    imagePath.value = imageFile;
    imagePickedFileBytes.value = await img.readAsBytes();
    mimeType.value = "${img.mimeType}";
    uploading.value = false;
  }

  setAdminData() async {
    Constant.waitingLoader();
    if (imagePath.value.path.isNotEmpty) {
      String? downloadUrl = await FireStoreUtils.uploadPic(PickedFile(imagePath.value.path), "admin", "admin", mimeType.value);
      Constant.adminModel!.image = downloadUrl;
      log(downloadUrl.toString());
    }
    Constant.adminModel!.email = emailController.value.text;
    Constant.adminModel!.name = nameController.value.text;
    Constant.adminModel!.contactNumber = contactNumberController.value.text;

    await FireStoreUtils.setAdmin(Constant.adminModel!).then((value) async {
      await FireStoreUtils.getAdmin();
      // await homeController.getAdminData();
      Get.back();
      ShowToast.successToast("Profile updated successfully".tr);
    }).catchError((e) => log("-->$e"));
  }

  setAdminPassword() async {
    if (oldPasswordController.value.text != Constant.adminModel!.password) {
      ShowToast.errorToast("Old password is not correct".tr);
    } else {
      if (newPasswordController.value.text != confirmPasswordController.value.text) {
        ShowToast.errorToast("Confirmation password does not match".tr);
      } else {
        Constant.waitingLoader();
        Constant.adminModel!.password = confirmPasswordController.value.text;
        await FireStoreUtils.setAdmin(Constant.adminModel!).then((value) async {
          await FireStoreUtils.getAdmin();
          Get.back();
          ShowToast.successToast("Password updated successfully".tr);
        });
      }
    }
  }
}
