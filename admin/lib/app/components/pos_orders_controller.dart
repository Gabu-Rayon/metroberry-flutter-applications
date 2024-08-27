/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scaneats/app/controller/dash_board_controller.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class PosOrdersController extends GetxController {
  DashBoardController dashBoardController = Get.find<DashBoardController>();

  RxString title = "POS Orders".obs;

  @override
  void onInit() {
    super.onInit();
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getPosOrdereData();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
  }

  RxBool isOrderoading = true.obs;
  RxList<OrderModel> posOrderList = <OrderModel>[].obs;
  RxList<OrderModel> tempList = <OrderModel>[].obs;

  Future<void> getPosOrdereData() async {
    isOrderoading.value = true;
    await FireStoreUtils.getAllOrder(role: Constant.orderTypePos).then((value) {
      if (value != null) {
        posOrderList.value = value;
        tempList.value = value;
      }
      setPagition(totalItemPerPage.value);
      isOrderoading.value = false;
    });
  }

  Future<void> deleteOrderId(String id) async {
    await FireStoreUtils.deleteOrderById(id).then((value) {
      if (value) {
        for (int i = 0; i < posOrderList.length; i++) {
          if (posOrderList[i].id == id) {
            posOrderList.removeAt(i);
          }
        }
        setPagition(totalItemPerPage.value);
        ShowToastDialog.showToast("Order has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  searchByName({String name = ''}) async {
    if (name != '') {
      currentPage.value = 1;
    }
    FireStoreUtils.getAllOrderByName(name, Constant.orderTypePos).then((value) {
      posOrderList.value = value ?? [];
      setPagition(totalItemPerPage.value);
    });
  }

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<OrderModel> currentPageOrder = <OrderModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;

  RxList<String> orderStatusType = ["All", Constant.statusOrderPlaced, Constant.statusAccept, Constant.statusPending, Constant.statusDelivered, Constant.statusRejected].obs;
  RxString selectedStatus = "All".obs;

  RxList<String> paymentFilterStatus = ["Both", Constant.paidPayment, Constant.unPaidPayment].obs;
  RxString selectedFilterPaymentStatus = "Both".obs;

  RxList<String> paymentType = ["Both", Constant.paymentTypeCash, Constant.paymentTypeCard, Constant.paymentTypeDegital].obs;
  RxString selectedPaymentType = "Both".obs;

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  filter() {
    isOrderoading.value = true;

    posOrderList.value = tempList.where(
      (e) {
        print("====>");
        print(e.paymentStatus!);
        print(selectedFilterPaymentStatus.value == "Paid" ? true : false);
        print("=====>");
        return ((selectedStatus.value.toLowerCase() == "all" ? true : e.status!.toLowerCase().contains(selectedStatus.value.toLowerCase())) &&
            (selectedPaymentType.value.toLowerCase() == "both" ? true : e.paymentMethod!.toLowerCase().contains(selectedPaymentType.value.toLowerCase())) &&
            (dateFiledController.value.text.isEmpty
                ? true
                : ((e.createdAt!.toDate().isAfter(selectedDate.value.start) &&
                        e.createdAt!.toDate().isBefore(DateTime(selectedDate.value.end.year, selectedDate.value.end.month, selectedDate.value.end.day, 23, 59, 0)))) &&
                    (selectedFilterPaymentStatus.value.toLowerCase() == "both" ? true : e.paymentStatus == (selectedFilterPaymentStatus.value == "Paid" ? true : false))));
      },
    ).toList();
    setPagition(totalItemPerPage.value);
    isOrderoading.value = false;
  }

  setPagition(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (posOrderList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > posOrderList.length ? posOrderList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagition(page);
    } else {
      currentPageOrder.value = posOrderList.sublist(startIndex.value, endIndex.value);
    }
    isOrderoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return posOrderList.length;
    } else {
      return int.parse(data);
    }
  }
}
*/
