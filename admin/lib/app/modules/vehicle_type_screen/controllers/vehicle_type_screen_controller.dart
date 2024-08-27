import 'dart:io';

import 'package:admin/app/models/vehicle_type_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/collection_name.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';

class VehicleTypeScreenController extends GetxController {

  Rx<TextEditingController> vehicleTitle = TextEditingController().obs;
  Rx<TextEditingController> minimumCharge = TextEditingController().obs;
  Rx<TextEditingController> minimumChargeWithKm = TextEditingController().obs;
  Rx<TextEditingController> perKm = TextEditingController().obs;
  Rx<TextEditingController> person = TextEditingController().obs;

  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  Rx<TextEditingController> vehicleTypeImage = TextEditingController().obs;
  // Rx<VehicleTypeModel> vehicleTypeModel = VehicleTypeModel().obs;

  RxString title = "VehicleType".obs;
  RxBool isEnable = false.obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    vehicleTypeList.clear();
    List<VehicleTypeModel> data = await FireStoreUtils.getVehicleType();
    vehicleTypeList.addAll(data);

    isLoading(false);
  }

  setDefaultData() {
    vehicleTitle.value.text = "";
    minimumCharge.value.text = "";
    minimumChargeWithKm.value.text = "";
    vehicleTypeImage.value.clear();

    perKm.value.text = "";
    person.value.text = "";
    isEditing.value = false;
    imageFile.value = File('');
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
    isImageUpdated.value = false;
    imageURL.value = '';
  }

  updateVehicleType() async {
    isLoading = true.obs;
    String docId = editingId.value;
    String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "vehicleTyepImage", docId, mimeType.value);
    await FireStoreUtils.updateVehicleType(VehicleTypeModel(
        id: docId,
        image: url,
        isActive: isEnable.value,
        title: vehicleTitle.value.text,
        charges: Charges(fareMinimumChargesWithinKm: minimumChargeWithKm.value.text, farMinimumCharges: minimumCharge.value.text, farePerKm: perKm.value.text),
        persons: person.value.text));
    await getData();
    isLoading = false.obs;
  }

  addVehicleTyep() async {
    isLoading = true.obs;
    String docId = Constant.getRandomString(20);
    String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "vehicleTyepImage", docId, mimeType.value);

    FireStoreUtils.addVehicleType(VehicleTypeModel(
        id: docId,
        image: url,
        isActive: isEnable.value,
        title: vehicleTitle.value.text,
        charges: Charges(fareMinimumChargesWithinKm: minimumChargeWithKm.value.text, farMinimumCharges: minimumCharge.value.text, farePerKm: perKm.value.text),
        persons: person.value.text));
    await getData();
    isLoading = false.obs;
  }

  removeVehicleTypeModel(VehicleTypeModel vehicleTypeModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.vehicleType).doc(vehicleTypeModel.id).delete().then((value) {
      ShowToastDialog.toast("VehicleType deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await getData();
    isLoading = false.obs;
  }
}
