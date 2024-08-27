import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/review_customer_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/utils/fire_store_utils.dart';

class ReviewScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble rating = 0.0.obs;
  Rx<TextEditingController> commentController = TextEditingController().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel = argumentData['bookingModel'];
    }
    log("----->1");
    await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString()).then((value) {
      if (value != null) {
        log("----->2");
        driverModel.value = value;
      }
    });
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        log("----->3");
        userModel.value = value;
      }
    });
    await FireStoreUtils.getReview(bookingModel.value.id.toString()).then((value) {
      if (value != null) {
        log("----->4");
        reviewModel.value = value;
        rating.value = double.parse(reviewModel.value.rating.toString());
        commentController.value.text = reviewModel.value.comment.toString();
      }
    });
    isLoading.value = false;
    update();
  }
}
