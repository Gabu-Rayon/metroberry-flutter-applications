import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  var isPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  RxString password = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    Constant.getAdminData();
    Constant.getCurrencyData();
    Constant.getLanguageData();
    email.value = await AppSharedPreference.appSharedPreference.getEmail();
    password.value = await AppSharedPreference.appSharedPreference.getPassword();
    if (email.value.isEmpty) {
      final DocumentReference document = FirebaseFirestore.instance.collection(CollectionName.admin).doc("admin");
      document.snapshots().listen((snapshot) async {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          email.value = data["email"];
          password.value = data["password"];
        }
      });
    }
  }

  void checkLogin() async {
    if (email.value == emailController.text && password.value == passwordController.text) {
      await AppSharedPreference.appSharedPreference.saveIsUserLoggedIn();
      // Get.offNamed(Routes.HOME);
      Get.offAllNamed(Routes.DASHBOARD_SCREEN);
    } else {
      if (email.value != emailController.text) {
        ShowToast.errorToast("Please enter a valid email!".tr);
      }
      if (password.value != passwordController.text) {
        ShowToast.errorToast("Please enter a valid password!".tr);
      }
    }
  }
}
