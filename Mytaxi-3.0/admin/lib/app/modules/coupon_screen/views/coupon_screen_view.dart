import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../widget/common_ui.dart';
import '../../../../widget/global_widgets.dart';
import '../../../../widget/text_widget.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_them_data.dart';
import '../../../utils/dark_theme_provider.dart';
import '../../../utils/responsive.dart';
import '../controllers/coupon_screen_controller.dart';

class CouponScreenView extends GetView<CouponScreenController> {
  const CouponScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CouponScreenController>(
      init: CouponScreenController(),
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
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},

              Expanded(
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerCustom(
                          child: Column(
                            children: [
                              ResponsiveWidget.isDesktop(context) ?
                              Row(
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
                                    buttonTitle: "+ Add Coupon".tr,
                                    borderRadius: 10,
                                    onPress: () {
                                      controller.setDefaultData();
                                      showDialog(context: context, builder: (context) => const CouponDialog());
                                    },
                                  ),
                                ],
                              ) :  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    width: MediaQuery.sizeOf(context).width *0.7,
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    buttonTitle: "+ Add Coupon".tr,
                                    borderRadius: 10,
                                    onPress: () {
                                      controller.setDefaultData();
                                      showDialog(context: context, builder: (context) => const CouponDialog());
                                    },
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              Obx(
                                    () =>
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: controller.isLoading.value
                                              ? Padding(
                                            padding: paddingEdgeInsets(),
                                            child: Constant.loader(),
                                          )
                                              : controller.couponList.isEmpty
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
                                                  columnTitle: "Title".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.15),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Code".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.08),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Expire".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.10),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Active".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.03),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Coupon Type".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.09),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Commission Type".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.07),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "MinAmount".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 85 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.05),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Amount".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.05),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Actions".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.05),
                                            ],
                                            rows: controller.couponList
                                                .map((couponModel) =>
                                                DataRow(cells: [
                                                  DataCell(TextCustom(title: couponModel.title.toString())),
                                                  DataCell(TextCustom(title: couponModel.code.toString())),
                                                  DataCell(TextCustom(title: Constant.timestampToDate(couponModel.expireAt!))),
                                                  DataCell(
                                                    Transform.scale(
                                                      scale: 0.8,
                                                      child: CupertinoSwitch(
                                                        activeColor: AppThemData.primary500,
                                                        value: couponModel.active!,
                                                        onChanged: (value) async {
                                                          if (Constant.isDemo) {
                                                            DialogBox.demoDialogBox();
                                                          } else {
                                                            couponModel.active = value;
                                                            await FireStoreUtils.updateCoupon(couponModel);
                                                            controller.getData();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(TextCustom(title: couponModel.isFix == true ? 'Fix'.tr : 'Percentage'.tr)),
                                                  DataCell(TextCustom(title: couponModel.isPrivate == true ? 'Private'.tr : 'Public'.tr)),
                                                  DataCell(TextCustom(title: couponModel.minAmount.toString())),
                                                  DataCell(TextCustom(title: couponModel.amount.toString())),
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
                                                              controller.couponTitleController.value.text = couponModel.title!;
                                                              controller.couponCodeController.value.text = couponModel.code!;
                                                              controller.couponMinAmountController.value.text = couponModel.minAmount!;
                                                              controller.couponAmountController.value.text = couponModel.amount!;
                                                              controller.isActive.value = couponModel.active!;
                                                              controller.editingId.value = couponModel.id!;
                                                              controller.selectedAdminCommissionType.value = couponModel.isFix == true ? 'Fix' : 'Percentage';
                                                              controller.couponPrivateTyep.value = couponModel.isPrivate == true ? 'Private' : 'Public';
                                                              controller.expireDateController.value.text = Constant.timestampToDate(couponModel.expireAt!);

                                                              showDialog(context: context, builder: (context) => const CouponDialog());
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
                                                                // controller.removeCoupon(couponModel);
                                                                bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                if (confirmDelete) {
                                                                  controller.removeCoupon(couponModel);
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
                                                .toList(),
                                          )),
                                    ),
                              )
                            ],
                          ),
                        )
                        // Your widgets here
                      ],
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

class CouponDialog extends StatelessWidget {
  const CouponDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CouponScreenController>(
      init: CouponScreenController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: CustomDialog(
            title: controller.title.value,
            widgetList: [
              Column(
                children: [
                  CustomTextFormField(hintText: 'Enter Coupon Title'.tr, controller: controller.couponTitleController.value, title: 'Title'.tr),
                  spaceH(),
                  CustomTextFormField(hintText: 'Enter Coupon Code'.tr, controller: controller.couponCodeController.value, title: 'Code'.tr),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(
                          child:
                          CustomTextFormField(hintText: 'Enter Minimum Amount'.tr, controller: controller.couponMinAmountController.value, title: 'Minimum Amount'.tr)),
                      spaceW(),
                      Expanded(child: CustomTextFormField(hintText: 'Enter Amount'.tr, controller: controller.couponAmountController.value, title: 'Amount'.tr)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              maxLine: 1,
                              title: "Commission Type".tr,
                              fontFamily: AppThemeData.medium,
                              fontSize: 12,
                            ),
                            spaceH(),
                            Obx(
                                  () =>
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                    ),
                                    hint: TextCustom(title: 'Select Commission Type'.tr),
                                    onChanged: (String? taxType) {
                                      controller.selectedAdminCommissionType.value = taxType ?? "Fix";
                                    },
                                    value: controller.selectedAdminCommissionType.value,
                                    items: controller.adminCommissionType.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: TextCustom(
                                          title: value,
                                          fontFamily: AppThemeData.regular,
                                          fontSize: 16,
                                        ),
                                      );
                                    }).toList(),
                                    decoration: Constant.DefaultInputDecoration(context),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      spaceW(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              maxLine: 1,
                              title: "Coupon Type".tr,
                              fontFamily: AppThemeData.medium,
                              fontSize: 12,
                            ),
                            spaceH(),
                            Obx(
                                  () =>
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                    ),
                                    hint: TextCustom(title: 'Select Coupon Type'.tr),
                                    onChanged: (String? couponType) {
                                      controller.couponPrivateTyep.value = couponType ?? "Public".tr;
                                    },
                                    value: controller.couponPrivateTyep.value,
                                    items: controller.couponType.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: TextCustom(
                                          title: value,
                                          fontFamily: AppThemeData.regular,
                                          fontSize: 16,
                                        ),
                                      );
                                    }).toList(),
                                    decoration: Constant.DefaultInputDecoration(context),
                                  ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  spaceH(),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceH(),
                            CustomTextFormField(
                                onPress: () {
                                  controller.selectDate(context);
                                },
                                hintText: 'Select coupon expire date'.tr,
                                controller: controller.expireDateController.value,
                                title: 'Coupon Expire Date'.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              spaceH(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
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
                    if (controller.couponTitleController.value.text.isNotEmpty &&
                        controller.couponCodeController.value.text.isNotEmpty &&
                        controller.couponMinAmountController.value.text.isNotEmpty &&
                        controller.couponAmountController.value.text.isNotEmpty &&
                        controller.expireDateController.value.text.isNotEmpty) {
                      controller.isEditing.value ? controller.updateCoupon() : controller.addCoupon();
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
          ),
        );
      },
    );
  }
}
