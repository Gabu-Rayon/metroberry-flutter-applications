import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/screen_size.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/general_setting_controller.dart';

class GeneralSettingView extends GetView<GeneralSettingController> {
  const GeneralSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<GeneralSettingController>(
      init: GeneralSettingController(),
      builder: (controller) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerCustom(
                child: Obx(
                  () => controller.isLoading.value
                      ?
                      // Constant.waitingLoader()
                      Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                    spaceH(height: 2),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            spaceH(height: 20),
                            // controller.isLoading.value ? Padding(
                            //   padding: paddingEdgeInsets(),
                            //   child: Constant.waitingLoader(),
                            // ) :
                            ResponsiveWidget.isDesktop(context) ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: paddingEdgeInsets(),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                              child: CustomTextFormField(
                                                maxLine: 1,
                                                title: "Google Map Key".tr,
                                                hintText: "Enter google map key".tr,
                                                obscureText: Constant.isDemo ? true : false,
                                                prefix: const Icon(Icons.key),
                                                controller: controller.googleMapKeyController.value,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                              child: CustomTextFormField(
                                                maxLine: 1,
                                                title: "Notification Sender Key".tr,
                                                hintText: "Enter notification server key".tr,
                                                obscureText: Constant.isDemo ? true : false,
                                                prefix: const Icon(Icons.key),
                                                suffix: const SizedBox(),
                                                controller: controller.notificationServerKeyController.value,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                controller.uploadFileUrl.value == ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(title: 'Upload JSON File'.tr, fontSize: 14),
                                                  Container(
                                                    height: 0.18.sh,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    decoration: BoxDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        if (controller.file.value.path.isNotEmpty)
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),

                                                            // Uncomment the following lines when implementing image upload
                                                            // child: CachedNetworkImage(
                                                            //   fit: BoxFit.cover,
                                                            //   height: 0.18.sh,
                                                            //   width: 0.30.sw,
                                                            //   imageUrl: controller.file.value.path,
                                                            // ),
                                                          ),
                                                        Center(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              await controller.pickJsonFile();
                                                            },
                                                            child: controller.file.value.path.isEmpty
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        'Upload File'.tr,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                                                                          fontFamily: AppThemeData.medium,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 12),
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
                                                ],
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(title: 'Upload JSON File'.tr, fontSize: 14),
                                                  Container(
                                                    height: 0.18.sh,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    decoration: BoxDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        if (controller.file.value.path.isNotEmpty)
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            // Uncomment the following lines when implementing image upload
                                                            // child: CachedNetworkImage(
                                                            //   fit: BoxFit.cover,
                                                            //   height: 0.18.sh,
                                                            //   width: 0.30.sw,
                                                            //   imageUrl: controller.file.value.path,
                                                            // ),
                                                          ),
                                                        InkWell(
                                                            onTap: () async {
                                                              controller.setDefaultData();

                                                              // await controller.pickJsonFile();
                                                            },
                                                            child: const Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Spacer(),
                                                                Padding(
                                                                  padding: EdgeInsets.all(10),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: AppThemData.greyShade500,
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Center(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // controller.launchURL();
                                                            },
                                                            child: SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child: Image.asset(
                                                                'assets/image/json.png',
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      ),
                                spaceH(height: 10),
                                // Visibility(
                                //   visible: controller.uploadFileUrl.value.isNotEmpty,
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                //     child: TextCustom(
                                //       title: '${controller.uploadFileUrl}', fontSize: 14, maxLine: 2,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            if (controller.googleMapKeyController.value.text.isNotEmpty && controller.notificationServerKeyController.value.text.isNotEmpty) {
                                              Constant.waitingLoader();
                                              Constant.constantModel!.googleMapKey = controller.googleMapKeyController.value.text;
                                              Constant.constantModel!.notificationServerKey = controller.notificationServerKeyController.value.text;
                                              if (controller.fileName.value.isNotEmpty) {
                                                await controller.uploadFile().then(
                                                  (value) {
                                                    Constant.constantModel!.jsonFileURL = value ?? '';
                                                  },
                                                );
                                              }
                                              FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                                Get.back();
                                                ShowToast.successToast("Information Saved".tr);
                                              });
                                            } else {
                                              ShowToast.errorToast("Please Add Information".tr);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ) : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: paddingEdgeInsets(),
                                  child: Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                            child: CustomTextFormField(
                                              maxLine: 1,
                                              title: "Google Map Key".tr,
                                              hintText: "Enter google map key".tr,
                                              obscureText: Constant.isDemo ? true : false,
                                              prefix: const Icon(Icons.key),
                                              controller: controller.googleMapKeyController.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                            child: CustomTextFormField(
                                              maxLine: 1,
                                              title: "Notification Sender Key".tr,
                                              hintText: "Enter notification server key".tr,
                                              obscureText: Constant.isDemo ? true : false,
                                              prefix: const Icon(Icons.key),
                                              suffix: const SizedBox(),
                                              controller: controller.notificationServerKeyController.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                controller.uploadFileUrl.value == ""
                                    ? Padding(
                                  padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(title: 'Upload JSON File'.tr, fontSize: 14),
                                            Container(
                                              height: 0.18.sh,
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                children: [
                                                  if (controller.file.value.path.isNotEmpty)
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),

                                                      // Uncomment the following lines when implementing image upload
                                                      // child: CachedNetworkImage(
                                                      //   fit: BoxFit.cover,
                                                      //   height: 0.18.sh,
                                                      //   width: 0.30.sw,
                                                      //   imageUrl: controller.file.value.path,
                                                      // ),
                                                    ),
                                                  Center(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await controller.pickJsonFile();
                                                      },
                                                      child: controller.file.value.path.isEmpty
                                                          ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Upload File'.tr,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                                                              fontFamily: AppThemeData.medium,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 12),
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
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                )
                                    : Padding(
                                  padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(title: 'Upload JSON File'.tr, fontSize: 14),
                                            Container(
                                              height: 0.18.sh,
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                children: [
                                                  if (controller.file.value.path.isNotEmpty)
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      // Uncomment the following lines when implementing image upload
                                                      // child: CachedNetworkImage(
                                                      //   fit: BoxFit.cover,
                                                      //   height: 0.18.sh,
                                                      //   width: 0.30.sw,
                                                      //   imageUrl: controller.file.value.path,
                                                      // ),
                                                    ),
                                                  InkWell(
                                                      onTap: () async {
                                                        controller.setDefaultData();

                                                        // await controller.pickJsonFile();
                                                      },
                                                      child: const Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: AppThemData.greyShade500,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // controller.launchURL();
                                                      },
                                                      child: SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child: Image.asset(
                                                          'assets/image/json.png',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                                spaceH(height: 10),
                                // Visibility(
                                //   visible: controller.uploadFileUrl.value.isNotEmpty,
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(23, 0, 10, 10),
                                //     child: TextCustom(
                                //       title: '${controller.uploadFileUrl}', fontSize: 14, maxLine: 2,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            if (controller.googleMapKeyController.value.text.isNotEmpty && controller.notificationServerKeyController.value.text.isNotEmpty) {
                                              Constant.waitingLoader();
                                              Constant.constantModel!.googleMapKey = controller.googleMapKeyController.value.text;
                                              Constant.constantModel!.notificationServerKey = controller.notificationServerKeyController.value.text;
                                              if (controller.fileName.value.isNotEmpty) {
                                                await controller.uploadFile().then(
                                                      (value) {
                                                    Constant.constantModel!.jsonFileURL = value ?? '';
                                                  },
                                                );
                                              }
                                              FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                                Get.back();
                                                ShowToast.successToast("Information Saved".tr);
                                              });
                                            } else {
                                              ShowToast.errorToast("Please Add Information".tr);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            spaceH(),
                          ],
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
