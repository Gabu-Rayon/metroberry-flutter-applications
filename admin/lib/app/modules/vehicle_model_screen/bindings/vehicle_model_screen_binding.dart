import 'package:get/get.dart';

import '../controllers/vehicle_model_screen_controller.dart';

class VehicleModelScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleModelScreenController>(
      () => VehicleModelScreenController(),
    );
  }
}
