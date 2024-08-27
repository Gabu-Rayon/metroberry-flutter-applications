import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
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
import 'package:provider/provider.dart';

import '../../../../widget/common_ui.dart';
import '../../../routes/app_pages.dart';
import '../controllers/canceling_reason_controller.dart';

class CancelingReasonView extends GetView<CancelingReasonController> {
  const CancelingReasonView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CancelingReasonController>(
      init: CancelingReasonController(),
      builder: (controller) {
        return Obx(
          () => ContainerCustom(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
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
                      buttonTitle: " + Add Reason".tr,
                      onPress: () {
                        showDialog(context: context, builder: (context) => const AddReasonDialog());
                      },
                    ),
                  ],
                ),
                spaceH(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: controller.cancelingReasonList.isEmpty
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
                              CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 15 : MediaQuery.of(context).size.width * 0.07),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Reason".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.40),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.15),
                            ],
                            rows: controller.cancelingReasonList
                                .map((reasonModel) => DataRow(cells: [
                                      DataCell(TextCustom(title: "${controller.cancelingReasonList.indexWhere((element) => element == reasonModel) + 1}")),
                                      DataCell(TextCustom(title: reasonModel.toString())),
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
                                                  controller.editingValue.value = reasonModel.toString();
                                                  controller.reasonController.value.text = reasonModel.toString();
                                                  showDialog(context: context, builder: (context) => const AddReasonDialog());
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
                                                onTap: () {
                                                  if (Constant.isDemo) {
                                                    DialogBox.demoDialogBox();
                                                  } else {
                                                    controller.removeReason(reasonModel);
                                                    controller.getData();
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddReasonDialog extends StatelessWidget {
  const AddReasonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<CancelingReasonController>(
      init: CancelingReasonController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Row(
              children: [
                Expanded(child: CustomTextFormField(hintText: 'Enter Reason'.tr, controller: controller.reasonController.value, title: 'Reason *'.tr)),
              ],
            ),
          ],
          bottomWidgetList: [
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
                      if (controller.reasonController.value.text != "") {
                        controller.isEditing.value ? controller.updateReason() : controller.addReason();
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
          controller: controller,
        );
      },
    );
  }
}
