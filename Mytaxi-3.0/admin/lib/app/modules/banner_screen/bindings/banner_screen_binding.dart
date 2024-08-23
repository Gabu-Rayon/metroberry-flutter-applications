import 'package:get/get.dart';

import '../controllers/banner_screen_controller.dart';

class BannerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannerScreenController>(
      () => BannerScreenController(),
    );
  }
}
