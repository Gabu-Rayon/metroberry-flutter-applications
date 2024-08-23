// ignore_for_file: depend_on_referenced_packages

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/modules/admin_profile/controllers/admin_profile_controller.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../widget/global_widgets.dart';
import '../../../../widget/text_widget.dart';
import '../../../utils/app_them_data.dart';

class ChangePasswordWidget extends StatelessWidget {
  AdminProfileController adminProfileController;
  ChangePasswordWidget({super.key, required this.adminProfileController});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:  themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      ),
      child: Form(
        key: adminProfileController.changePasswordFromKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextCustom(title: adminProfileController.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
              ],
            ),
            spaceH(height: 25),
            CustomTextFormField(
              // width: ScreenSize.width(30, context),
              title: "Old Password *".tr,
              hintText: "Enter old password".tr,
              // validator: (value) => value != null && value.isNotEmpty ? null : 'old password required',
              controller: adminProfileController.oldPasswordController.value,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              // width: ScreenSize.width(30, context),
              title: "New Password *".tr,
              hintText: "Enter new password".tr,
              // validator: (value) => value != null && value.isNotEmpty ? null : 'please enter new password',
              controller: adminProfileController.newPasswordController.value,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              // width: ScreenSize.width(30, context),
              title: "Confirm New Password *".tr,
              hintText: "Enter confirm new password ".tr,
              // validator: (value) => value != null && value.isNotEmpty ? null : 'please enter confirm new password',
              controller: adminProfileController.confirmPasswordController.value,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: ScreenSize.width(100, context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    buttonTitle: "Update".tr,
                    onPress: () async {
                      if (Constant.isDemo) {
                        DialogBox.demoDialogBox();
                      } else {
                        if (adminProfileController.changePasswordFromKey.currentState!.validate()) {
                          await adminProfileController.setAdminPassword();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
