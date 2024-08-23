import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/review_screen_controller.dart';

class ReviewScreenView extends GetView<ReviewScreenController> {
  const ReviewScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<ReviewScreenController>(
        init: ReviewScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Rate Us".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                imageUrl: controller.driverModel.value.profilePic == null || controller.driverModel.value.profilePic == ""
                                    ? Constant.profileConstant
                                    : controller.driverModel.value.profilePic.toString(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              controller.driverModel.value.fullName.toString(),
                              style: GoogleFonts.inter(
                                color: AppThemData.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/icon/ic_id.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  controller.driverModel.value.driverVehicleDetails!.vehicleNumber.toString(),
                                  style: GoogleFonts.inter(
                                    color: AppThemData.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rate Your Experience".tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Help us improve by sharing your feedback! Your input helps us improve our service for all passengers.".tr,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                                        child: RatingBar.builder(
                                          glow: true,
                                          initialRating: controller.rating.value,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 32,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: AppThemData.primary500,
                                          ),
                                          onRatingUpdate: (rating) {
                                            controller.rating(rating);
                                          },
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => TextFormField(
                                        controller: controller.commentController.value,
                                        textAlign: TextAlign.start,
                                        minLines: 3,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                            filled: true,
                                            hintText: 'Add Comment...'.tr,
                                            fillColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: RoundShapeButton(
                                title: "Submit".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);

                                  await FireStoreUtils.getDriverUserProfile(controller.bookingModel.value.driverId.toString()).then((value) async {
                                    if (value != null) {
                                      DriverUserModel driverModel = value;
                                      if (controller.reviewModel.value.id != null) {
                                        driverModel.reviewsSum =
                                            (double.parse(driverModel.reviewsSum.toString()) - double.parse(controller.reviewModel.value.rating.toString())).toString();
                                        driverModel.reviewsCount = (double.parse(driverModel.reviewsCount.toString()) - 1).toString();
                                      }
                                      driverModel.reviewsSum = (double.parse(driverModel.reviewsSum.toString()) + double.parse(controller.rating.value.toString())).toString();
                                      driverModel.reviewsCount = (double.parse(driverModel.reviewsCount.toString()) + 1).toString();
                                      await FireStoreUtils.updateDriverUser(driverModel);
                                    }
                                  });

                                  controller.reviewModel.value.id = controller.bookingModel.value.id;
                                  controller.reviewModel.value.rating = controller.rating.value.toString();
                                  controller.reviewModel.value.customerId = FireStoreUtils.getCurrentUid();
                                  controller.reviewModel.value.driverId = controller.bookingModel.value.driverId;
                                  controller.reviewModel.value.comment = controller.commentController.value.text;
                                  controller.reviewModel.value.date = Timestamp.now();

                                  await FireStoreUtils.setReview(controller.reviewModel.value).then((value) {
                                    if (value != null && value == true) {
                                      ShowToastDialog.closeLoader();
                                      ShowToastDialog.showToast("Review submit successfully".tr);
                                      Get.back();
                                    }
                                  });
                                },
                                size: const Size(208, 52),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
