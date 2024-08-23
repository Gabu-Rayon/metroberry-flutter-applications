import 'dart:developer';

import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class AboutAppController extends GetxController {
  RxString title = "About App".tr.obs;
  RxString result = ''.obs;

  Rx<ConstantModel> constantModel = ConstantModel().obs;

  getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) async {
      if (value != null) {
        final document = parse(value.aboutApp!.toString());

        result.value = parse(document.body!.text).documentElement!.text;
        constantModel.value = value;
        log(result.value);
      }
    });
  }

  @override
  void onInit() {
    getSettingData();
    super.onInit();
  }
}
