import 'package:get/get.dart';

import '../controllers/driver_detail_screen_controller.dart';

class DriverDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDetailScreenController>(
      () => DriverDetailScreenController(),
    );
  }
}
