import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

class CancelingReasonController extends GetxController {
  RxString title = "Canceling Reason".tr.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxString editingValue = "".obs;
  RxList<String> cancelingReasonList = <String>[].obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    cancelingReasonList.value = await FireStoreUtils.getCancelingReason();
    isLoading(false);
  }

  setDefaultData() {
    reasonController.value.text = "";
    editingValue.value = "";
    isEditing.value = false;
    isLoading.value = false;
  }

  updateReason() async {
    isEditing.value = true;
    cancelingReasonList[cancelingReasonList.indexWhere((element) => element == editingValue.value)] = reasonController.value.text;
    await FireStoreUtils.addCancelingReason(cancelingReasonList);
    setDefaultData();
    isEditing.value = false;
  }

  removeReason(String reason) async {
    isLoading.value = true;
    cancelingReasonList.remove(reason);
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("canceling_reason").set(<String, List<String>>{"reasons": cancelingReasonList}).then((value) {
      ShowToastDialog.toast("Canceling Reason Deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    setDefaultData();
    isLoading.value = false;
  }

  addReason() async {
    isLoading.value = true;
    cancelingReasonList.add(reasonController.value.text);
    await FireStoreUtils.addCancelingReason(cancelingReasonList);
    setDefaultData();
    isLoading.value = false;
  }
}
