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

import '../../../routes/app_pages.dart';
import '../../../utils/fire_store_utils.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LanguageController>(
      init: LanguageController(),
      builder: (controller) {
        return Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ContainerCustom(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ResponsiveWidget.isDesktop(context)
                          ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                          spaceH(height: 2),
                          Row(children: [
                            GestureDetector(
                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                            TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                          ])
                        ],
                      )
                          :
                      TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primaryBlack),

                      CustomButtonWidget(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        buttonTitle: "+ Add Language".tr,
                        onPress: () {
                          controller.setDefaultData();
                          showDialog(context: context, builder: (context) => const CustomDialog());
                        },
                      ),
                    ],
                  ),
                  spaceH(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: controller.languageList.isEmpty
                          ? Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            )
                          : DataTable(
                              horizontalMargin: 20,
                              columnSpacing: 30,
                              dataRowMaxHeight: 65,
                              headingRowHeight: 65,
                              border: TableBorder.all(
                                color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                              columns: [
                                CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 50 : MediaQuery.of(context).size.width * 0.05),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.15),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Code".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.15),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 90 : MediaQuery.of(context).size.width * 0.09),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.10),
                              ],
                              rows: controller.languageList
                                  .map((languageModel) => DataRow(cells: [
                                        DataCell(TextCustom(title: "${controller.languageList.indexWhere((element) => element == languageModel) + 1}")),
                                        DataCell(TextCustom(title: "${languageModel.name}")),
                                        DataCell(TextCustom(title: "${languageModel.code}")),
                                        DataCell(
                                          SizedBox(
                                            height: 10,
                                            child: Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                activeColor: AppThemData.primary500,
                                                value: languageModel.active!,
                                                onChanged: (value) async {
                                                  if (Constant.isDemo) {
                                                    DialogBox.demoDialogBox();
                                                  } else {
                                                    languageModel.active = value;
                                                    await FireStoreUtils.updateLanguage(languageModel);
                                                    controller.getData();
                                                  }
                                                },
                                              ),
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
                                                    controller.languageModel.value.id = languageModel.id!;
                                                    controller.languageController.value.text = languageModel.name!;
                                                    controller.codeController.value.text = languageModel.code!;
                                                    controller.isActive.value = languageModel.active!;
                                                    showDialog(context: context, builder: (context) => const CustomDialog());
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

                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                      if (confirmDelete) {
                                                      await  controller.removeLanguage(languageModel);
                                                        controller.getData();
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
        );
      },
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LanguageController>(
        init: LanguageController(),
        builder: (controller) {
          return Dialog(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            // title: const TextCustom(title: 'Item Categories', fontSize: 18),
            child: SizedBox(
              width: 500,
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
                              child: TextCustom(title: '${controller.title}', fontSize: 18))
                          .expand(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: CustomTextFormField(hintText: 'Enter Language Name'.tr, controller: controller.languageController.value, title: 'Name *'.tr)),
                            spaceW(width: 24),
                            Expanded(child: CustomTextFormField(hintText: 'Enter Language Code'.tr, controller: controller.codeController.value, title: 'Code *'.tr)),
                          ],
                        ),
                        spaceH(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                TextCustom(
                                  title: 'Status'.tr,
                                  fontSize: 12,
                                ),
                                spaceH(height: 10),
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
                                spaceH(height: 16),
                              ],
                            ),
                          ],
                        ),
                        spaceH(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                  if (controller.languageController.value.text != "" && controller.codeController.value.text != "") {
                                    controller.isEditing.value ? controller.updateLanguage() : controller.addLanguage();
                                    controller.setDefaultData();
                                    Navigator.pop(context);
                                  } else {
                                    ShowToastDialog.toast("All Fields are Required...".tr);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
