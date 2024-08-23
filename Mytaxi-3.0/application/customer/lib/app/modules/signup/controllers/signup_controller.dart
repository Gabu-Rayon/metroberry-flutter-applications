import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController countryCodeController = TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxInt selectedGender = 1.obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();

    super.onInit();
  }

  @override
  void onClose() {}
  Rx<UserModel> userModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.text = userModel.value.phoneNumber.toString();
        countryCodeController.text = userModel.value.countryCode.toString();
      } else {
        emailController.text = userModel.value.email.toString();
        nameController.text = userModel.value.fullName.toString();
      }
    }
    update();
  }

  createAccount() async {
    String fcmToken = await NotificationService.getToken();
    ShowToastDialog.showLoader("Please wait".tr);
    UserModel userModelData = userModel.value;
    userModelData.fullName = nameController.value.text;
    userModelData.slug = nameController.value.text.toSlug(delimiter: "-");
    userModelData.email = emailController.value.text;
    userModelData.countryCode = countryCodeController.value.text;
    userModelData.phoneNumber = phoneNumberController.value.text;
    userModelData.gender = selectedGender.value == 1 ? "Male" : "Female";
    userModelData.profilePic = '';
    userModelData.fcmToken = fcmToken;
    userModelData.createdAt = Timestamp.now();
    userModelData.isActive = true;

    await FireStoreUtils.updateUser(userModelData).then((value) {
      ShowToastDialog.closeLoader();
      if (value == true) {
        Get.offAll(const HomeView());
      }
    });
  }
}
