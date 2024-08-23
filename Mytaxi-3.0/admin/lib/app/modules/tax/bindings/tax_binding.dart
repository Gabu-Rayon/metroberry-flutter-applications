import 'package:get/get.dart';

import '../controllers/tax_controller.dart';

class TaxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaxController>(
      () => TaxController(),
    );
  }
}
