import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'services/shared_preferences/app_preference.dart';

class GlobalController extends GetxController {
  RxBool isLoading = true.obs;
  @override
  Future<void> onInit() async {
    await getData();
    Constant.getLanguageData();
    super.onInit();
  }

  getData() async {
    isLoading.value = false;
    bool isLogin = await AppSharedPreference.appSharedPreference.getIsUserLoggedIn();
    if (Get.currentRoute != Routes.ERROR_SCREEN) {
      if (!isLogin) {
        Get.offAllNamed(Routes.LOGIN_PAGE);
      } else {
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      }
    }
  }
}
