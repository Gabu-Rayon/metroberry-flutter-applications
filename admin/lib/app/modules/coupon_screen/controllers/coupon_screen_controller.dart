import 'package:admin/app/models/coupon_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/collection_name.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';

class CouponScreenController extends GetxController {

  final count = 0.obs;
  RxString title = "Coupon".tr.obs;
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  Rx<TextEditingController> couponTitleController = TextEditingController().obs;
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  Rx<TextEditingController> couponAmountController = TextEditingController().obs;
  Rx<TextEditingController> couponMinAmountController = TextEditingController().obs;
  Rx<TextEditingController> expireDateController = TextEditingController().obs;
  // var expireAt = DateTime.now().obs;
  DateTime selectedDate = DateTime.now();

  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  Rx<String> editingId = "".obs;

  RxString selectedAdminCommissionType = "Fix".obs;
  List<String> adminCommissionType = ["Fix", "Percentage"];

  RxString couponPrivateTyep = "Public".obs;
  List<String> couponType = ["Private", "Public"];

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      expireDateController.value.text = selectedDate.toString();
    }
  }

  getData() async {
    try {
      isLoading.value = true;
      couponList.clear();
      List<CouponModel> data = await FireStoreUtils.getCoupon();
      couponList.addAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  addCoupon() async {
    isLoading = true.obs;
    await FireStoreUtils.addCoupon(CouponModel(
      id: Constant.getRandomString(20),
      active: isActive.value,
      minAmount: couponMinAmountController.value.text,
      title: couponTitleController.value.text,
      code: couponCodeController.value.text,
      amount: couponAmountController.value.text,
      isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
      isPrivate: couponPrivateTyep.value == "Public" ? false : true,
      expireAt: Timestamp.fromDate(selectedDate),
    ));

    await getData();
    isLoading = false.obs;
  }

  updateCoupon() async {
    isEditing = true.obs;
    await FireStoreUtils.updateCoupon(CouponModel(
      id: editingId.value,
      active: isActive.value,
      minAmount: couponMinAmountController.value.text,
      title: couponTitleController.value.text,
      code: couponCodeController.value.text,
      amount: couponAmountController.value.text,
      isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
      isPrivate: couponPrivateTyep.value == "Public" ? false : true,
      expireAt: Timestamp.fromDate(selectedDate),
    ));
    await getData();
    // int indexToUpdate = couponList.indexWhere((coupon) => coupon.id == editingId.value);
    // if (indexToUpdate != -1) {
    //   // Update the coupon at the found index
    //   couponList[indexToUpdate] = CouponModel(
    //     id: editingId.value,
    //     active: isActive.value,
    //     minAmount: couponMinAmountController.value.text,
    //     title: couponTitleController.value.text,
    //     code: couponCodeController.value.text,
    //     amount: couponAmountController.value.text,
    //   );
    // }
    isEditing = false.obs;
  }

  removeCoupon(CouponModel couponModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).delete().then((value) {
      ShowToastDialog.toast("Coupon deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Coupon went wrong".tr);
    });
    await getData();
    isLoading = false.obs;
  }

  setDefaultData() {
    couponTitleController.value.text = '';
    couponCodeController.value.text = '';
    couponMinAmountController.value.text = '';
    couponAmountController.value.text = '';
    expireDateController.value.text = '';
    isActive.value = false;
    isEditing.value = false;
  }
}
