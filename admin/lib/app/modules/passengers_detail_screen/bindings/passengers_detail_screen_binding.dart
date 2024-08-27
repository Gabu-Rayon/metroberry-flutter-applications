import 'package:get/get.dart';

import '../controllers/passengers_detail_screen_controller.dart';

class PassengersDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengersDetailScreenController>(
      () => PassengersDetailScreenController(),
    );
  }
}
