// ignore_for_file: deprecated_member_use
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/modules/home/controllers/home_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../utils/responsive.dart';
import '../controllers/booking_history_screen_controller.dart';

class BookingHistoryScreenView extends GetView<BookingHistoryScreenController> {
  const BookingHistoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<BookingHistoryScreenController>(
      init: BookingHistoryScreenController(),
      builder: (controller) {
        HomeController homeController = Get.put(HomeController());
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            // key: controller.scaffoldKeysDrawer,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (!ResponsiveWidget.isDesktop(context)) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: !ResponsiveWidget.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/logo.png",
                                    height: 45,
                                    color: AppThemData.primary500,
                                  ),
                                  spaceW(),
                                  const TextCustom(
                                    title: 'My Taxi',
                                    color: AppThemData.primary500,
                                    fontSize: 30,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    if (themeChange.darkTheme == 1) {
                      themeChange.darkTheme = 0;
                    } else if (themeChange.darkTheme == 0) {
                      themeChange.darkTheme = 1;
                    } else if (themeChange.darkTheme == 2) {
                      themeChange.darkTheme = 0;
                    } else {
                      themeChange.darkTheme = 2;
                    }
                  },
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: AppThemData.yellow600,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: AppThemData.blue400,
                          height: 20,
                          width: 20,
                        ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: paddingEdgeInsets(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ContainerCustom(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                              ResponsiveWidget.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            GestureDetector(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                            TextCustom(
                                                title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                          ])
                                        ]),
                                        Row(
                                          children: [
                                            ContainerCustom(
                                              padding: paddingEdgeInsets(vertical: 0, horizontal: 0),
                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    if (controller.isDatePickerEnable.value) {
                                                      showDateRangePicker(context);
                                                    } else {
                                                      controller.getBookings();
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.date_range_outlined,
                                                  )),
                                            ),
                                            spaceW(),
                                            SizedBox(
                                              width: 120,
                                              child: Obx(
                                                () => DropdownButtonFormField(
                                                  borderRadius: BorderRadius.circular(15),
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.medium,
                                                    color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                  ),
                                                  onChanged: (String? statusType) {
                                                    controller.selectedBookingStatus.value = statusType ?? "All";
                                                    controller.getBookingDataByBookingStatus();
                                                  },
                                                  value: controller.selectedBookingStatus.value,
                                                  items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: TextCustom(
                                                        title: value,
                                                        fontFamily: AppThemeData.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  decoration: Constant.DefaultInputDecoration(context),
                                                ),
                                              ),
                                            ),
                                            spaceW(),
                                            NumberOfRowsDropDown(
                                              controller: controller,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            GestureDetector(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                          ])
                                        ]),
                                        spaceH(height: 16),
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.8,
                                          child: Obx(
                                            () => DropdownButtonFormField(
                                              borderRadius: BorderRadius.circular(15),
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                              ),
                                              onChanged: (String? taxType) {
                                                controller.selectedBookingStatus.value = taxType ?? "All";
                                                controller.getBookingDataByBookingStatus();
                                              },
                                              value: controller.selectedBookingStatus.value,
                                              items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
                                                    fontFamily: AppThemeData.regular,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                        ),
                                        spaceH(),
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                        spaceH(),
                                        SizedBox(
                                          width: 50,
                                          child: ContainerCustom(
                                            padding: paddingEdgeInsets(vertical: 0, horizontal: 0),
                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                            child: IconButton(
                                                onPressed: () async {
                                                  if (controller.isDatePickerEnable.value) {
                                                    showDateRangePicker(context);
                                                  } else {
                                                    controller.getBookings();
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.date_range_outlined,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                              spaceH(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isLoading.value
                                      ? Padding(
                                          padding: paddingEdgeInsets(),
                                          child: Constant.loader(),
                                        )
                                      : controller.currentPageBooking.isEmpty
                                          ? TextCustom(title: "No Data available".tr)
                                          : DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: MaterialStateColor.resolveWith(
                                                  (states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Customer Name".tr,
                                                    width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Booking Date".tr,
                                                    width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.17),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Payment Status".tr,
                                                    width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Booking Status".tr,
                                                    width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),

                                                CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 140),
                                                // CommonUI.dataColumnWidget(context,
                                                //     columnTitle: "Status", width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(
                                                  context,
                                                  columnTitle: "Action".tr,
                                                  width: 100,
                                                ),
                                              ],
                                              rows: controller.currentPageBooking
                                                  .map((bookingModel) => DataRow(cells: [
                                                        DataCell(
                                                          TextCustom(
                                                            title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 8)}",
                                                          ),
                                                        ),
                                                        DataCell(
                                                          FutureBuilder<UserModel?>(
                                                              future: FireStoreUtils.getUserByUserID(bookingModel.customerId.toString()), // async work
                                                              builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                                                switch (snapshot.connectionState) {
                                                                  case ConnectionState.waiting:
                                                                    // return Center(child: Constant.loader());
                                                                    return const SizedBox();
                                                                  default:
                                                                    if (snapshot.hasError) {
                                                                      return TextCustom(
                                                                        title: 'Error: ${snapshot.error}',
                                                                      );
                                                                    } else {
                                                                      UserModel userModel = snapshot.data!;
                                                                      return Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                        child: TextCustom(
                                                                          title: userModel.fullName!.isEmpty
                                                                              ? "N/A".tr
                                                                              : userModel.fullName.toString() == "Unknown User"
                                                                                  ? "User Deleted".tr
                                                                                  : userModel.fullName.toString(),
                                                                        ),
                                                                      );
                                                                    }
                                                                }
                                                              }),
                                                        ),
                                                        DataCell(
                                                            TextCustom(title: bookingModel.createAt == null ? '' : Constant.timestampToDateTime(bookingModel.createAt!))),
                                                        DataCell(TextCustom(title: bool.parse(bookingModel.paymentStatus!.toString()) ? "Paid".tr : "Unpaid".tr)),
                                                        DataCell(
                                                          // e.bookingStatus.toString()
                                                          Constant.bookingStatusText(context, bookingModel.bookingStatus.toString()),
                                                        ),
                                                        DataCell(TextCustom(title: Constant.amountShow(amount: bookingModel.subTotal))),
                                                        DataCell(
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                    Get.toNamed(Routes.BOOKING_DETAIL, arguments: {'bookingModel': bookingModel});
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_eye.svg",
                                                                    color: AppThemData.greyShade400,
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      // await controller.removeBooking(bookingModel);
                                                                      // controller.getBookings();
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeBooking(bookingModel);
                                                                        controller.getBookings();
                                                                      }
                                                                    }
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_delete.svg",
                                                                    color: AppThemData.greyShade400,
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]))
                                                  .toList()),
                                ),
                              ),
                              spaceH(),
                              ResponsiveWidget.isMobile(context)
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Visibility(
                                        visible: controller.totalPage.value > 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: WebPagination(
                                                  currentPage: controller.currentPage.value,
                                                  totalPage: controller.totalPage.value,
                                                  displayItemCount: controller.pageValue("5"),
                                                  onPageChanged: (page) {
                                                    controller.currentPage.value = page;
                                                    controller.setPagination(controller.totalItemPerPage.value);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                            ]),
                          )
                        ]),
                      )),
                ),
              ],
            ));
      },
    );
  }

  Future<void> showDateRangePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDate = (args.value as PickerDateRange).startDate;
                  controller.endDate = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRange.value = DateTimeRange(
                      start: DateTime(DateTime.now().year, DateTime.january, 1),
                      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  controller.selectedBookingStatus.value = "All";
                  controller.getBookingDataByBookingStatus();
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value = DateTimeRange(
                      start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusWiseBooking(
                    controller.selectedBookingStatusForData.value,
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  WidgetBuilder horizontalDrawerBuilder() {
    return (BuildContext context) {
      final themeChange = Provider.of<DarkThemeProvider>(context);

      return GetX<BookingHistoryScreenController>(
          init: BookingHistoryScreenController(),
          builder: (taxController) {
            return Drawer(
              backgroundColor: AppThemData.primaryWhite,
              width: 500,
              child: Padding(
                padding: paddingEdgeInsets(vertical: 24, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(title: controller.title.value, fontSize: 20),
                    spaceH(height: 24),
                    SizedBox(
                      height: 1,
                      child: ContainerCustom(
                        color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    };
  }
}
