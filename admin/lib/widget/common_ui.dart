// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:admin/app/modules/home/controllers/home_controller.dart';
import 'package:admin/app/services/localization_service.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../app/routes/app_pages.dart';

class LanguagePopUp extends StatelessWidget {
  const LanguagePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DashboardScreenController>(
        init: DashboardScreenController(),
        builder: (controller) {
          return Padding(
            padding: paddingEdgeInsets(),
            child: ContainerBorderCustom(
              color: AppThemData.greyShade500,
              child: PopupMenuButton<LanguageModel>(
                  color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade25,
                  position: PopupMenuPosition.under,
                  child: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //------------------- for Language Image---------------------
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(30), child: Image.network(controller.selectedLanguage.value.image ?? '', height: 25, width: 25, fit: BoxFit.cover)),
                        TextCustom(title: controller.selectedLanguage.value.name ?? '', fontSize: 15, fontFamily: AppThemeData.bold),
                        SvgPicture.asset(
                          'assets/icons/ic_down.svg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          color: AppThemData.greyShade500,
                        ),
                      ],
                    ),
                  ),
                  onSelected: (LanguageModel value) {
                    printLog("Select Language${value.name}");
                    printLog("Select Language${value.code}");
                    controller.selectedLanguage.value = value;
                    LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                    AppSharedPreference.setString(
                      AppSharedPreference.languageCodeKey,
                      jsonEncode(
                        controller.selectedLanguage.value,
                      ),
                    );
                  },
                  itemBuilder: (BuildContext bc) {
                    return controller.languageList
                        .map((LanguageModel e) => PopupMenuItem<LanguageModel>(
                              height: 30,
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name ?? '', style: TextStyle(color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack)),
                                ],
                              ),
                            ))
                        .toList();
                  }),
            ),
          );
        });
  }
}

class ProfilePopUp extends StatelessWidget {
  ProfilePopUp({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DashboardScreenController(),
        builder: (controller) {
          return InkWell(
            onTap: () => Get.toNamed(Routes.ADMIN_PROFILE),
            child: SizedBox(
              width: ResponsiveWidget.isMobile(context) ? 50 : 140,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: NetworkImageWidget(
                          imageUrl: controller.admin.value.image ?? Constant.userPlaceHolder,
                          height: ResponsiveWidget.isMobile(context) ? 30 : 40,
                          width: ResponsiveWidget.isMobile(context) ? 30 : 40)),
                  if (!ResponsiveWidget.isMobile(context)) spaceW(),
                  if (!ResponsiveWidget.isMobile(context))
                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const TextCustom(title: 'Hello', fontSize: 12, fontFamily: AppThemeData.bold),
                      TextCustom(title: controller.admin.value.name ?? 'Admin', fontSize: 15, fontFamily: AppThemeData.bold, maxLine: 1),
                    ]),
                  if (!ResponsiveWidget.isMobile(context)) spaceW(width: 16),
                ],
              ),
            ),
          );
        });
  }
}

class CommonUI {
  static appBarCustom(
      {Widget? title = const SizedBox(), List<Widget>? actions = const [], required DarkThemeProvider themeChange, required GlobalKey<ScaffoldState> scaffoldKey}) {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      leadingWidth: 200,
      title: title,
      leading: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Center(
          child: Row(
            children: [
              Expanded(
                child:SizedBox(
                  height: 45,
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
      actions: actions! +
          [
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
    );
  }

  static drawerCustom({required DarkThemeProvider themeChange, required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Drawer(
      key: scaffoldKey,
      width: 270,
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      child: MenuWidget(),
    );
  }

  static dataColumnWidget(BuildContext context, {String columnName = 'Na', required String columnTitle, required double width}) {
    return DataColumn(
        label: SizedBox(
      width: width,
      child: TextCustom(
        title: columnTitle,
        fontFamily: AppThemeData.bold,
        maxLine: 2,
      ),
    ));
  }
}

class NumberOfRowsDropDown extends StatelessWidget {
  final controller;

  const NumberOfRowsDropDown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        // if (!ResponsiveWidget.isMobile(context)) spaceW(),
        SizedBox(
          width: 100,
          height: 40,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            style: TextStyle(
              fontFamily: AppThemeData.medium,
              color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.primary500,
            ),
            value: controller.totalItemPerPage.value,
            hint: TextCustom(title: 'Select'.tr),
            onChanged: (String? newValue) {
              controller.setPagination(newValue!);
              log('select value of drop down $newValue');
            },
            decoration: InputDecoration(
                iconColor: AppThemData.primary500,
                isDense: true,
                filled: true,
                fillColor: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                ),
                hintText: "Select".tr,
                hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium)),
            items: Constant.numOfPageIemList.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: TextCustom(
                  title: value,
                  fontFamily: AppThemeData.medium,
                  color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.greyShade800,
                ),
              );
            }).toList(),
          ),
        ),
        spaceW(),
      ]),
    );
  }
}

class CustomDialog extends StatelessWidget {
  String? title = "";
  final controller;
  List<Widget>? widgetList = <Widget>[];
  List<Widget>? bottomWidgetList = <Widget>[];

  CustomDialog({super.key, this.controller, this.widgetList, this.bottomWidgetList, this.title});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      // title: const TextCustom(title: 'Item Categories', fontSize: 18),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextCustom(title: '$title', fontSize: 18),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                        )
                      ],
                    )).expand(),
                // Container(
                //
                //   child: Icon(Icons.close,size: 25,),)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widgetList! +
                    [
                      spaceH(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: bottomWidgetList!,
                      ),
                    ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
