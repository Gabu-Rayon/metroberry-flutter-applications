import 'package:get/get.dart';

import '../controllers/canceling_reason_controller.dart';

class CancelingReasonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancelingReasonController>(
      () => CancelingReasonController(),
    );
  }
}
