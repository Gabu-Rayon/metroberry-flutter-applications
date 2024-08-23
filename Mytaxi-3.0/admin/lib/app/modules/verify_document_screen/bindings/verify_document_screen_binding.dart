import 'package:get/get.dart';

import '../controllers/verify_document_screen_controller.dart';

class VerifyDocumentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDocumentScreenController>(
      () => VerifyDocumentScreenController(),
    );
  }
}
