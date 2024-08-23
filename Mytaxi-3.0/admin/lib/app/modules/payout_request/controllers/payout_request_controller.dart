import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/payout_request_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayoutRequestController extends GetxController {
  RxString title = "Payout Request".tr.obs;


  RxBool isLoading = true.obs;
  // RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<WithdrawModel> payoutRequestList = <WithdrawModel>[].obs;
  // RxList<BookingModel> tempList = <BookingModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<WithdrawModel> currentPayoutRequest = <WithdrawModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminNoteController = TextEditingController().obs;

  RxString userSelectedPaymentStatus = "Pending".obs;
  List<String> paymentStatusType = ["Pending", "Complete", "Rejected"];
  RxString selectedPayoutStatus = "All".obs;
  List<String> payoutStatus = [
    "All",
    "Pending",
    "Complete",
    "Rejected",
  ];

  // RxString userSelectedPaymentStatus = "Pending".obs;
  // List<String> paymentStatusType = ["Place", "Pending", "Complete", "Rejected"];

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getPayoutRequest();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  getPayoutRequest() async {
    isLoading.value = true;
    // tempList.value = await FireStoreUtils.getBooking();
    // bookingList.value = await FireStoreUtils.getBooking();
    payoutRequestList.value = await FireStoreUtils.getPayoutRequest(status: selectedPayoutStatus.value);
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
    totalPage.value = (payoutRequestList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > payoutRequestList.length ? payoutRequestList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPayoutRequest.value = payoutRequestList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return payoutRequestList.length;
    } else {
      return int.parse(data);
    }
  }
}
