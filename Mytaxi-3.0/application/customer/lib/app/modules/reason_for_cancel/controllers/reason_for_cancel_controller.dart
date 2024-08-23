// ignore_for_file: unnecessary_overrides

import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ReasonForCancelController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
    }
  }

  RxInt selectedIndex = 0.obs;

  List<dynamic> reasons = Constant.cancellationReason;

  Future<bool> cancelBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCancelled;
    bookingModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bool? isCancelled = await FireStoreUtils.setBooking(bookingModel);
    return (isCancelled ?? false);
  }

  sendCancelRideNotification() async {
    DriverUserModel? receiverUserModel = await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.value.id};
    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Ride Cancelled'.tr,
        body: 'Ride #${bookingModel.value.id.toString().substring(0, 4)} is cancelled by Customer',
        bookingId: bookingModel.value.id,
        driverId: bookingModel.value.driverId.toString(),
        senderId: FireStoreUtils.getCurrentUid(),
        payload: playLoad);
  }
}
