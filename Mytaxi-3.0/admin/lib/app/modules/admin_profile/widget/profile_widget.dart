// ignore_for_file: depend_on_referenced_packages

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/modules/admin_profile/controllers/admin_profile_controller.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  AdminProfileController adminProfileController;

  ProfileWidget({super.key, required this.adminProfileController});

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
        key: adminProfileController.profileFromKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextCustom(title: adminProfileController.profileTitle.value, fontSize: 20, fontFamily: AppThemeData.bold),
              ],
            ),
            Obx(
                  () =>
                  Row(
                    children: [
                      // adminProfileController.imagePath.value.path.isEmpty
                      //     ? NetworkImageWidget(
                      //         borderRadius: 60,
                      //         imageUrl: Constant.adminModel!.image.toString(),
                      //         height: 100,
                      //         width: 100,
                      //       )
                      //     : adminProfileController.uploading.value
                      //         ? const Center(child:  Constant.loader())
                      //         : ClipRRect(
                      //             borderRadius: BorderRadius.circular(60),
                      //             child: Image.memory(
                      //               adminProfileController.imagePickedFileBytes.value,
                      //               height: 100,
                      //               width: 100,
                      //             ),
                      //           ),
                      adminProfileController.imagePath.value.path.isEmpty
                          ? SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            NetworkImageWidget(
                              borderRadius: 60,
                              imageUrl: adminProfileController.imageController.value.text.toString(),
                              height: 100,
                              width: 100,
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: InkWell(
                                onTap: () {
                                  adminProfileController.pickPhoto();
                                },
                                child: const SizedBox(
                                    height: 30,
                                    width: 30,
                                    // decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.violet200),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                       color: AppThemData.greyShade500 ,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                          : adminProfileController.uploading.value
                          ? Center(child: Constant.loader())
                          : SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.memory(
                                adminProfileController.imagePickedFileBytes.value,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: InkWell(
                                onTap: () {
                                  adminProfileController.pickPhoto();
                                },
                                child: const SizedBox(
                                    height: 30,
                                    width: 30,
                                    // decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.violet200),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),
                      TextCustom(
                        title: "${Constant.adminModel!.name}",
                        // style: const TextStyle(fontSize: 16, color: AppColors.darkGrey10, fontFamily: AppThemeData.medium),
                      )
                    ],
                  ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: "Name *".tr,
                    hintText: "Enter admin name".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'admin name required'.tr,
                    controller: adminProfileController.nameController.value,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomTextFormField(
                    title: "Contact Number *".tr,
                    hintText: "Enter admin number".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'contact number required'.tr,
                    controller: adminProfileController.contactNumberController.value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: "Email *".tr,
                    hintText: "Enter admin email".tr,
                    validator: (value) => Constant.validateEmail(value),
                    controller: adminProfileController.emailController.value,
                  ),
                ),
                const SizedBox(width: 20),
                // Expanded(
                //   child: CustomTextFormField(
                //     readOnly: true,
                //     onTap: () async {
                //       adminProfileController.pickPhoto();
                //     },
                //     title: "Choose Profile Image",
                //     hintText: "Select profile image",
                //     validator: (value) => null,
                //     suffixIcon: Container(
                //         height: 41,
                //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //         margin: const EdgeInsets.only(right: 4, left: 4),
                //         decoration:  BoxDecoration(
                //           color: AppColors.lightGrey08,
                //             borderRadius: BorderRadius.circular(50)
                //         ),
                //         child: const Text(
                //           "Browse",
                //           style: TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey08),
                //         )),
                //     controller: adminProfileController.imageController.value,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  buttonTitle: "Update".tr,
                  onPress: () async {
                    if (Constant.isDemo) {
                      DialogBox.demoDialogBox();
                    } else {
                      if (adminProfileController.profileFromKey.currentState!.validate()) {
                        await adminProfileController.setAdminData();
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
