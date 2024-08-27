import 'package:get/get.dart';

import '../controllers/coupon_screen_controller.dart';

class CouponScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CouponScreenController>(
      () => CouponScreenController(),
    );
  }
}
