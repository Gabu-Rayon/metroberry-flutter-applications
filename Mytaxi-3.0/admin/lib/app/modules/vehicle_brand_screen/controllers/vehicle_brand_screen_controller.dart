import 'dart:developer';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/brand_model.dart';
import 'package:admin/app/models/model_vehicle_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleBrandScreenController extends GetxController {
  RxString title = "Vehicle Brand".tr.obs;

  RxBool isLoading = true.obs;
  RxList<BrandModel> vehicleBrandList = <BrandModel>[].obs;
  Rx<BrandModel> vehicleBrandModel = BrandModel().obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<BrandModel> currentPageVehicleBrand = <BrandModel>[].obs;

  Rx<TextEditingController> titleController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isEnable = false.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getBrand();
    super.onInit();
  }

  getBrand() async {
    isLoading.value = true;
    await FireStoreUtils.countVehicleBrand();

    // vehicleBrandList.value = await FireStoreUtils.getVehicleBrand();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (vehicleBrandList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > vehicleBrandList.length ? vehicleBrandList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageVehicleBrand.value = vehicleBrandList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }
  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.vehicleBrandLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.vehicleBrandLength! ? Constant.vehicleBrandLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<BrandModel> currentPageVehicleBrandData = await FireStoreUtils.getVehicleBrand(currentPage.value, itemPerPage);
        currentPageVehicleBrand.value = currentPageVehicleBrandData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return vehicleBrandList.length;
    } else {
      return int.parse(data);
    }
  }

  setDefaultData() {
    titleController.value.text = "";

    isEnable.value = false;
    isEditing.value = false;
  }

  updateBrand() async {
    vehicleBrandModel.value.id = vehicleBrandModel.value.id;
    vehicleBrandModel.value.isEnable = isEnable.value;
    vehicleBrandModel.value.title = titleController.value.text;

    await FireStoreUtils.addVehicleBrand(vehicleBrandModel.value);
    await getBrand();
  }

  addBrand() async {
    vehicleBrandModel.value.id = Constant.getRandomString(20);
    vehicleBrandModel.value.isEnable = isEnable.value;
    vehicleBrandModel.value.title = titleController.value.text;

    await FireStoreUtils.addVehicleBrand(vehicleBrandModel.value);
    await getBrand();
  }

  removeBrand(BrandModel vehicleBrandModel) async {
    await FirebaseFirestore.instance.collection(CollectionName.vehicleModel).where("brandId", isEqualTo: vehicleBrandModel.id).get().then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance.collection(CollectionName.vehicleModel).doc(ModelVehicleModel.fromJson(element.data()).brandId).delete();
      }
    }).catchError((error) {
      log(error.toString());
    });
    await FirebaseFirestore.instance.collection(CollectionName.vehicleBrand).doc(vehicleBrandModel.id).delete().then(
      (value) {
        ShowToastDialog.toast("Brand deleted...!".tr);
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
  }
}
