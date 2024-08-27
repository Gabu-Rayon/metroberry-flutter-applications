import 'package:get/get.dart';

import '../controllers/my_ride_details_controller.dart';

class MyRideDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRideDetailsController>(
      () => MyRideDetailsController(),
    );
  }
}
