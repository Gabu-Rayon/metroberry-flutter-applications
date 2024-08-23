import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/brand_model.dart';
import 'package:admin/app/models/model_vehicle_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class VehicleModelScreenController extends GetxController {
  RxString title = "Vehicle Model".tr.obs;


  RxBool isLoading = true.obs;
  RxList<ModelVehicleModel> vehicleModelList = <ModelVehicleModel>[].obs;
  RxList<ModelVehicleModel> tempList = <ModelVehicleModel>[].obs;
  Rx<ModelVehicleModel> modelVehicleModel = ModelVehicleModel().obs;
  RxList<BrandModel> vehicleBrandList = <BrandModel>[].obs;
  Rx<BrandModel> selectedVehicleBrand = BrandModel().obs;
  Rx<String> vehicleBrandId = "".obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<ModelVehicleModel> currentPageVehicleModel = <ModelVehicleModel>[].obs;

  Rx<TextEditingController> titleController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isEnable = false.obs;

  @override
  Future<void> onInit() async {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    vehicleBrandList.value = await FireStoreUtils.getVehicleBrandAllData();
    getVehicleModel();
    super.onInit();
  }

  getVehicleModel() async {
    isLoading.value = true;
    await FireStoreUtils.countVehicleModel();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (vehicleModelList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > vehicleModelList.length ? vehicleModelList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageVehicleModel.value = vehicleModelList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.vehicleModelLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.vehicleModelLength! ? Constant.vehicleModelLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<ModelVehicleModel> currentPageVehicleModelData =
            await FireStoreUtils.getVehicleModel(currentPage.value, itemPerPage, selectedVehicleBrand.value.id != null ? selectedVehicleBrand.value.id.toString() : "");
        currentPageVehicleModel.value = currentPageVehicleModelData;
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
      return vehicleModelList.length;
    } else {
      return int.parse(data);
    }
  }

  setDefaultData() {
    titleController.value.text = "";
    vehicleBrandId.value = "";
    isEnable.value = false;
    isEditing.value = false;
    selectedVehicleBrand.value = BrandModel();
  }

  updateVehicleModel() async {
    modelVehicleModel.value.id = modelVehicleModel.value.id;
    modelVehicleModel.value.brandId = vehicleBrandId.value ;
    modelVehicleModel.value.isEnable = isEnable.value;
    modelVehicleModel.value.title = titleController.value.text;
    await FireStoreUtils.updateVehicleModel(modelVehicleModel.value);
    await getVehicleModel();
  }

  addVehicleModel() async {
    modelVehicleModel.value.id = Constant.getRandomString(20);
    modelVehicleModel.value.brandId = vehicleBrandId.value;
    modelVehicleModel.value.isEnable = isEnable.value;
    modelVehicleModel.value.title = titleController.value.text;
    await FireStoreUtils.addVehicleModel(modelVehicleModel.value);
    await getVehicleModel();
  }

  removeVehicleModel(ModelVehicleModel modelVehicleModel) async {
    await FirebaseFirestore.instance.collection(CollectionName.vehicleModel).doc(modelVehicleModel.id).delete().then((value) {
      ShowToastDialog.toast("Model deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
  }
}
