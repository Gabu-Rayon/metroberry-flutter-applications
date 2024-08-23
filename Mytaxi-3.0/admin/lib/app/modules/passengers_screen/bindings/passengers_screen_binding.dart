import 'package:get/get.dart';

import '../controllers/passengers_screen_controller.dart';

class PassengersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengersScreenController>(
      () => PassengersScreenController(),
    );
  }
}
