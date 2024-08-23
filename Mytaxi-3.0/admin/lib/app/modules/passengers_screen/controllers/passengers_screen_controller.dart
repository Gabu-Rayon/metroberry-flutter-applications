import 'dart:io';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/wallet_transaction_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class PassengersScreenController extends GetxController {
  RxString title = "Users".tr.obs;



  RxBool isLoading = true.obs;
  RxInt selectedGender = 1.obs;
  RxBool isSearchEnable = true.obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<UserModel> currentPageUser = <UserModel>[].obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Name",
    "Phone",
    "Email",
  ];

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

  removePassengers(UserModel userModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.users).doc(userModel.id).delete().then((value) {
      ShowToastDialog.toast("Passengers deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  getUser() async {
    isLoading.value = true;
    await FireStoreUtils.countUsers();
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
    totalPage.value = (Constant.usersLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.usersLength! ? Constant.usersLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<UserModel> currentPageUserData =
            await FireStoreUtils.getUsers(currentPage.value, itemPerPage, searchController.value.text.toSlug(delimiter: "-"), selectedSearchTypeForData.value);
        currentPageUser.value = currentPageUserData;
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
  //   totalPage.value = (userList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > userList.length ? userList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageUser.value = userList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.usersLength!;
    } else {
      return int.parse(data);
    }
  }

  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> walletAmountController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  RxString editingId = ''.obs;
  Rx<UserModel> userModel = UserModel().obs;

  Rx<File> imagePath = File('').obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;

  getArgument(UserModel usersModel) {
    userModel.value = usersModel;
    userNameController.value.text = userModel.value.fullName!;
    walletAmountController.value.text = userModel.value.walletAmount!;
    phoneNumberController.value.text = "${userModel.value.countryCode!} ${userModel.value.phoneNumber!}";
    emailController.value.text = userModel.value.email!;
    userModel.value.gender == "Male" ? selectedGender.value = 1 : selectedGender.value = 2;
    // addressController.value.text = userModel.value.address!;
    imageController.value.text = userModel.value.profilePic!;
    editingId.value = userModel.value.id!;
  }

  walletTopUp() async {
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: walletAmountController.value.text,
        createdDate: Timestamp.now(),
        paymentType: 'admin',
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userModel.value.id,
        isCredit: true,
        type: "customer",
        note: "Admin Top Up");

    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        ShowToast.successToast("Amount added to your wallet".tr);
        await FireStoreUtils.updateUserWallet(amount: walletAmountController.value.text, userId: userModel.value.id.toString()).then((value) async {
          await FireStoreUtils.getUserByUserID(userModel.value.id.toString()).then((value) {
            if (value != null) {
              userModel.value = value;
            }
          });
        });
      }
    });
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
