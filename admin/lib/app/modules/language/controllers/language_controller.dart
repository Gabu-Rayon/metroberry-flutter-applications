import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

class LanguageController extends GetxController {
  RxString title = "Language".tr.obs;
  Rx<LanguageModel> languageModel = LanguageModel().obs;
  Rx<TextEditingController> languageController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  DashboardScreenController dashboardScreenController = Get.put(DashboardScreenController());

  @override
  Future<void> onInit() async {
    await getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    languageList.clear();
    List<LanguageModel> data = await FireStoreUtils.getLanguage();
    languageList.addAll(data);

    isLoading(false);
  }

  setDefaultData() {
    languageController.value.text = "";
    codeController.value.text = "";
    isActive.value = false;
    isEditing.value = false;
  }

  updateLanguage() async {
    // languageModel.value.id = Constant.getRandomString(20);
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    await FireStoreUtils.updateLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await getData();
  }

  addLanguage() async {
    isLoading = true.obs;
    languageModel.value.id = Constant.getRandomString(20);
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    await FireStoreUtils.addLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await getData();
    isLoading = false.obs;
  }

  removeLanguage(LanguageModel languageModel) async {
    isLoading = true.obs;

    await FirebaseFirestore.instance.collection(CollectionName.languages).doc(languageModel.id).delete().then((value) {
      ShowToastDialog.toast("Language deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await dashboardScreenController.getLanguage();
    isLoading = false.obs;
  }
}
