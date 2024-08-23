import 'package:get/get.dart';

import '../controllers/vehicle_brand_screen_controller.dart';

class VehicleBrandScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleBrandScreenController>(
      () => VehicleBrandScreenController(),
    );
  }
}
