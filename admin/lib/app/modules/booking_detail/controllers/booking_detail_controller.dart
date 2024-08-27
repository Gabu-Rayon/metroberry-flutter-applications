import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class BookingDetailController extends GetxController {
  RxString title = "Booking Detail".tr.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  // BitmapDescriptor? pickUpIcon;
  // BitmapDescriptor? dropIcon;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
    } else {
      Get.offAllNamed(Routes.ERROR_SCREEN);
      // ShowToast.errorToast("");
    }

    await FireStoreUtils.getDriverByDriverID(bookingModel.value.driverId.toString()).then((value) {
      driverModel.value = value!;
    });
    await FireStoreUtils.getCustomerByCustomerID(bookingModel.value.customerId.toString()).then((value) {
      userModel.value = value!;
    });

    isLoading.value = false;
  }
}
