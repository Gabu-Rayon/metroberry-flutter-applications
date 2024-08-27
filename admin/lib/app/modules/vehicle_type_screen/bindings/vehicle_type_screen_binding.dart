import 'package:get/get.dart';

import '../controllers/vehicle_type_screen_controller.dart';

class VehicleTypeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleTypeScreenController>(
      () => VehicleTypeScreenController(),
    );
  }
}
