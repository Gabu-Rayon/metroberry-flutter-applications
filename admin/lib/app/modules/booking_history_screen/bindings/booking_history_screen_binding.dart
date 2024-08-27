import 'package:get/get.dart';

import '../controllers/booking_history_screen_controller.dart';

class BookingHistoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingHistoryScreenController>(
      () => BookingHistoryScreenController(),
    );
  }
}
