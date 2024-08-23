import 'dart:io';

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/banner_screen_controller.dart';

class BannerScreenView extends GetView<BannerScreenController> {
  const BannerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<BannerScreenController>(
      init: BannerScreenController(),
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: paddingEdgeInsets(),
                      child: ContainerCustom(
                        child: controller.isLoading.value
                            ? Padding(
                                padding: paddingEdgeInsets(),
                                child: Constant.loader(),
                              )
                            : Column(children: [
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
                                                  child:
                                                      TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                              const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                              TextCustom(
                                                  title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                            ])
                                          ]),
                                          CustomButtonWidget(
                                            padding: const EdgeInsets.symmetric(horizontal: 22),
                                            buttonTitle: " + Add Banner".tr,
                                            borderRadius: 10,
                                            onPress: () {
                                              controller.setDefaultData();
                                              showDialog(context: context, builder: (context) => const BannerDialog());
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
                                                  child:
                                                      TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                              const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                              TextCustom(
                                                  title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                            ])
                                          ]),
                                          spaceH(),
                                          CustomButtonWidget(
                                            width: MediaQuery.sizeOf(context).width * 0.7,
                                            padding: const EdgeInsets.symmetric(horizontal: 22),
                                            buttonTitle: " + Add Banner".tr,
                                            borderRadius: 10,
                                            onPress: () {
                                              controller.setDefaultData();
                                              showDialog(context: context, builder: (context) => const BannerDialog());
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
                                        : controller.bannerList.isEmpty
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
                                                      columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 15 : MediaQuery.of(context).size.width * 0.05),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Banner Image".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Banner Name".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.14),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Banner Description".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.20),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Banner Offer".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Actions".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.08),
                                                ],
                                                rows: controller.bannerList
                                                    .map((bannerModel) => DataRow(cells: [
                                                          DataCell(TextCustom(title: "${controller.bannerList.indexWhere((element) => element == bannerModel) + 1}")),
                                                          DataCell(
                                                            Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: NetworkImageWidget(
                                                                imageUrl: '${bannerModel.image}',
                                                                borderRadius: 10,
                                                                height: 40,
                                                                width: 100,
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(TextCustom(title: bannerModel.bannerName ?? "N/A".tr)),
                                                          DataCell(TextCustom(
                                                            title: bannerModel.bannerDescription ?? "N/A".tr,
                                                            maxLine: 2,
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: bannerModel.offerText == "" ? "N/A".tr : bannerModel.offerText.toString(),
                                                            maxLine: 2,
                                                          )),
                                                          DataCell(
                                                            Transform.scale(
                                                              scale: 0.8,
                                                              child: CupertinoSwitch(
                                                                activeColor: AppThemData.primary500,
                                                                value: bannerModel.isEnable!,
                                                                onChanged: (value) async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    bannerModel.isEnable = value;
                                                                    await FireStoreUtils.updateBanner(bannerModel);
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
                                                                      controller.bannerName.value.text = bannerModel.bannerName!;
                                                                      controller.bannerDescription.value.text = bannerModel.bannerDescription!;
                                                                      controller.bannerImageName.value.text = bannerModel.image!;
                                                                      controller.bannerModel.value.id = bannerModel.id!;
                                                                      controller.isEditing.value = true;
                                                                      controller.imageURL.value = bannerModel.image!;
                                                                      controller.isOfferBanner.value = bannerModel.isOfferBanner!;
                                                                      controller.offerText.value.text = bannerModel.offerText!;
                                                                      showDialog(context: context, builder: (context) => const BannerDialog());
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
                                                                        // controller.removeBanner(bannerModel);
                                                                        // controller.getData();
                                                                        bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                        if (confirmDelete) {
                                                                          await controller.removeBanner(bannerModel);
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
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BannerDialog extends StatelessWidget {
  const BannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<BannerScreenController>(
      init: BannerScreenController(),
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
                    "✍ Edit your Banner here".tr,
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
                                  controller.bannerImageName.value.text = img.name;
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
                                  controller.bannerImageName.value.text = img.name;
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
              child: CustomTextFormField(title: "Title".tr, hintText: "Enter Title".tr, controller: controller.bannerName.value),
            ),
            spaceH(),
            SizedBox(
              child: CustomTextFormField(
                title: " Description".tr,
                hintText: "Enter  Description".tr,
                controller: controller.bannerDescription.value,
                maxLine: 3,
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    TextCustom(
                      title: 'OfferBanner'.tr,
                      fontSize: 12,
                    ),
                    spaceH(height: 10),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeColor: AppThemData.primary500,
                        value: controller.isOfferBanner.value,
                        onChanged: (value) {
                          controller.isOfferBanner.value = value;
                        },
                      ),
                    ),
                    spaceH(height: 16),
                  ],
                ),
                spaceW(width: 16),
                Expanded(
                    child: Visibility(
                        visible: controller.isOfferBanner.value == true,
                        child: CustomTextFormField(hintText: 'Enter offer Text'.tr, controller: controller.offerText.value, title: 'Offer Text *'.tr))),
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
                      if (controller.bannerName.value.text.isNotEmpty &&
                          controller.bannerImageName.value.text.isNotEmpty &&
                          controller.bannerDescription.value.text.isNotEmpty) {
                        controller.isEditing.value ? controller.isEditing(true) : controller.isLoading(true);
                        controller.isEditing.value ? controller.updateBanner(context) : controller.addBanner(context);
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

enum SideAt { isOneSide, isTwoSide }
