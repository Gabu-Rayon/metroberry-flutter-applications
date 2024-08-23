import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/modules/admin_profile/views/admin_profile_view.dart';
import 'package:admin/app/modules/banner_screen/views/banner_screen_view.dart';
import 'package:admin/app/modules/booking_history_screen/views/booking_history_screen_view.dart';
import 'package:admin/app/modules/coupon_screen/views/coupon_screen_view.dart';
import 'package:admin/app/modules/dashboard_screen/views/dashboard_screen_view.dart';
import 'package:admin/app/modules/document_screen/views/document_screen_view.dart';
import 'package:admin/app/modules/driver_screen/views/driver_screen_view.dart';
import 'package:admin/app/modules/passengers_screen/views/passengers_screen_view.dart';
import 'package:admin/app/modules/payout_request/views/payout_request_view.dart';
import 'package:admin/app/modules/setting_screen/views/setting_screen_view.dart';
import 'package:admin/app/modules/vehicle_brand_screen/views/vehicle_brand_screen_view.dart';
import 'package:admin/app/modules/vehicle_model_screen/views/vehicle_model_screen_view.dart';
import 'package:admin/app/modules/verify_document_screen/views/verify_document_screen_view.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../vehicle_type_screen/views/vehicle_type_screen_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Scaffold(
              backgroundColor: AppThemData.lightGrey06,
              key: homeController.scaffoldKey,
              drawer: CommonUI.drawerCustom(scaffoldKey: controller.scaffoldKey, themeChange: themeChange),
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: (!ResponsiveWidget.isDesktop(context))
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Flexible(
                                child: changeWidget(homeController),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MenuWidget(),
                            Obx(
                              () => Flexible(
                                child: changeWidget(homeController),
                              ),
                            ),
                          ],
                        ),
                ),
              ));
        });
  }

  // Widget changeWidget(HomeController homeController) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (homeController.currentPageIndex == 0) {
  //       Get.toNamed(Routes.DASHBOARD_SCREEN);
  //     } else if (homeController.currentPageIndex == 1) {
  //       Get.toNamed(Routes.BOOKING_HISTORY_SCREEN);
  //     } else if (homeController.currentPageIndex == 2) {
  //       Get.toNamed(Routes.PASSENGERS_SCREEN);
  //     }
  //   });
  //
  //   // Return a default widget if none of the conditions are met.
  //   return HomeView(); // or any other Widget as a default.
  // }

  Widget changeWidget(HomeController homeController) {
    switch (homeController.currentPageIndex.value) {
      case 0:
        return const DashboardScreenView();
      case 1:
        return const BookingHistoryScreenView();
      case 2:
        return const PassengersScreenView();
      case 3:
        return const DriverScreenView();
      case 4:
        return const VerifyDocumentScreenView();
      case 5:
        return const BannerScreenView();
      case 6:
        return const DocumentScreenView();
      case 7:
        return const CouponScreenView();
      case 8:
        return const VehicleBrandScreenView();
      case 9:
        return const VehicleModelScreenView();
      case 10:
        return const SettingScreenView();
      case 11:
        return const PayoutRequestView();
      case 12:
        return const AdminProfileView();
      case 13:
        return const AdminProfileView();
      case 14:
        return const CouponScreenView();
      case 15:
        return const VehicleTypeScreenView();
      default:
        return const HomeView();
    }
  }

  // Widget changeWidget(HomeController homeController) {
  //   switch (homeController.currentPageIndex.value) {
  //     case 0:
  //       return _navigateTo(Routes.DASHBOARD_SCREEN);
  //     case 1:
  //       return _navigateTo(Routes.BOOKING_HISTORY_SCREEN);
  //     case 2:
  //       return _navigateTo(Routes.PASSENGERS_SCREEN);
  //     case 3:
  //       return _navigateTo(Routes.BOOKING_HISTORY_DETAIL);
  //     case 4:
  //       return _navigateTo(Routes.DRIVER_SCREEN);
  //     case 5:
  //       return _navigateTo(Routes.VERIFY_DOCUMENT_SCREEN);
  //     case 6:
  //       return _navigateTo(Routes.BANNER_SCREEN);
  //     case 7:
  //       return _navigateTo(Routes.DOCUMENT_SCREEN);
  //     case 8:
  //       return _navigateTo(Routes.COUPON_SCREEN);
  //     case 9:
  //       return _navigateTo(Routes.VEHICLE_SCREEN);
  //     case 10:
  //       return _navigateTo(Routes.VEHICLE_MODEL_SCREEN);
  //     case 11:
  //       return _navigateTo(Routes.SETTING_SCREEN);
  //     case 12:
  //       return _navigateTo(Routes.PAYOUT_REQUEST);
  //     // case 13:
  //     //   return _navigateTo(Routes.ADMIN_PROFILE, arguments: {'screenName': "Profile"});
  //     // case 14:
  //     //   return _navigateTo(Routes.ADMIN_PROFILE, arguments: {'screenName': "Change Password"});
  //     case 15:
  //       return _navigateTo(Routes.COUPON_SCREEN);
  //     case 16:
  //       return _navigateTo(Routes.VEHICLE_TYPE_SCREEN);
  //     default:
  //       return _navigateTo(Routes.HOME);
  //   }
  // }

  Widget _navigateTo(String routeName, [Object? arguments]) {
    Get.toNamed(routeName, arguments: arguments);
    // Since Get.to() returns a Future<dynamic>,
    // you can return any placeholder widget while waiting for navigation to complete.
    return const CircularProgressIndicator();
  }
}
