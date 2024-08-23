// ignore_for_file: deprecated_member_use

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/menu_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/fire_store_utils.dart';
import '../controllers/document_screen_controller.dart';

class DocumentScreenView extends GetView<DocumentScreenController> {
  const DocumentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DocumentScreenController>(
      init: DocumentScreenController(),
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
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{MenuWidget()},
              Expanded(
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: Obx(
                    () => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ContainerCustom(
                          child: Column(children: [
                            ResponsiveWidget.isDesktop(context)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                        ])
                                      ]),
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "+ Add Document".tr,
                                        borderRadius: 10,
                                        onPress: () {
                                          controller.setDefaultData();
                                          showDialog(context: context, builder: (context) => const DocumentDialog());
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      CustomButtonWidget(
                                        width: MediaQuery.sizeOf(context).width * 0.7,
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "+ Add Document".tr,
                                        borderRadius: 10,
                                        onPress: () {
                                          controller.setDefaultData();
                                          showDialog(context: context, builder: (context) => const DocumentDialog());
                                        },
                                      ),
                                    ],
                                  ),
                            spaceH(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.isLoading.value
                                    ? Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Constant.loader(),
                                      )
                                    : controller.documentsList.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 65,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: MaterialStateColor.resolveWith(
                                                (states) => themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Title".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.25),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Side".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.25),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.10),
                                            ],
                                            rows: controller.documentsList
                                                .map((documentsModel) => DataRow(cells: [
                                                      DataCell(TextCustom(title: documentsModel.title)),
                                                      DataCell(TextCustom(title: documentsModel.isTwoSide == true ? "Two Side" : "One Side")),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            activeColor: AppThemData.primary500,
                                                            value: documentsModel.isEnable!,
                                                            onChanged: (value) async {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                documentsModel.isEnable = value;
                                                                await FireStoreUtils.updateDocument(documentsModel);
                                                                controller.getData();
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  controller.isEditing.value = true;
                                                                  controller.editingId.value = documentsModel.id;
                                                                  controller.isActive.value = documentsModel.isEnable!;
                                                                  controller.documentSide.value = documentsModel.isTwoSide == true ? SideAt.isTwoSide : SideAt.isOneSide;
                                                                  controller.documentNameController.value.text = documentsModel.title;
                                                                  showDialog(context: context, builder: (context) => const DocumentDialog());
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_edit.svg",
                                                                  color: AppThemData.greyShade400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    // controller.removeDocument(documentsModel);
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      controller.removeDocument(documentsModel);
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  color: AppThemData.greyShade400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                              ),
                            ),
                            spaceH(),
                          ]),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum SideAt { isOneSide, isTwoSide }

class DocumentDialog extends StatelessWidget {
  const DocumentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DocumentScreenController>(
      init: DocumentScreenController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Row(
              children: [
                Expanded(child: CustomTextFormField(hintText: 'Enter Document'.tr, controller: controller.documentNameController.value, title: 'Title *'.tr)),
              ],
            ),
            spaceH(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Status'.tr,
                        fontSize: 12,
                      ),
                      spaceH(),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: AppThemData.primary500,
                          value: controller.isActive.value,
                          onChanged: (value) {
                            controller.isActive.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: 'Document Side'.tr,
                            fontSize: 12,
                          ),
                          spaceH(),
                          FittedBox(
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: SideAt.isTwoSide.obs,
                                      groupValue: controller.documentSide.value,
                                      onChanged: (value) {
                                        controller.documentSide.value = SideAt.isTwoSide;
                                      },
                                      activeColor: AppThemData.primary500,
                                    ),
                                    Text("TwoSide".tr,
                                        style: const TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          fontSize: 14,
                                          color: AppThemData.textGrey,
                                        ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: SideAt.isOneSide.obs,
                                      groupValue: controller.documentSide.value,
                                      onChanged: (value) {
                                        controller.documentSide.value = SideAt.isOneSide;
                                      },
                                      activeColor: AppThemData.primary500,
                                    ),
                                    Text("OneSide".tr,
                                        style: const TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          fontSize: 14,
                                          color: AppThemData.textGrey,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              buttonTitle: "Close".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
              onPress: () {
                controller.setDefaultData();
                Navigator.pop(context);
              },
            ),
            spaceW(),
            CustomButtonWidget(
              buttonTitle: controller.isEditing.value ? "Edit".tr : "Save".tr,
              onPress: () {
                if (Constant.isDemo) {
                  DialogBox.demoDialogBox();
                } else {
                  if (controller.documentNameController.value.text != "") {
                    controller.isEditing.value ? controller.updateDocument() : controller.addDocument();
                    controller.setDefaultData();
                    Navigator.pop(context);
                  } else {
                    ShowToastDialog.toast("All Fields are Required...".tr);
                  }
                }
              },
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}
