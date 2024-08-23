// ignore_for_file: must_be_immutable

import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/modules/admin_profile/widget/change_password_widget.dart';
import 'package:admin/app/modules/admin_profile/widget/profile_widget.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/admin_profile_controller.dart';

class AdminProfileView extends GetView<AdminProfileController> {
  // String? screenName = "Profile".tr;
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: AdminProfileController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (!ResponsiveWidget.isDesktop(context)) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: !ResponsiveWidget.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                              ),
                            )
                          : SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/logo.png",
                                    height: 50,
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
                  );
                },
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    if (themeChange.darkTheme == 1) {
                      themeChange.darkTheme = 0;
                    } else if (themeChange.darkTheme == 0) {
                      themeChange.darkTheme = 1;
                    } else if (themeChange.darkTheme == 2) {
                      themeChange.darkTheme = 0;
                    } else {
                      themeChange.darkTheme = 2;
                    }
                  },
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: AppThemData.yellow600,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: AppThemData.blue400,
                          height: 20,
                          width: 20,
                        ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: !ResponsiveWidget.isMobile(context)
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: ProfileWidget(
                                  adminProfileController: controller,
                                )),
                                spaceW(width: 24),
                                Expanded(
                                    child: ChangePasswordWidget(
                                  adminProfileController: controller,
                                )),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileWidget(
                                    adminProfileController: controller,
                                  ),
                                  spaceH(height: 24),
                                  ChangePasswordWidget(
                                    adminProfileController: controller,
                                  ),
                                ],
                              ),
                            )),
                ),
              ],
            ));
      },
    );
  }
}
