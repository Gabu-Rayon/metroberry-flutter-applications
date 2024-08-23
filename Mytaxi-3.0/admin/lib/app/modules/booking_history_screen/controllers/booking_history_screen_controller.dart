import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingHistoryScreenController extends GetxController {
  RxString title = "Booking History".obs;
  RxBool isLoading = true.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<BookingModel> currentPageBooking = <BookingModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  DateTime? startDate;
  DateTime? endDate;
  RxString selectedBookingStatus = "All".obs;
  RxString selectedBookingStatusForData = "All".obs;
  List<String> bookingStatus = [
    "All",
    "Place",
    "Complete",
    "Rejected",
    "Cancelled",
    "Accepted",
    "OnGoing",
  ];

  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0)))
      .obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getBookings();
    super.onInit();
  }

  getBookingDataByBookingStatus() async {
    isLoading.value = true;
    print('get in booking user status ${selectedBookingStatus.value}');
    if (selectedBookingStatus.value == "Rejected") {
      selectedBookingStatusForData.value = "booking_rejected";
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Place") {
      selectedBookingStatusForData.value = "booking_placed";
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Complete") {
      selectedBookingStatusForData.value = "booking_completed";
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Cancelled") {
      selectedBookingStatusForData.value = 'booking_cancelled';
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Accepted") {
      selectedBookingStatusForData.value = 'booking_accepted';
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "OnGoing") {
      selectedBookingStatusForData.value = 'booking_ongoing';
      await FireStoreUtils.countStatusWiseBooking(selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else {
      // booking_accepted
      selectedBookingStatusForData.value = "All";
      getBookings();
    }

    isLoading.value = false;
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
    await FireStoreUtils.countBooking();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (bookingList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > bookingList.length ? bookingList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageBooking.value = bookingList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }
  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.bookingLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.bookingLength! ? Constant.bookingLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<BookingModel> currentPageBookingData =
            await FireStoreUtils.getBooking(currentPage.value, itemPerPage, selectedBookingStatusForData.value, selectedDateRange.value);
        currentPageBooking.value = currentPageBookingData;
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
      return Constant.bookingLength!;
    } else {
      return int.parse(data);
    }
  }
}
