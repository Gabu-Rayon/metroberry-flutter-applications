import 'dart:io';

import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../../widget/common_ui.dart';
import '../../../../widget/global_widgets.dart';
import '../../../../widget/text_widget.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/dialog_box.dart';
import '../../../components/network_image_widget.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_them_data.dart';
import '../../../utils/dark_theme_provider.dart';
import '../../../utils/responsive.dart';
import '../controllers/vehicle_type_screen_controller.dart';

class VehicleTypeScreenView extends GetView<VehicleTypeScreenController> {
  const VehicleTypeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<VehicleTypeScreenController>(
      init: VehicleTypeScreenController(),
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
                              ResponsiveWidget.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            GestureDetector(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                            TextCustom(
                                                title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                          ])
                                        ]),
                                        CustomButtonWidget(
                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                          buttonTitle: "+ Add Vehicle Type".tr,
                                          borderRadius: 10,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const VehicleTypeDialog());
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            GestureDetector(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                            TextCustom(
                                                title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                          ])
                                        ]),
                                        spaceH(),
                                        CustomButtonWidget(
                                          width: MediaQuery.sizeOf(context).width * 0.7,
                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                          buttonTitle: "+ Add Vehicle Type".tr,
                                          borderRadius: 10,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const VehicleTypeDialog());
                                          },
                                        ),
                                      ],
                                    ),
                              spaceH(height: 20),
                              Obx(
                                () => SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: controller.isLoading.value
                                          ? Padding(
                                              padding: paddingEdgeInsets(),
                                              child: Constant.loader(),
                                            )
                                          : controller.vehicleTypeList.isEmpty
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
                                                        width: ResponsiveWidget.isMobile(context) ? 15 : MediaQuery.of(context).size.width * 0.08),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Vehicle type Image".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Minimum Charges".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "MiniCharges Within Km".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Per Km".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Active".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.03),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Persons".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.03),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Actions".tr,
                                                        width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.08),
                                                  ],
                                                  rows: controller.vehicleTypeList
                                                      .map((vehicleTypeModel) => DataRow(cells: [
                                                            DataCell(TextCustom(title: vehicleTypeModel.title.toString())),
                                                            DataCell(
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                child: NetworkImageWidget(
                                                                  imageUrl: vehicleTypeModel.image,
                                                                  borderRadius: 10,
                                                                  fit: BoxFit.contain,
                                                                  height: 40,
                                                                  width: 100,
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(TextCustom(title: vehicleTypeModel.charges.farMinimumCharges.toString())),
                                                            DataCell(TextCustom(title: vehicleTypeModel.charges.fareMinimumChargesWithinKm.toString())),
                                                            DataCell(TextCustom(title: vehicleTypeModel.charges.farePerKm.toString())),
                                                            DataCell(
                                                              Transform.scale(
                                                                scale: 0.8,
                                                                child: CupertinoSwitch(
                                                                  activeColor: AppThemData.primary500,
                                                                  value: vehicleTypeModel.isActive!,
                                                                  onChanged: (value) async {
                                                                    print('vehicle tyep status $value');
                                                                    print('vehicle tyep  get ${vehicleTypeModel.isActive!}');
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      vehicleTypeModel.isActive = value;
                                                                      await FireStoreUtils.updateVehicleType(vehicleTypeModel);
                                                                      controller.getData();
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(TextCustom(title: vehicleTypeModel.persons.toString())),
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
                                                                        controller.editingId.value = vehicleTypeModel.id;
                                                                        controller.imageURL.value = vehicleTypeModel.image;
                                                                        controller.editingId.value = vehicleTypeModel.id;
                                                                        controller.isEnable.value = vehicleTypeModel.isActive!;
                                                                        controller.minimumChargeWithKm.value.text = vehicleTypeModel.charges.fareMinimumChargesWithinKm;
                                                                        controller.minimumCharge.value.text = vehicleTypeModel.charges.farMinimumCharges;
                                                                        controller.perKm.value.text = vehicleTypeModel.charges.farePerKm;
                                                                        controller.vehicleTitle.value.text = vehicleTypeModel.title;
                                                                        controller.person.value.text = vehicleTypeModel.persons;
                                                                        controller.vehicleTypeImage.value.text = vehicleTypeModel.image;
                                                                        showDialog(context: context, builder: (context) => const VehicleTypeDialog());
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
                                                                          // controller.removeVehicleTypeModel(vehicleTypeModel);
                                                                          // controller.getData();
                                                                          bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                          if (confirmDelete) {
                                                                            await controller.removeVehicleTypeModel(vehicleTypeModel);
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
                                    )),
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

class VehicleTypeDialog extends StatelessWidget {
  const VehicleTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<VehicleTypeScreenController>(
      init: VehicleTypeScreenController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Visibility(
              visible: controller.isEditing.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "✍ Edit your VehicleType here".tr,
                    style: TextStyle(
                      fontFamily: AppThemeData.bold,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppThemData.primaryBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            controller.isEditing.value == true
                ? Container(
                    height: 0.18.sh,
                    width: 0.30.sw,
                    decoration: BoxDecoration(
                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            height: 0.18.sh,
                            width: 0.30.sw,
                            imageUrl: controller.imageFile.value.path.isEmpty ? controller.imageURL.value : controller.imageFile.value.path,
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                ImagePicker picker = ImagePicker();
                                final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                if (img != null) {
                                  File imageFile = File(img.path);
                                  controller.vehicleTypeImage.value.text = img.name;
                                  controller.imageFile.value = imageFile;
                                  controller.mimeType.value = "${img.mimeType}";
                                  controller.isImageUpdated.value = true;
                                }
                              }
                            },
                            child: controller.imageFile.value.path.isEmpty
                                ? const Icon(
                                    Icons.add,
                                    color: AppThemData.greyShade500,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 0.18.sh,
                    width: 0.30.sw,
                    decoration: BoxDecoration(
                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        if (controller.imageFile.value.path.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              height: 0.18.sh,
                              width: 0.30.sw,
                              imageUrl: controller.imageFile.value.path,
                            ),
                          ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                ImagePicker picker = ImagePicker();
                                final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                if (img != null) {
                                  File imageFile = File(img.path);
                                  controller.vehicleTypeImage.value.text = img.name;
                                  controller.imageFile.value = imageFile;
                                  controller.mimeType.value = "${img.mimeType}";
                                  controller.isImageUpdated.value = true;
                                }
                              }
                            },
                            child: controller.imageFile.value.path.isEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'upload image'.tr,
                                          style: const TextStyle(fontSize: 16, color: AppThemData.greyShade500, fontFamily: AppThemeData.medium),
                                          textAlign: TextAlign.center, // Center the text within the Expanded widget
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Icon(
                                        Icons.file_upload_outlined,
                                        color: AppThemData.greyShade500,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
            spaceH(height: 16),
            SizedBox(
              child: CustomTextFormField(title: "Title".tr, hintText: "Enter Title".tr, controller: controller.vehicleTitle.value),
            ),
            spaceH(),
            Row(
              children: [
                Expanded(
                    child: CustomTextFormField(
                  title: "Fare Minimum Charges".tr,
                  hintText: "Enter  MinimumCharges".tr,
                  controller: controller.minimumCharge.value,
                  maxLine: 1,
                )),
                spaceW(),
                Expanded(
                    child: CustomTextFormField(
                  title: "Fare MinCharges With Km".tr,
                  hintText: "Enter MinCharges With Km".tr,
                  controller: controller.minimumChargeWithKm.value,
                  maxLine: 1,
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CustomTextFormField(
                  title: "Fare Per Km".tr,
                  hintText: "Enter Fare Per Km".tr,
                  controller: controller.perKm.value,
                  maxLine: 1,
                )),
                spaceW(),
                Expanded(
                    child: CustomTextFormField(
                  title: "Person".tr,
                  hintText: "Enter Person".tr,
                  controller: controller.person.value,
                  maxLine: 1,
                )),
              ],
            ),
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
                        value: controller.isEnable.value,
                        onChanged: (value) {
                          controller.isEnable.value = value;
                        },
                      ),
                    ),
                    spaceH(height: 16),
                  ],
                ),
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
                      if (controller.vehicleTitle.value.text.isNotEmpty &&
                          controller.vehicleTypeImage.value.text.isNotEmpty &&
                          controller.minimumCharge.value.text.isNotEmpty &&
                          controller.minimumChargeWithKm.value.text.isNotEmpty &&
                          controller.perKm.value.text.isNotEmpty &&
                          controller.person.value.text.isNotEmpty) {
                        controller.isEditing.value ? controller.isEditing(true) : controller.isLoading(true);
                        controller.isEditing.value ? controller.updateVehicleType() : controller.addVehicleTyep();

                        Navigator.pop(context);
                      } else {
                        ShowToastDialog.toast("All Fields are Required...".tr);
                        controller.isLoading = false.obs;
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
