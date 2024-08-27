// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:get/get.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/intro_screen/views/intro_screen_view.dart';
import 'package:customer/app/modules/login/views/login_view.dart';
import 'package:customer/app/modules/permission/views/permission_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  redirectScreen() async {
    if ((await Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) == false) {
      Get.offAll(const IntroScreenView());
    } else {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        bool permissionGiven = await Constant.isPermissionApplied();
        if(permissionGiven){
          Get.offAll(const HomeView());
        }else{
          Get.offAll(const PermissionView());
        }
      } else {
        Get.offAll(const LoginView());
      }
    }
  }
}
