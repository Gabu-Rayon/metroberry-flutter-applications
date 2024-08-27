import 'dart:io';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DriverScreenController extends GetxController {
  RxString title = "Driver".tr.obs;


  RxBool isLoading = true.obs;
  RxBool isSearchEnable = true.obs;

  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Name",
    "Phone",
    "Email",
  ];

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<DriverUserModel> currentPageDriver = <DriverUserModel>[].obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<File> imagePath = File('').obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;
  RxString editingId = ''.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getUser();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  getSearchType() async {
    isLoading.value = true;
    if (selectedSearchType.value == "Phone") {
      selectedSearchTypeForData.value = "phoneNumber";
    } else if (selectedSearchType.value == "Email") {
      selectedSearchTypeForData.value = "email";
    } else {
      selectedSearchTypeForData.value = "slug";
    }
    isLoading.value = false;
  }

  removeDriver(DriverUserModel driverUserModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(driverUserModel.id).delete().then((value) {
      ShowToastDialog.toast("Driver deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverUserModel.id).delete().then((value) {
      log("Verify Document Deleted...!");
    }).catchError((error) {
      log("Error : $error");
    });
    isLoading = false.obs;
  }

  getUser() async {
    isLoading.value = true;
    await FireStoreUtils.countDrivers();
    // tempList.value = await FireStoreUtils.getDriver();
    // driverList.value = await FireStoreUtils.getDriver();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength! ? Constant.driverLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<DriverUserModel> currentPageDriverData = await FireStoreUtils.getDriver(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value);
        currentPageDriver.value = currentPageDriverData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }
  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (driverList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > driverList.length ? driverList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageDriver.value = driverList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return Constant.driverLength!;
    } else {
      return int.parse(data);
    }
  }

  getArgument(DriverUserModel driverUserModel) {
    driverModel.value = driverUserModel;
    userNameController.value.text = driverModel.value.fullName!;
    phoneNumberController.value.text = "${driverModel.value.countryCode!} ${driverModel.value.phoneNumber!}";
    emailController.value.text = driverModel.value.email!;
    imageController.value.text = driverModel.value.profilePic!;
    editingId.value = driverModel.value.id!;
  }

  pickPhoto() async {
    try {
      uploading.value = true;
      ImagePicker picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      File imageFile = File(img!.path);

      imageController.value.text = img.name;
      imagePath.value = imageFile;
      imagePickedFileBytes.value = await img.readAsBytes();
      mimeType.value = "${img.mimeType}";
      uploading.value = false;
    } catch (e) {
      uploading.value = false;
    }
  }
}
