/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/order_details_controller.dart';
import 'package:scaneats/app/controller/pos_orders_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/pagination.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class PosOrderWidget extends StatelessWidget {
  const PosOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosOrdersController(),
        builder: (controller) {
          return Padding(
              padding: paddingEdgeInsets(),
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                spaceH(),
                const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                Row(
                  children: [
                    const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                    const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                    InkWell(
                        onTap: () => controller.dashBoardController.changeView(screenType: ""),
                        child: TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium)),
                  ],
                ),
                spaceH(height: 20),
                SingleChildScrollView(
                  physics: Responsive.isMobile(context) ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                  child: ContainerCustom(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!Responsive.isMobile(context))
                            Expanded(
                              child: TextCustom(title: '${controller.title.value} (${controller.userList.length})', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold),
                            ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              if (!Responsive.isMobile(context)) spaceW(),
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontFamily: AppThemeData.medium,
                                    color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                  ),
                                  value: controller.totalItemPerPage.value,
                                  hint: const TextCustom(title: 'Select'),
                                  onChanged: (String? newValue) {
                                    controller.setPagination(newValue!);
                                  },
                                  decoration: InputDecoration(
                                      iconColor: AppThemeData.crusta500,
                                      isDense: true,
                                      filled: true,
                                      fillColor: themeChange.getTheme() ? AppThemeData.black : AppThemeData.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                      ),
                                      hintText: "Select",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getTheme() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood950,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppThemeData.medium)),
                                  items: Constant.numOfPageIemList.map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: TextCustom(
                                        title: value,
                                        fontFamily: AppThemeData.medium,
                                        color: themeChange.getTheme() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              spaceW(),
                              RoundedButtonFill(
                                  isRight: true,
                                  icon: SvgPicture.asset(
                                    'assets/icons/filter.svg',
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    color: AppThemeData.pickledBluewood50,
                                  ),
                                  width: 100,
                                  radius: 6,
                                  height: 40,
                                  fontSizes: 14,
                                  title: "Filter",
                                  color: AppThemeData.crusta500,
                                  textColor: AppThemeData.pickledBluewood50,
                                  onPress: () {
                                    showDialog(context: context, builder: (ctxt) => const FilterDialog());
                                  }),
                            ]),
                          ),
                        ],
                      ),
                      spaceH(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          child: controller.currentPageOrder.isEmpty || controller.isLoading.value
                              ? Constant.loaderWithNoFound(context, isLoading: controller.isLoading.value, isNotFound: controller.userList.isEmpty)
                              : DataTable(
                                  horizontalMargin: 20,
                                  columnSpacing: 30,
                                  dataRowMaxHeight: 70,
                                  border: TableBorder.all(
                                    color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  headingRowColor:
                                      MaterialStateColor.resolveWith((states) => themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                  columns: [
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: TextCustom(title: 'Order Id'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10,
                                        child: const TextCustom(title: 'Customer Name'),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: TextCustom(title: 'Order Amount'),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 220,
                                        child: TextCustom(title: 'Date'),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: TextCustom(title: 'Payment Type'),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: TextCustom(title: 'Status'),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: SizedBox(
                                        width: 140,
                                        child: TextCustom(title: 'Payment status'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.1,
                                        child: const TextCustom(title: 'Action'),
                                      ),
                                    ),
                                  ],
                                  rows: controller.currentPageOrder
                                      .map((e) => DataRow(cells: [
                                            DataCell(InkWell(
                                                onTap: () {
                                                  controller.dashBoardController.changeView(screenType: "order");
                                                  OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                                  orderDetailsController.setOrderModel(e);
                                                },
                                                child: TextCustom(title: Constant.orderId(orderId: e.id.toString()), color: AppThemeData.crusta500))),
                                            DataCell(TextCustom(title: capitalize(e.customer?.name ?? ''))),
                                            DataCell(TextCustom(title: Constant.amountShow(amount: '${e.total ?? 0}'))),
                                            DataCell(TextCustom(title: e.createdAt == null ? '' : Constant.timestampToDateAndTime(e.createdAt!))),
                                            DataCell(TextCustom(title: e.paymentMethod ?? '')),
                                            DataCell(TextCustom(title: e.status ?? '')),
                                            DataCell(
                                              RoundedButtonFill(
                                                isRight: true,
                                                radius: 50,
                                                height: 32,
                                                width: 60,
                                                title: e.paymentStatus == true ? "Paid" : "Unpaid",
                                                color: e.paymentStatus == true ? AppThemeData.forestGreen600 : AppThemeData.crusta700,
                                                textColor: AppThemeData.white,
                                                onPress: () {},
                                              ),
                                            ),
                                            DataCell(Row(children: [
                                              IconButton(
                                                onPressed: () {
                                                  controller.dashBoardController.changeView(screenType: "order");
                                                  OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                                  orderDetailsController.setOrderModel(e);
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              spaceW(),
                                              IconButton(
                                                  onPressed: () {
                                                    if (Constant.isDemo()) {
                                                      ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                    } else {
                                                      controller.deleteOrderId(e.id!);
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline_outlined,
                                                    size: 20,
                                                  )),
                                            ])),
                                          ]))
                                      .toList()),
                        ),
                      ),
                      spaceH(),
                      Visibility(
                        visible: controller.totalPage.value > 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: WebPagination(
                                  isDark: themeChange.getTheme(),
                                  currentPage: controller.currentPage.value,
                                  totalPage: controller.totalPage.value,
                                  displayItemCount: controller.pageValue(controller.totalItemPerPage.value),
                                  onPageChanged: (page) {
                                    controller.currentPage.value = page;
                                    controller.setPagination(controller.totalItemPerPage.value);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                )
              ]));
        });
  }
}

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosOrdersController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Filter', fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getTheme() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Status".toUpperCase(),
                              fontSize: 12,
                            ),
                            spaceH(),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: controller.selectedStatus.value,
                              hint: const TextCustom(title: 'Status'),
                              onChanged: (String? newValue) {
                                controller.selectedStatus.value = newValue!;
                                controller.update();
                              },
                              decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getTheme() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  hintText: "Status".tr,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppThemeData.medium)),
                              items: controller.orderStatusType.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: TextCustom(title: value.toString().toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Payment Status".toUpperCase(),
                              fontSize: 12,
                            ),
                            spaceH(),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: controller.selectedFilterPaymentStatus.value,
                              hint: const TextCustom(title: 'Payment Status'),
                              onChanged: (String? newValue) {
                                controller.selectedFilterPaymentStatus.value = newValue!;
                                controller.update();
                              },
                              decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getTheme() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  hintText: "Payment Status".tr,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppThemeData.medium)),
                              items: controller.paymentFilterStatus.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: TextCustom(title: value.toString().toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Payment type".toUpperCase(),
                              fontSize: 12,
                            ),
                            spaceH(),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: controller.selectedPaymentType.value,
                              hint: const TextCustom(title: 'Payment Status'),
                              onChanged: (String? newValue) {
                                controller.selectedPaymentType.value = newValue!;
                                controller.update();
                              },
                              decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getTheme() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  hintText: "Payment Status".tr,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getTheme() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppThemeData.medium)),
                              items: controller.paymentType.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: TextCustom(title: value.toString().toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              await Constant.selectDateAndTimeRange(context: context, date: DateTime.now()).then((value) {
                                if (value != null) {
                                  controller.selectedDate.value = value;
                                  controller.dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(value.start)} to ${DateFormat('yyyy-MM-dd').format(value.end)}";
                                }
                              });
                            },
                            child: TextFieldWidget(
                              hintText: '',
                              controller: controller.dateFiledController.value,
                              title: 'Select Date'.toUpperCase(),
                              enable: false,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RoundedButtonFill(
                  borderColor: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Close",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    Get.back();
                  }),
              RoundedButtonFill(
                  borderColor: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Clear",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getTheme() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    controller.getPosOrdereData();
                    Get.back();
                  }),
              RoundedButtonFill(
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Apply",
                  icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () {
                    Get.back();
                    controller.filter();
                  }),
            ],
          );
        });
  }
}
*/
