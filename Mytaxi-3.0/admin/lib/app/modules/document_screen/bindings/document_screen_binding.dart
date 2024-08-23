import 'package:get/get.dart';

import '../controllers/document_screen_controller.dart';

class DocumentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentScreenController>(
      () => DocumentScreenController(),
    );
  }
}
