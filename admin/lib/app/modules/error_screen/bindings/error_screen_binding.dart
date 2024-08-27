import 'package:get/get.dart';

import '../controllers/error_screen_controller.dart';

class ErrorScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ErrorScreenController>(
      () => ErrorScreenController(),
    );
  }
}
