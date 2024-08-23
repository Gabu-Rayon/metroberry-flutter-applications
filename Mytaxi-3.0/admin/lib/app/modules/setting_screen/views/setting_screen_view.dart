import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenController> {
  const SettingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SettingScreenController>(
        init: SettingScreenController(),
        builder: (controller) {
          return ResponsiveWidget(
            mobile: Scaffold(
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
                // key: scaffoldKey,
                width: 270,
                backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
                child: const MenuWidget(),
              ),
              body: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: paddingEdgeInsets(),
                    child: Center(
                      child: ContainerCustom(
                        color: AppThemData.primary500,
                        padding: const EdgeInsets.all(0),
                        radius: 4,
                        child: ExpansionTile(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            backgroundColor: AppThemData.primary500,
                            iconColor: AppThemData.greyShade900,
                            title: TextCustom(title: 'Settings Menu'.tr),
                            children: controller.settingsAllPage
                                .map((e) => InkWell(
                                      onTap: () {
                                        e.selectIndex = 0;
                                        controller.selectSettingWidget.value = e;
                                        controller.update();
                                      },
                                      child: ContainerCustom(
                                        radius: 0,
                                        color: controller.selectSettingWidget.value.title![0] == e.title![0]
                                            ? themeChange.isDarkTheme()
                                                ? AppThemData.greyShade900
                                                : AppThemData.greyShade100
                                            : null,
                                        child: Row(children: [
                                          SvgPicture.asset(e.icon ?? '',
                                              height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemData.greyShade100 : AppThemData.greyShade900),
                                          spaceW(width: 15),
                                          Expanded(child: TextCustom(title: e.title?[0].tr ?? ''))
                                        ]),
                                      ),
                                    ))
                                .toList()),
                      ),
                    ),
                  ),
                  spaceH(height: 20),
                  Padding(
                    padding: paddingEdgeInsets(),
                    child: GetBuilder(
                        init: SettingScreenController(),
                        builder: (controller) {
                          return controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!];
                        }),
                  )
                ]),
              ),
            ),
            tablet: Scaffold(
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
                // key: scaffoldKey,
                width: 270,
                backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
                child: const MenuWidget(),
              ),
              body: SingleChildScrollView(
                child: Padding(
                    padding: paddingEdgeInsets(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                              flex: 1,
                              child: ContainerCustom(
                                radius: 12,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: controller.settingsAllPage.length,
                                    separatorBuilder: (itemBuilder, index) {
                                      return divider(context, height: 1);
                                    },
                                    itemBuilder: (itemBuilder, index) {
                                      return InkWell(
                                        onTap: () {
                                          controller.settingsAllPage[index].selectIndex = 0;
                                          controller.selectSettingWidget.value = controller.settingsAllPage[index];
                                          controller.update();
                                        },
                                        child: ContainerCustom(
                                          radius: 2,
                                          color: controller.selectSettingWidget.value.title![0] == controller.settingsAllPage[index].title![0]
                                              ? themeChange.isDarkTheme()
                                                  ? AppThemData.greyShade900
                                                  : AppThemData.greyShade100
                                              : null,
                                          child: Row(children: [
                                            SvgPicture.asset(controller.settingsAllPage[index].icon ?? '',
                                                height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemData.greyShade100 : AppThemData.greyShade900),
                                            spaceW(width: 15),
                                            Expanded(child: TextCustom(title: controller.settingsAllPage[index].title?[0].tr ?? ''))
                                          ]),
                                        ),
                                      );
                                    }),
                              )),
                          spaceW(width: 20),
                          Expanded(flex: 3, child: controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!]),
                        ])
                      ],
                    )),
              ),
            ),
            desktop: Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
              appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKeysDrawer),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                  Expanded(
                    child: Padding(
                      padding: paddingEdgeInsets(),
                      child: ContainerCustom(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextCustom(
                                        title: 'Settings'.tr,
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height - 200,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: controller.settingsAllPage.length,
                                            itemBuilder: (itemBuilder, index) {
                                              return InkWell(
                                                onTap: () {
                                                  controller.settingsAllPage[index].selectIndex = 0;
                                                  controller.selectSettingWidget.value = controller.settingsAllPage[index];
                                                  controller.update();
                                                },
                                                child: ContainerCustom(
                                                  radius: 12,
                                                  color: controller.selectSettingWidget.value.title![0] == controller.settingsAllPage[index].title![0]
                                                      ? themeChange.isDarkTheme()
                                                          ? AppThemData.greyShade900
                                                          : AppThemData.greyShade100
                                                      : null,
                                                  child: Row(children: [
                                                    SvgPicture.asset(controller.settingsAllPage[index].icon ?? '',
                                                        height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemData.greyShade100 : AppThemData.greyShade900),
                                                    spaceW(width: 15),
                                                    Expanded(child: TextCustom(title: controller.settingsAllPage[index].title?[0].tr ?? ''))
                                                  ]),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                spaceW(width: 20),
                                Expanded(child: controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!]),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
