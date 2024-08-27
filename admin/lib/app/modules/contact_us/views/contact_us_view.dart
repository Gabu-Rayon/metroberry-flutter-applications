import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ContactUsController>(
      init: ContactUsController(),
      builder: (controller) {
        return Padding(
          padding: paddingEdgeInsets(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContainerCustom(
                child: Column(
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
                        ),
                      ],
                    ),
                    spaceH(height: 20),
                    Container(
                      padding: paddingEdgeInsets(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(title: "Email Subject *".tr, hintText: "Enter email subject".tr, controller: controller.emailSubjectController.value),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextFormField(title: "Email *".tr, hintText: "Enter email".tr, controller: controller.emailController.value),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                    title: "Phone Number*".tr,
                                    hintText: "Enter phone number".tr,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[0-9,+]')),
                                    ],
                                    controller: controller.phoneNumberController.value),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(title: "Address *".tr, hintText: "Enter address".tr, controller: controller.addressController.value),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              CustomButtonWidget(
                                  buttonTitle: "Save".tr,
                                  onPress: () async {
                                    if (Constant.isDemo) {
                                      DialogBox.demoDialogBox();
                                    } else {
                                      controller.setContactData();
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
