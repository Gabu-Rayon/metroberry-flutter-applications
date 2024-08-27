import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/custom_dialog_box.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/reason_for_cancel_controller.dart';

class ReasonForCancelView extends StatelessWidget {
  const ReasonForCancelView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: ReasonForCancelController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Reasons for Canceling Ride", bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundShapeButton(
                    title: "Cancel",
                    buttonColor: AppThemData.grey50,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      Get.back();
                    },
                    size: Size(Responsive.width(45, context), 52),
                  ),
                  RoundShapeButton(
                    title: "Continue",
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () async {
                      bool isCancelled = await controller.cancelBooking(controller.bookingModel.value);
                      if (isCancelled) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CustomDialogBox(
                              title: "Your ride is successfully cancelled.".tr,
                              descriptions: "We hope to serve you better next time.".tr,
                              img: Image.asset(
                                "assets/icon/ic_green_right.png",
                                height: 58,
                                width: 58,
                              ),
                              positiveClick: () async {
                                if (controller.bookingModel.value.driverId != null) {
                                  controller.sendCancelRideNotification();
                                }
                                Navigator.pop(context);
                                // Get.offAll(const HomeView());
                                Get.to(const HomeView());
                              },
                              negativeClick: () {
                                Navigator.pop(context);
                                // Get.offAll(const HomeView());
                                Get.to(const HomeView());
                              },
                              positiveString: "Back to Home".tr,
                              negativeString: "Cancel".tr,
                              themeChange: themeChange,
                              negativeButtonColor: AppThemData.grey50,
                              negativeButtonTextColor: AppThemData.grey950,
                            );
                          },
                        );
                      } else {
                        ShowToastDialog.showToast("Something went wrong!");
                      }
                    },
                    size: Size(Responsive.width(45, context), 52),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Column(
                            children: [
                              RadioListTile(
                                value: index,
                                contentPadding: EdgeInsets.zero,
                                groupValue: controller.selectedIndex.value,
                                controlAffinity: ListTileControlAffinity.trailing,
                                activeColor: AppThemData.primary500,
                                onChanged: (ind) {
                                  controller.selectedIndex.value = ind ?? 0;
                                },
                                title: Text(
                                  controller.reasons[index].toString(),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (index != (controller.reasons.length - 1)) const Divider()
                            ],
                          ),
                        );
                      },
                      itemCount: controller.reasons.length,
                    ),
                    Obx(
                      () => TextFormField(
                        enabled: controller.reasons[controller.selectedIndex.value] == "Other",
                        textAlign: TextAlign.start,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Type here...'.tr,
                            fillColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
