import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/modules/my_ride_details/controllers/my_ride_details_controller.dart';
import 'package:customer/app/modules/my_ride_details/views/my_ride_details_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/no_rides_view.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/my_ride_controller.dart';

class MyRideView extends StatelessWidget {
  const MyRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: MyRideController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "My Rides".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            //   isUnderlineShow: false,
            // ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RoundShapeButton(
                          title: "Ongoing".tr,
                          buttonColor: controller.selectedType.value == 0
                              ? AppThemData.primary500
                              : themeChange.isDarkTheme()
                                  ? AppThemData.black
                                  : AppThemData.white,
                          buttonTextColor: controller.selectedType.value == 0
                              ? AppThemData.black
                              : themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                          onTap: () {
                            controller.selectedType.value = 0;
                          },
                          size: Size((Responsive.width(90, context) / 3), 38),
                          textSize: 12,
                        ),
                        RoundShapeButton(
                          title: "Completed".tr,
                          buttonColor: controller.selectedType.value == 1
                              ? AppThemData.primary500
                              : themeChange.isDarkTheme()
                                  ? AppThemData.black
                                  : AppThemData.white,
                          buttonTextColor: controller.selectedType.value == 1 ? AppThemData.black : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                          onTap: () {
                            controller.selectedType.value = 1;
                          },
                          size: Size((Responsive.width(90, context) / 3), 38),
                          textSize: 12,
                        ),
                        RoundShapeButton(
                          title: "Rejected".tr,
                          buttonColor: controller.selectedType.value == 2
                              ? AppThemData.primary500
                              : themeChange.isDarkTheme()
                                  ? AppThemData.black
                                  : AppThemData.white,
                          buttonTextColor: controller.selectedType.value == 2
                              ? AppThemData.black
                              : themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                          onTap: () {
                            controller.selectedType.value = 2;
                          },
                          size: Size((Responsive.width(90, context) / 3), 38),
                          textSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                RefreshIndicator(
                  onRefresh: () async {
                    if (controller.selectedType.value == 0) {
                      await controller.getData(isOngoingDataFetch: true, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 1) {
                      await controller.getData(isOngoingDataFetch: false, isCompletedDataFetch: true, isRejectedDataFetch: false);
                    } else {
                      await controller.getData(isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: true);
                    }
                  },
                  child: SizedBox(
                    height: Responsive.height(75, context),
                    child: Obx(
                      () => (controller.selectedType.value == 0
                              ? controller.ongoingRides.isNotEmpty
                              : controller.selectedType.value == 1
                                  ? controller.completedRides.isNotEmpty
                                  : controller.rejectedRides.isNotEmpty)
                          ? ListView.builder(
                              itemCount: controller.selectedType.value == 0
                                  ? controller.ongoingRides.length
                                  : controller.selectedType.value == 1
                                      ? controller.completedRides.length
                                      : controller.rejectedRides.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                RxBool isOpen = false.obs;
                                BookingModel bookingModel = controller.selectedType.value == 0
                                    ? controller.ongoingRides[index]
                                    : controller.selectedType.value == 1
                                        ? controller.completedRides[index]
                                        : controller.rejectedRides[index];
                                return InkWell(
                                  onTap: () {
                                    MyRideDetailsController detailsController = Get.put(MyRideDetailsController());
                                    detailsController.bookingId.value = bookingModel.id ?? '';
                                    detailsController.bookingModel.value = bookingModel;
                                    Get.to(const MyRideDetailsView());
                                  },
                                  child: Container(
                                    width: Responsive.width(100, context),
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.all(16),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            isOpen.value = !isOpen.value;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().dateMonthYear(),
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                height: 15,
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1,
                                                      strokeAlign: BorderSide.strokeAlignCenter,
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().time(),
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.keyboard_arrow_right_sharp,
                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: bookingModel.vehicleType == null ? Constant.profileConstant : bookingModel.vehicleType!.image,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      bookingModel.vehicleType == null ? "" : bookingModel.vehicleType!.title,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      (bookingModel.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    Constant.amountToShow(amount: Constant.calculateFinalAmount(bookingModel).toStringAsFixed(2)),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        bookingModel.vehicleType == null ? "" : bookingModel.vehicleType!.persons,
                                                        style: GoogleFonts.inter(
                                                          color: AppThemData.primary500,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(() => Visibility(
                                              visible: isOpen.value,
                                              child:
                                                  PickDropPointView(pickUpAddress: bookingModel.pickUpLocationAddress ?? '', dropAddress: bookingModel.dropLocationAddress ?? ''),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView(children: [NoRidesView(themeChange: themeChange)]),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
