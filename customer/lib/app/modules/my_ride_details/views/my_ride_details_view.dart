import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:customer/app/modules/my_ride_details/views/widgets/payment_dialog_view.dart';
import 'package:customer/app/modules/payment_method/views/widgets/price_row_view.dart';
import 'package:customer/app/modules/reason_for_cancel/views/reason_for_cancel_view.dart';
import 'package:customer/app/modules/review_screen/views/review_screen_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/constant_widgets/title_view.dart';
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

import '../controllers/my_ride_details_controller.dart';

class MyRideDetailsView extends GetView<MyRideDetailsController> {
  const MyRideDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: MyRideDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Ride Details".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () async {
                          if (controller.bookingModel.value.paymentStatus != true && controller.bookingModel.value.bookingStatus == BookingStatus.bookingOngoing) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              isDismissible: true,
                              enableDrag: true,
                              constraints: BoxConstraints(maxHeight: Responsive.height(90, context), maxWidth: Responsive.width(100, context)),
                              builder: (BuildContext context) {
                                return const PaymentDialogView();
                              },
                            );
                          }
                        },
                        child: Obx(
                          () => Container(
                            width: Responsive.width(100, context),
                            height: 56,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name
                                //     ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                //     : SvgPicture.asset("assets/icon/ic_cash.svg"),
                                (controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name)
                                    ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                    : (controller.selectedPaymentMethod.value == Constant.paymentModel!.wallet!.name)
                                        ? SvgPicture.asset("assets/icon/ic_wallet.svg")
                                        : (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name)
                                            ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                            : (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name)
                                                ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                                : (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name)
                                                    ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                                    : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name)
                                                        ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                        : (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name)
                                                            ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                            : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name)
                                                                ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                                : (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name)
                                                                    ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                    : const SizedBox(height: 24, width: 24),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    controller.selectedPaymentMethod.value.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (controller.bookingModel.value.bookingStatus != BookingStatus.bookingCompleted &&
                        controller.bookingModel.value.bookingStatus != BookingStatus.bookingOngoing &&
                        controller.bookingModel.value.bookingStatus != BookingStatus.bookingCancelled)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RoundShapeButton(
                            title: "Cancel Ride".tr,
                            buttonColor: AppThemData.danger_500p,
                            buttonTextColor: AppThemData.white,
                            onTap: () {
                              Get.to(const ReasonForCancelView(), arguments: {"bookingModel": controller.bookingModel.value});
                            },
                            size: Size(Responsive.width(45, context), 52),
                          ),
                          RoundShapeButton(
                            title: "Track Ride".tr,
                            buttonColor: AppThemData.primary500,
                            buttonTextColor: AppThemData.black,
                            onTap: () {
                              Get.toNamed(Routes.TRACK_RIDE_SCREEN, arguments: {
                                "bookingModel": controller.bookingModel.value,
                              });
                            },
                            size: Size(Responsive.width(45, context), 52),
                          )
                        ],
                      ),
                    if (controller.bookingModel.value.paymentStatus != true && controller.bookingModel.value.bookingStatus == BookingStatus.bookingOngoing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: controller.selectedPaymentMethod.value != Constant.paymentModel!.cash!.name,
                            child: RoundShapeButton(
                              title: "Pay Now".tr,
                              buttonColor: AppThemData.success500,
                              buttonTextColor: AppThemData.black,
                              onTap: () async {
                                if (controller.selectedPaymentMethod.value == Constant.paymentModel!.wallet!.name) {
                                  controller.getProfileData();

                                  if (double.parse(controller.userModel.value.walletAmount!) < Constant.calculateFinalAmount(controller.bookingModel.value)) {
                                    ShowToastDialog.showToast("Your wallet amount is insufficient to Payment".tr);
                                  } else {
                                    controller.walletPaymentMethod();
                                  }
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name) {
                                  await controller.paypalPaymentSheet(Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.stripeMakePayment(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                  ShowToastDialog.closeLoader();
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name) {
                                  await controller.razorpayMakePayment(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.flutterWaveInitiatePayment(
                                      context: context, amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                  ShowToastDialog.closeLoader();
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.payStackPayment(Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                  ShowToastDialog.closeLoader();
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.mercadoPagoMakePayment(
                                      context: context, amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                  ShowToastDialog.closeLoader();
                                } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.payFastPayment(context: context, amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                  ShowToastDialog.closeLoader();
                                }
                              },
                              size: Size(Responsive.width(45, context), 52),
                            ),
                          ),
                          RoundShapeButton(
                            title: "Track Ride".tr,
                            buttonColor: AppThemData.primary500,
                            buttonTextColor: AppThemData.black,
                            onTap: () {
                              Get.toNamed(Routes.TRACK_RIDE_SCREEN, arguments: {
                                "bookingModel": controller.bookingModel.value,
                              });
                            },
                            size: Size(Responsive.width(45, context), 52),
                          )
                        ],
                      ),
                    if (controller.bookingModel.value.paymentStatus == true && controller.bookingModel.value.bookingStatus == BookingStatus.bookingOngoing)
                      RoundShapeButton(
                        title: "Track Ride".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          Get.toNamed(Routes.TRACK_RIDE_SCREEN, arguments: {
                            "bookingModel": controller.bookingModel.value,
                          });
                        },
                        size: Size(Responsive.width(45, context), 52),
                      ),
                    if (controller.bookingModel.value.paymentStatus == true && controller.bookingModel.value.bookingStatus == BookingStatus.bookingCompleted)
                      RoundShapeButton(
                        title: "Review".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          Get.to(const ReviewScreenView(), arguments: {"bookingModel": controller.bookingModel});
                        },
                        size: Size(Responsive.width(45, context), 52),
                      ),
                  ],
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => controller.getBookingDetails(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ride Status'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            BookingStatus.getBookingStatusTitle(controller.bookingModel.value.bookingStatus ?? ''),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: BookingStatus.getBookingStatusTitleColor(controller.bookingModel.value.bookingStatus ?? ''),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: controller.bookingModel.value.bookingStatus == BookingStatus.bookingAccepted,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Your OTP for Ride'.tr,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              controller.bookingModel.value.otp ?? '',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: AppThemData.primary500,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      TitleView(titleText: 'Cab Details'.tr, padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller.bookingModel.value.vehicleType == null ? Constant.profileConstant : controller.bookingModel.value.vehicleType!.image,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.bookingModel.value.vehicleType == null ? "" : controller.bookingModel.value.vehicleType!.title,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      (controller.bookingModel.value.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
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
                                    Constant.amountToShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toStringAsFixed(2)),
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
                                        controller.bookingModel.value.vehicleType == null ? "" : controller.bookingModel.value.vehicleType!.persons,
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
                      ),
                      if (controller.bookingModel.value.bookingStatus != BookingStatus.bookingPlaced) ...{
                        FutureBuilder<DriverUserModel?>(
                            future: FireStoreUtils.getDriverUserProfile(controller.bookingModel.value.driverId ?? ''),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              DriverUserModel driverUserModel = snapshot.data ?? DriverUserModel();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleView(titleText: 'Driver Details'.tr, padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                                  Container(
                                    width: Responsive.width(100, context),
                                    padding: const EdgeInsets.all(16),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          margin: const EdgeInsets.only(right: 10),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(200),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(driverUserModel.profilePic != null
                                                  ? driverUserModel.profilePic!.isNotEmpty
                                                      ? driverUserModel.profilePic ?? Constant.profileConstant
                                                      : Constant.profileConstant
                                                  : Constant.profileConstant),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                driverUserModel.fullName ?? '',
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star_rate_rounded, color: AppThemData.warning500),
                                                  Text(
                                                    Constant.calculateReview(reviewCount: driverUserModel.reviewsCount, reviewSum: driverUserModel.reviewsSum).toString(),
                                                    // driverUserModel.reviewsSum ?? '0.0',
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Get.to(ChatScreenView(
                                                receiverId: driverUserModel.id ?? '',
                                              ));
                                            },
                                            child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                        const SizedBox(width: 12),
                                        InkWell(
                                            onTap: () {
                                              Constant().launchCall("${driverUserModel.countryCode}${driverUserModel.phoneNumber}");
                                            },
                                            child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              );
                            })
                      },
                      PickDropPointView(
                        pickUpAddress: controller.bookingModel.value.pickUpLocationAddress ?? '',
                        dropAddress: controller.bookingModel.value.dropLocationAddress ?? '',
                      ),
                      TitleView(titleText: 'Ride Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_calendar.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Date'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.bookingModel.value.bookingTime == null ? "" : controller.bookingModel.value.bookingTime!.toDate().dateMonthYear(),
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 0.11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_time.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Time'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.bookingModel.value.bookingTime == null ? "" : controller.bookingModel.value.bookingTime!.toDate().time(),
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 0.11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_distance.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Distance'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                FutureBuilder<String>(
                                  future: controller.getDistanceInKm(),
                                  initialData: '',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    return Text(
                                      snapshot.data ?? '',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 0.11,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TitleView(titleText: 'Price Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 12),
                        decoration: ShapeDecoration(
                          color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PriceRowView(
                                price: controller.bookingModel.value.subTotal.toString(),
                                title: "Amount".tr,
                                priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              ),
                              const SizedBox(height: 16),
                              PriceRowView(
                                  price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                  title: "Discount".tr,
                                  priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                              const SizedBox(height: 16),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.bookingModel.value.taxList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                  return Column(
                                    children: [
                                      PriceRowView(
                                          price: Constant.amountToShow(
                                              amount:
                                                  Constant.calculateTax(amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel)
                                                      .toString()),
                                          title: "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                          priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Divider(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                              const SizedBox(height: 12),
                              PriceRowView(
                                price: Constant.amountToShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                title: "Total Amount".tr,
                                priceColor: AppThemData.primary500,
                                titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              ),
                            ],
                          ),
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
