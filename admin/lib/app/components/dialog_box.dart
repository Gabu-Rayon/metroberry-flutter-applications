// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';

class DialogBox {
  static void demoDialogBox() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Alert..!".tr,
            style: TextStyle(fontFamily: AppThemeData.bold, fontSize: 18, color: AppThemData.primaryBlack),
          ),
          content:  Text(
            "You have no right to add, edit and delete.".tr,
            style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 16, color: AppThemData.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.appColor),
              ),
            ),
          ],
        );
      },
    );
  }

  static void commonDialogBox({required BuildContext context, required String description, required VoidCallback? deleteOnPress}) {
    showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(
          "Are you sure?".tr,
          style: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 18,
            color: AppThemData.primaryBlack,
          ),
        ),
        content: Text(
          description,
          style: const TextStyle(
            fontFamily: AppThemeData.medium,
            fontSize: 16,
            color: AppThemData.textGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:  Text(
              'Cancel'.tr,
              style: const TextStyle(
                fontFamily: AppThemeData.medium,
                fontSize: 14,
                color: AppThemData.textBlack,
              ),
            ),
          ),
          TextButton(
            onPressed: deleteOnPress,
            child:  Text(
              'Delete'.tr,
              style: const TextStyle(
                fontFamily: AppThemeData.medium,
                fontSize: 14,
                color: AppThemData.red800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmationDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure?".tr,
            style: const TextStyle(
              fontFamily: AppThemeData.bold,
              fontSize: 18,
              color: AppThemData.textGrey,
            ),
          ),
          content: Text(
            "Do you really want to delete this data?".tr,
            style: const TextStyle(
              fontFamily: AppThemeData.medium,
              fontSize: 16,
              color: AppThemData.textGrey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false); // Return false when "No" is pressed
              },
              child: Text(
                'No'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemeData.bold,
                  color: AppThemData.textBlack,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true); // Return true when "Yes" is pressed
              },
              child: Text(
                'Yes'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemeData.bold,
                  color: AppThemData.textBlack,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false; // If the dialog is dismissed, return false
  }


}
