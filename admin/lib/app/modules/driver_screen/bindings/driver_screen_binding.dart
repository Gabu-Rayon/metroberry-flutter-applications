import 'package:get/get.dart';

import '../controllers/driver_screen_controller.dart';

class DriverScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverScreenController>(
      () => DriverScreenController(),
    );
  }
}
