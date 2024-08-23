import 'package:get/get.dart';

import '../controllers/currency_controller.dart';

class CurrencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrencyController>(
      () => CurrencyController(),
    );
  }
}
