// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/notification_model.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  getNotification() async {
    await FireStoreUtils.getNotificationList().then((value) {
      if (value != null) {
        notificationList.addAll(value);
      }
    });
  }

  removeNotification(String id) async {
    await FirebaseFirestore.instance.collection(CollectionName.notification).doc(id).delete().then((value) {
      ShowToastDialog.showToast("Notification deleted successfully");
    }).catchError((error) {
      ShowToastDialog.showToast("Failed to delete notification, Try again after some time.");
    });
  }
}
