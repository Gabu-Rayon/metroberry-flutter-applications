import 'dart:developer';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/wallet_transaction_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';

class PassengersDetailScreenController extends GetxController {
  RxString title = "Users Detail".tr.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  Rx<TextEditingController> topupController = TextEditingController().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxList<WalletTransactionModel> currentPageWalletTransaction = <WalletTransactionModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<BookingModel> currentPageBooking = <BookingModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  RxString selectedPayoutStatus = "All".obs;
  RxString selectedPayoutStatusForData = "All".obs;
  List<String> payoutStatus = [
    "All",
    "Place",
    "Complete",
    "Rejected",
    "Cancelled",
    "Accepted",
    "OnGoing",
  ];

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    super.onInit();
  }

  getData() async {
    await getArgument();
    log("==============>${userModel.value.id}");
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    await getBookings();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    await getWalletTransactions();
    isLoading.value = false;
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
    } else {
      Get.offAllNamed(Routes.ERROR_SCREEN);
    }
    isLoading.value = false;
  }

  getBookingDataForConverter() async {
    print('get in booking user status ${selectedPayoutStatus.value}');
    if (selectedPayoutStatus.value == "Rejected") {
      selectedPayoutStatusForData.value = "booking_rejected";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Place") {
      selectedPayoutStatusForData.value = "booking_placed";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Complete") {
      selectedPayoutStatusForData.value = "booking_completed";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Cancelled") {
      selectedPayoutStatusForData.value = 'booking_cancelled';
      await getBookings();
    } else if (selectedPayoutStatus.value == "Accepted") {
      selectedPayoutStatusForData.value = 'booking_accepted';
      await getBookings();
    } else if (selectedPayoutStatus.value == "OnGoing") {
      selectedPayoutStatusForData.value = 'booking_ongoing';
      await getBookings();
    } else {
      // booking_accepted
      selectedPayoutStatusForData.value = "All";
      await getBookings();
    }
  }

  removeBooking(BookingModel bookingModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.bookings).doc(bookingModel.id).delete().then((value) {
      ShowToastDialog.toast("Booking deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  getBookings() async {
    isLoading.value = true;
    bookingList.value = await FireStoreUtils.getBookingByUserId(selectedPayoutStatusForData.value, userModel.value.id);
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (bookingList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > bookingList.length ? bookingList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageBooking.value = bookingList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return bookingList.length;
    } else {
      return int.parse(data);
    }
  }

  completeOrder(String transactionId) async {
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: topupController.value.text,
        createdDate: Timestamp.now(),
        paymentType: "admin",
        transactionId: transactionId,
        userId: userModel.value.id!,
        isCredit: true,
        type: "customer",
        note: "Wallet Top up by admin");
    ShowToastDialog.showLoader("Please wait".tr);
    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateUserWallet(amount: topupController.value.text, userId: userModel.value.id!).then((value) async {});
      }
    });
    ShowToastDialog.closeLoader();
    userModel.value = (await FireStoreUtils.getUserByUserID(userModel.value.id!))!;
    Get.back();
    ShowToastDialog.toast("Amount added in your wallet.");
  }

  getWalletTransactions() async {
    await FireStoreUtils.getWalletTransactionOfUser(userModel.value.id!).then((value) {
      walletTransactionList.value = value ?? [];
      setPaginationForTransactionHistory(totalItemPerPage.value);
    });
  }

  setDefaultData() {
    currentPage = 1.obs;
    startIndex = 1.obs;
    endIndex = 1.obs;
    totalPage = 1.obs;
  }

  setPaginationForTransactionHistory(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (walletTransactionList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > walletTransactionList.length ? walletTransactionList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageWalletTransaction.value = walletTransactionList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }
}
