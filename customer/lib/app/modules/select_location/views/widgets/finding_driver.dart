import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/reason_for_cancel/views/reason_for_cancel_view.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FindingDriverBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const FindingDriverBottomSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SelectLocationController(),
        builder: (controller) {
          return Container(
            height: Responsive.height(100, context),
            decoration: const BoxDecoration(
              color: AppThemData.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: ShapeDecoration(
                      color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  StreamBuilder<BookingModel>(
                      stream: FireStoreUtils().getBookingStatusData(controller.bookingModel.value.id ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        if (!snapshot.hasData || (snapshot.data == null)) {
                          return const LinearProgressIndicator();
                        } else {
                          Rx<DriverUserModel> userModel = DriverUserModel().obs;
                          if (snapshot.data!.bookingStatus == BookingStatus.bookingOngoing) {
                            ShowToastDialog.showToast("Your ride started...");
                            // Get.offAll(const HomeView());
                            Get.to(const HomeView());
                          } else if (snapshot.data!.bookingStatus == BookingStatus.bookingAccepted) {
                            FireStoreUtils.getDriverUserProfile(snapshot.data!.driverId ?? '').then((value) {
                              userModel.value = value ?? DriverUserModel();
                            });
                          }
                          return (snapshot.data!.driverId != null && snapshot.data!.driverId!.isNotEmpty && snapshot.data!.bookingStatus != BookingStatus.bookingPlaced)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      child: Text(
                                        'Driver is Arriving....'.tr,
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                      child: SizedBox(
                                        width: Responsive.width(100, context),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              'Your OTP for this Ride is '.tr,
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.otp ?? '',
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Responsive.width(100, context),
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.all(16),
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
                                              color: themeChange.isDarkTheme() ? AppThemData.grey950 : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(200),
                                              ),
                                              image: const DecorationImage(
                                                image: NetworkImage(Constant.profileConstant),
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
                                                Obx(
                                                  () => Text(
                                                    userModel.value.fullName ?? '',
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    if ((userModel.value.reviewsSum ?? '').isNotEmpty) ...{const Icon(Icons.star_rate_rounded, color: AppThemData.warning500)},
                                                    Text(
                                                      (userModel.value.reviewsSum ?? 'No reviews yet').toString(),
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
                                          InkWell(onTap: () {}, child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                          const SizedBox(width: 12),
                                          InkWell(
                                              onTap: () {
                                                Constant().launchCall("${userModel.value.countryCode}${userModel.value.phoneNumber}");
                                              },
                                              child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                      child: PickDropPointView(pickUpAddress: snapshot.data!.pickUpLocationAddress ?? '', dropAddress: snapshot.data!.dropLocationAddress ?? ''),
                                    ),
                                    RoundShapeButton(
                                        size: Size(Responsive.width(100, context), 45),
                                        title: "Cancel",
                                        buttonColor: AppThemData.danger500,
                                        buttonTextColor: AppThemData.white,
                                        onTap: () {
                                          Get.to(const ReasonForCancelView(), arguments: {"bookingModel": controller.bookingModel});
                                        }),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Confirming your trip'.tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const LinearProgressIndicator(),
                                  ],
                                );
                        }
                      })
                ],
              ),
            ),
          );
        });
  }
}
