import 'package:get/get.dart';

import '../controllers/admin_profile_controller.dart';

class AdminProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProfileController>(
      () => AdminProfileController(),
    );
  }
}
