import 'package:get/get.dart';

import '../controllers/booking_detail_controller.dart';

class BookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailController>(
      () => BookingDetailController(),
    );
  }
}
