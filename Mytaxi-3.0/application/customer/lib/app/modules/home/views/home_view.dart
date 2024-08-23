// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/modules/home/views/widgets/drawer_view.dart';
import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:customer/app/modules/language/views/language_view.dart';
import 'package:customer/app/modules/my_ride/views/my_ride_view.dart';
import 'package:customer/app/modules/my_ride_details/controllers/my_ride_details_controller.dart';
import 'package:customer/app/modules/my_ride_details/views/my_ride_details_view.dart';
import 'package:customer/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:customer/app/modules/notification/views/notification_view.dart';
import 'package:customer/app/modules/select_location/views/select_location_view.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/no_rides_view.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              appBar: AppBar(
                shape: Border(bottom: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icon/logo_only.svg"),
                    const SizedBox(width: 10),
                    Text(
                      'MyTaxi'.tr,
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.to(const NotificationView());
                      },
                      icon: const Icon(Icons.notifications_none_rounded))
                ],
              ),
              drawer: const DrawerView(),
              body: Obx(
                () => controller.drawerIndex.value == 1
                    ? const MyRideView()
                    : controller.drawerIndex.value == 2
                        ? const MyWalletView()
                        : controller.drawerIndex.value == 3
                            ? HtmlViewScreenView(title: "Privacy & Policy".tr, htmlData: Constant.privacyPolicy)
                            : controller.drawerIndex.value == 4
                                ? HtmlViewScreenView(title: "Terms & Condition".tr, htmlData: Constant.termsAndConditions)
                                : controller.drawerIndex.value == 5
                                    ? const LanguageView()
                                    : controller.isLoading.value
                                        ? Constant.loader()
                                        : SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(const SelectLocationView());
                                                    },
                                                    child: Container(
                                                      width: Responsive.width(100, context),
                                                      height: 56,
                                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: ShapeDecoration(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.search_rounded,
                                                            color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text(
                                                              'Where to?'.tr,
                                                              style: GoogleFonts.inter(
                                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  BannerView(),
                                                  Text(
                                                    'Your Rides'.tr,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  StreamBuilder<List<BookingModel>>(
                                                      stream: FireStoreUtils().getHomeOngoingBookings(),
                                                      builder: (context, snapshot) {
                                                        log("State : ${snapshot.connectionState}");
                                                        log("State : ${snapshot.data}");
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Constant.loader();
                                                        }
                                                        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                                                          return NoRidesView(
                                                            themeChange: themeChange,
                                                            height: Responsive.height(40, context),
                                                          );
                                                        } else {
                                                          List<BookingModel> bookingModelList = snapshot.data!;
                                                          return ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemCount: bookingModelList.length,
                                                            itemBuilder: (context, index) {
                                                              return Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      MyRideDetailsController detailsController = Get.put(MyRideDetailsController());
                                                                      detailsController.bookingId.value = bookingModelList[index].id ?? '';
                                                                      detailsController.bookingModel.value = bookingModelList[index];
                                                                      Get.to(const MyRideDetailsView());
                                                                    },
                                                                    child: Container(
                                                                      width: Responsive.width(100, context),
                                                                      padding: const EdgeInsets.all(16),
                                                                      decoration: ShapeDecoration(
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                bookingModelList[index].bookingTime == null
                                                                                    ? ""
                                                                                    : bookingModelList[index].bookingTime!.toDate().dateMonthYear(),
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
                                                                                  bookingModelList[index].bookingTime == null
                                                                                      ? ""
                                                                                      : bookingModelList[index].bookingTime!.toDate().time(),
                                                                                  style: GoogleFonts.inter(
                                                                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 8),
                                                                              Text(
                                                                                BookingStatus.getBookingStatusTitle(bookingModelList[index].bookingStatus ?? ''),
                                                                                textAlign: TextAlign.right,
                                                                                style: GoogleFonts.inter(
                                                                                  color: BookingStatus.getBookingStatusTitleColor(
                                                                                      bookingModelList[index].bookingStatus ?? ''),
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              )
                                                                            ],
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
                                                                                  imageUrl: bookingModelList[index].vehicleType == null
                                                                                      ? Constant.profileConstant
                                                                                      : bookingModelList[index].vehicleType!.image,
                                                                                ),
                                                                                const SizedBox(width: 12),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        bookingModelList[index].vehicleType == null
                                                                                            ? ""
                                                                                            : bookingModelList[index].vehicleType!.title,
                                                                                        style: GoogleFonts.inter(
                                                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(height: 2),
                                                                                      if (bookingModelList[index].bookingStatus == BookingStatus.bookingAccepted)
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'OTP : '.tr,
                                                                                              style: GoogleFonts.inter(
                                                                                                color:
                                                                                                    themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              bookingModelList[index].otp ?? '',
                                                                                              textAlign: TextAlign.right,
                                                                                              style: GoogleFonts.inter(
                                                                                                color: AppThemData.primary500,
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
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
                                                                                      Constant.amountToShow(
                                                                                          amount:
                                                                                              Constant.calculateFinalAmount(bookingModelList[index]).toStringAsFixed(2)),
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
                                                                                        SvgPicture.asset(
                                                                                          "assets/icon/ic_multi_person.svg",
                                                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                                        ),
                                                                                        const SizedBox(width: 6),
                                                                                        Text(
                                                                                          bookingModelList[index].vehicleType == null
                                                                                              ? ""
                                                                                              : bookingModelList[index].vehicleType!.persons,
                                                                                          style: GoogleFonts.inter(
                                                                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 4),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      }),
                                                  // Container(
                                                  //   width: Responsive.width(100, context),
                                                  //   padding: const EdgeInsets.all(16),
                                                  //   margin: const EdgeInsets.only(top: 16),
                                                  //   decoration: ShapeDecoration(
                                                  //     image: const DecorationImage(image: AssetImage("assets/images/offer_banner_background.png"), fit: BoxFit.cover),
                                                  //     shape: RoundedRectangleBorder(
                                                  //       borderRadius: BorderRadius.circular(16),
                                                  //     ),
                                                  //   ),
                                                  //   child: Column(
                                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //     children: [
                                                  //       Text(
                                                  //         'Expanded Seating Offer',
                                                  //         style: GoogleFonts.inter(
                                                  //           color: AppThemData.primary500,
                                                  //           fontSize: 18,
                                                  //           fontWeight: FontWeight.w700,
                                                  //         ),
                                                  //       ),
                                                  //       Padding(
                                                  //         padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                                                  //         child: Text(
                                                  //           'Our 4-seater sedans now accommodate an extra passenger at no additional cost!',
                                                  //           style: GoogleFonts.inter(
                                                  //             color: Colors.white,
                                                  //             fontSize: 14,
                                                  //             fontWeight: FontWeight.w400,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       RoundShapeButton(
                                                  //           size: const Size(140, 34),
                                                  //           title: "Book Now".tr,
                                                  //           buttonColor: AppThemData.white,
                                                  //           buttonTextColor: AppThemData.black,
                                                  //           onTap: () {}),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
              ));
        });
  }
}

class BannerView extends StatelessWidget {
  BannerView({
    super.key,
  });

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.bannerList.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: Responsive.height(22, context),
                  child: PageView.builder(
                    itemCount: controller.bannerList.length,
                    controller: controller.pageController,
                    onPageChanged: (value) {
                      controller.curPage.value = value;
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        width: Responsive.width(100, context),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: ShapeDecoration(
                          image: DecorationImage(image: NetworkImage(controller.bannerList[index].image ?? ""), fit: BoxFit.cover),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Container(
                          width: Responsive.width(100, context),
                          padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
                          decoration: ShapeDecoration(
                            color: AppThemData.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.bannerList[index].bannerName ?? '',
                                style: GoogleFonts.inter(
                                  color: AppThemData.grey50,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: Responsive.width(100, context),
                                margin: const EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(
                                  controller.bannerList[index].bannerDescription ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: AppThemData.grey50,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.bannerList[index].isOfferBanner ?? false,
                                child: Text(
                                  controller.bannerList[index].offerText ?? '',
                                  style: GoogleFonts.inter(
                                    color: AppThemData.primary500,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Center(
            child: SizedBox(
              height: 8,
              child: ListView.builder(
                itemCount: controller.bannerList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(
                    () => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == controller.curPage.value ? AppThemData.primary500 : AppThemData.grey200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
