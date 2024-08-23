import 'package:get/get.dart';

import '../controllers/payout_request_controller.dart';

class PayoutRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayoutRequestController>(
      () => PayoutRequestController(),
    );
  }
}
