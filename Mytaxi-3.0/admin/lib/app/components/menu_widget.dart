// ignore_for_file: depend_on_referenced_packages

import 'package:admin/app/modules/driver_screen/controllers/driver_screen_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      width: 270,
      height: 1.sh,
      child: Column(
        children: [
          if (!ResponsiveWidget.isDesktop(context)) ...{
            GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              },
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/image/logo.png",
                              height: 45,
                              color: AppThemData.primary500,
                            ),
                            spaceW(),
                            const TextCustom(
                              title: 'My Taxi',
                              color: AppThemData.primary500,
                              fontSize: 30,
                              fontFamily: AppThemeData.semiBold,
                              fontWeight: FontWeight.w700,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            14.height,
            Divider(color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
          },
          Expanded(
            child: SingleChildScrollView(
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: TextCustom(
                      title: "MAIN".tr,
                      color: AppThemData.greyShade400,
                      fontSize: 12,
                    )),
                    ListItem(
                      buttonTitle: "Dashboard".tr,
                      icon: "assets/icons/ic_vertical_line.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.DASHBOARD_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "BOOKING MANAGEMENT".tr,
                      color: AppThemData.greyShade400,
                      fontSize: 12,
                    )),
                    ListItem(
                      buttonTitle: 'Booking History'.tr,
                      icon: "assets/icons/ic_shopping_cart.svg",
                      onPress: () {
                        if (Get.currentRoute == Routes.BOOKING_DETAIL) {
                          Get.back();
                        }
                        Get.toNamed(Routes.BOOKING_HISTORY_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.BOOKING_HISTORY_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "CUSTOMER MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: "Passengers".tr,
                      icon: "assets/icons/ic_user.svg",
                      onPress: () {
                        if (Get.currentRoute == Routes.PASSENGERS_DETAIL_SCREEN) {
                          Get.back();
                        }
                        if (Get.currentRoute == Routes.BOOKING_DETAIL) {
                          Get.back();
                        }
                        Get.toNamed(Routes.PASSENGERS_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.PASSENGERS_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "PROVIDER MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      onPress: () async {
                        if (Get.currentRoute == Routes.PASSENGERS_DETAIL_SCREEN) {
                          Get.back();
                        }
                        if (Get.currentRoute == Routes.BOOKING_DETAIL) {
                          Get.back();
                        }
                        Get.toNamed(Routes.DRIVER_SCREEN);
                      },
                      buttonTitle: 'Drivers'.tr,
                      icon: "assets/icons/ic_driver.svg",
                      isSelected: Get.currentRoute == Routes.DRIVER_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.VEHICLE_BRAND_SCREEN);
                      },
                      buttonTitle: 'Vehicle Brand'.tr,
                      icon: "assets/icons/ic_car_2.svg",
                      isSelected: Get.currentRoute == Routes.VEHICLE_BRAND_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.VEHICLE_MODEL_SCREEN);
                      },
                      buttonTitle: 'Vehicle Model'.tr,
                      icon: "assets/icons/ic_car_2.svg",
                      isSelected: Get.currentRoute == Routes.VEHICLE_MODEL_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.VEHICLE_TYPE_SCREEN);
                      },
                      buttonTitle: 'Vehicle Type'.tr,
                      icon: "assets/icons/ic_car_2.svg",
                      isSelected: Get.currentRoute == Routes.VEHICLE_TYPE_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Verify Documents'.tr,
                      icon: "assets/icons/ic_check_circle.svg",
                      onPress: () {
                        Get.toNamed(Routes.VERIFY_DOCUMENT_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.VERIFY_DOCUMENT_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "SERVICE MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: 'Banner'.tr,
                      icon: "assets/icons/ic_album.svg",
                      onPress: () {
                        Get.toNamed(Routes.BANNER_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.BANNER_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Documents'.tr,
                      icon: "assets/icons/ic_document.svg",
                      onPress: () {
                        Get.toNamed(Routes.DOCUMENT_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.DOCUMENT_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Payout Request'.tr,
                      icon: "assets/icons/ic_payout.svg",
                      onPress: () {
                        Get.toNamed(Routes.PAYOUT_REQUEST);
                      },
                      isSelected: Get.currentRoute == Routes.PAYOUT_REQUEST,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Coupon Screen'.tr,
                      icon: "assets/icons/ic_payout.svg",
                      onPress: () {
                        Get.toNamed(Routes.COUPON_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.COUPON_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "SYSTEM MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: 'Settings'.tr,
                      icon: "assets/icons/ic_settings.svg",
                      onPress: () {
                        Get.toNamed(Routes.SETTING_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.SETTING_SCREEN,
                      themeChange: themeChange,
                    ),
                  ],
                ),
              ),
            ),
          ),
          LogoutListItem(
            buttonTitle: 'Log out'.tr,
            icon: "assets/icons/ic_exit.svg",
            onPress: () {
              showDialog<bool>(
                context: Get.context!,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Logout?'.tr,
                    style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 18, color: AppThemData.greyShade950, fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Are you sure you want to logout?'.tr,
                    style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 16, color: AppThemData.textGrey, fontWeight: FontWeight.w400),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemData.textBlack, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await AppSharedPreference.appSharedPreference.removeIsUserLoggedIn();
                        Get.offAllNamed(Routes.LOGIN_PAGE);
                      },
                      child: Text(
                        'Log out'.tr,
                        style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemData.red800, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            textColor: AppThemData.red600,
            iconColor: AppThemData.red600,
            buttonColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
          ),
        ],
      ),
    );
  }
}

class LogoutListItem extends StatelessWidget {
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;

  const LogoutListItem({
    super.key,
    this.buttonColor,
    this.iconColor,
    this.textColor,
    this.buttonTitle,
    this.icon,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
        color: buttonColor,
        boxShadow: [
          BoxShadow(color: AppThemData.black07, offset: textColor == AppThemData.black07 ? const Offset(4, 0) : const Offset(0, 0)),
        ],
      ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  color: iconColor,
                  height: 16,
                  width: 16,
                ),
              )
            : null,
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ListItem({super.key, this.buttonTitle, this.icon, this.onPress, this.isSelected, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 15,
            color: isSelected == true
                ? AppThemData.primary500
                : themeChange.isDarkTheme()
                    ? AppThemData.greyShade25
                    : AppThemData.greyShade950,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  colorFilter: ColorFilter.mode(
                      isSelected == true
                          ? AppThemData.primary500
                          : themeChange.isDarkTheme()
                              ? AppThemData.greyShade25
                              : AppThemData.greyShade950,
                      BlendMode.srcIn),
                  height: 16,
                  width: 16,
                ),
              )
            : null,
      ),
    );
  }
}

class ExpansionTileItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final List<Widget>? children;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ExpansionTileItem({super.key, this.title, this.icon, this.children, this.isSelected, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            ),
      child: ListTileTheme(
        minLeadingWidth: 20,
        child: ExpansionTile(
          title: Text(
            title!,
            style: TextStyle(
              fontFamily: AppThemeData.bold,
              fontSize: 15,
              color: isSelected == true
                  ? themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.greyShade950
                  : themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.greyShade950,
            ),
          ),
          initiallyExpanded: false,
          childrenPadding: const EdgeInsets.only(left: 70, top: 0, bottom: 0, right: 0),
          backgroundColor: Colors.transparent,
          // collapsedIconColor: AppColors.darkGrey04,
          iconColor: AppThemData.greyShade400,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon!,
              color: isSelected == true
                  ? AppThemData.primary500
                  : themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.greyShade950,
              height: 16,
              width: 16,
            ),
          ),
          children: children!.toList(),
        ),
      ),
    );
  }
}
