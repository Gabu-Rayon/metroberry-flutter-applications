import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/modules/home/controllers/home_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/screen_size.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../widget/container_custom.dart';
import '../../../../widget/global_widgets.dart';
import '../../../components/menu_widget.dart';
import '../../../utils/app_colors.dart';
import '../controllers/dashboard_screen_controller.dart';

class DashboardScreenView extends GetView<DashboardScreenController> {
  const DashboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    HomeController homeController = Get.put(HomeController());
    return GetBuilder<DashboardScreenController>(
      init: DashboardScreenController(),
      builder: (controller) {
        return ResponsiveWidget(
          mobile: Scaffold(
            key: controller.scaffoldKeyDrawer,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            // appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKey),
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: GestureDetector(
                  onTap: () {
                    controller.toggleDrawer();
                  },
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              10.width,
                              Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
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
              // key: scaffoldKey,
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        children: [
                          commonView(
                            context: context,
                            title: "Total Passengers".tr,
                            value: controller.totalUser.toString(),
                            imageAssets: "assets/icons/ic_group.svg",
                            bgColor: const Color(0xffd5e4fa),
                            textColor: const Color(0xff153f8a),
                          ),
                          commonView(
                            context: context,
                            title: "Total Cab".tr,
                            value: controller.totalCab.toString(),
                            imageAssets: "assets/icons/ic_car_3.svg",
                            bgColor: const Color(0xffe5d6fb),
                            textColor: const Color(0xff7754a2),
                          ),
                          commonView(
                            context: context,
                            title: "Today's Earning".tr,
                            value: Constant.amountShow(amount: controller.todayTotalEarnings.toString()),
                            imageAssets: "assets/icons/ic_coin_2.svg",
                            bgColor: const Color(0xfffbd4f5),
                            textColor: const Color(0xff853987),
                          ),
                          commonView(
                            context: context,
                            title: "Total Revenue".tr,
                            // value: controller.totalEarnings.toString(),
                            value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                            imageAssets: "assets/icons/ic_currency_dollar.svg",
                            bgColor: const Color(0xffeaeac3),
                            textColor: const Color(0xff7e723a),
                          ),
                        ],
                      ),
                    ),
                    24.height,
                    // Row(children: [Expanded(child: LineChartCard()), Expanded(child: LineChartCard())]),
                    Column(
                      children: [
                        Padding(padding: const EdgeInsets.all(10), child: bookingChartStatistic(context)),
                        Padding(padding: const EdgeInsets.all(10), child: usersChartStatistic(context)),
                        // usersChartStatistic(context),
                      ],
                    ),
                    controller.isUserData.value
                        ? Padding(
                            padding: paddingEdgeInsets(),
                            child: Constant.loader(),
                          )
                        : Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Visibility(
                                    visible: controller.recentBookingList.isNotEmpty,
                                    child: ContainerCustom(
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextCustom(
                                              title: 'Recent Bookings'.tr,
                                              fontSize: 24,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // homeController.currentPageIndex.value = 1;
                                                Get.toNamed(Routes.BOOKING_HISTORY_SCREEN);
                                              },
                                              child: TextCustom(
                                                title: 'View all'.tr,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
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
                                                : controller.recentBookingList.isEmpty
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
                                                              width: ResponsiveWidget.isMobile(context) ? 130 : MediaQuery.of(context).size.width * 0.08),
                                                          CommonUI.dataColumnWidget(context,
                                                              columnTitle: "Booking Date".tr,
                                                              width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.05),
                                                          CommonUI.dataColumnWidget(context,
                                                              columnTitle: "Payment Status".tr,
                                                              width: ResponsiveWidget.isMobile(context) ? 130 : MediaQuery.of(context).size.width * 0.07),
                                                          CommonUI.dataColumnWidget(context,
                                                              columnTitle: "Booking Status".tr,
                                                              width: ResponsiveWidget.isMobile(context) ? 130 : MediaQuery.of(context).size.width * 0.07),

                                                          CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 130),
                                                          // CommonUI.dataColumnWidget(context,
                                                          //     columnTitle: "Status", width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                                          CommonUI.dataColumnWidget(
                                                            context,
                                                            columnTitle: "Action".tr,
                                                            width: 100,
                                                          ),
                                                        ],
                                                        rows: controller.recentBookingList
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
                                                                                  child: TextButton(
                                                                                    onPressed: () {},
                                                                                    child: TextCustom(
                                                                                      title: userModel.fullName!.isEmpty
                                                                                          ? "N/A".tr
                                                                                          : userModel.fullName.toString() == "Unknown User"
                                                                                              ? "User Deleted".tr
                                                                                              : userModel.fullName.toString(),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                          }
                                                                        }),
                                                                  ),
                                                                  DataCell(TextCustom(
                                                                      title: bookingModel.createAt == null ? '' : Constant.timestampToDateTime(bookingModel.createAt!))),
                                                                  DataCell(TextCustom(title: bool.parse(bookingModel.paymentStatus!.toString()) ? "Paid" : "Unpaid")),
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

                                                                              // BookingHistoryDetailController bookingHistoryDetailController = Get.put(BookingHistoryDetailController());
                                                                              // await bookingHistoryDetailController.getArgument(bookingModel);
                                                                              //
                                                                              // HomeController homeController = Get.put(HomeController());
                                                                              // homeController.currentPageIndex.value = 3;
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                              "assets/icons/ic_eye.svg",
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
                                      ]),
                                    ),
                                  )),
                              10.width,
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Visibility(
                                  visible: controller.userList.isNotEmpty,
                                  child: ContainerCustom(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextCustom(
                                              title: 'Recent Users'.tr,
                                              fontSize: 24,
                                              fontFamily: AppThemeData.bold,

                                            ),
                                            InkWell(
                                              onTap: () {
                                                // homeController.currentPageIndex.value = 2;
                                                Get.toNamed(Routes.PASSENGERS_SCREEN);
                                              },
                                              child: TextCustom(
                                                title: 'View all'.tr,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
                                              
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          height: ScreenSize.height(50, context),
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: controller.userList.length >= 5 ? 5 : controller.userList.length,
                                            itemBuilder: (context, index) {
                                              return userView(context: context, userModel: controller.userList[index], themeChange: themeChange);
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return 12.height;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
          desktop: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
              appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKeyDrawer),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MenuWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Wrap(
                                children: [
                                  commonView(
                                    context: context,
                                    title: "Total Passengers".tr,
                                    value: controller.totalUser.toString(),
                                    imageAssets: "assets/icons/ic_group.svg",
                                    bgColor: const Color(0xffd5e4fa),
                                    textColor: const Color(0xff153f8a),
                                  ),
                                  commonView(
                                    context: context,
                                    title: "Total Cab".tr,
                                    value: controller.totalCab.toString(),
                                    imageAssets: "assets/icons/ic_car_3.svg",
                                    bgColor: const Color(0xffe5d6fb),
                                    textColor: const Color(0xff7754a2),
                                  ),
                                  commonView(
                                    context: context,
                                    title: "Today's Earning".tr,
                                    value: Constant.amountShow(amount: controller.todayTotalEarnings.toString()),
                                    imageAssets: "assets/icons/ic_coin_2.svg",
                                    bgColor: const Color(0xfffbd4f5),
                                    textColor: const Color(0xff853987),
                                  ),
                                  commonView(
                                    context: context,
                                    title: "Total Earning".tr,
                                    // value: controller.totalEarnings.toString(),
                                    value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                                    imageAssets: "assets/icons/ic_currency_dollar.svg",
                                    bgColor: const Color(0xffeaeac3),
                                    textColor: const Color(0xff7e723a),
                                  ),
                                ],
                              ),
                            ),
                            24.height,
                            Padding(
                              padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                              child: SingleChildScrollView(
                                child: Row(children: [
                                  Expanded(
                                    flex: 7,
                                    child: bookingChartStatistic(context),
                                  ),
                                  24.width,
                                  Expanded(
                                    flex: 3,
                                    child: usersChartStatistic(context),
                                  ),
                                ]),
                              ),
                            ),
                            24.height,
                            controller.isUserData.value
                                ? Padding(
                                    padding: paddingEdgeInsets(),
                                    child: Constant.loader(),
                                  )
                                : Container(
                                    padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Visibility(
                                            visible: controller.recentBookingList.isNotEmpty,
                                            child: ContainerCustom(
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextCustom(
                                                      title: 'Recent Bookings'.tr,
                                                      fontSize: 20,
                                                      fontFamily: AppThemeData.bold,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        // homeController.currentPageIndex.value = 1;
                                                        Get.toNamed(Routes.BOOKING_HISTORY_SCREEN);
                                                      },
                                                      child: TextCustom(
                                                        title: 'View all'.tr,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.bold,
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
                                                        : controller.recentBookingList.isEmpty
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
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Booking Date".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.05),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Payment Status".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
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
                                                                rows: controller.recentBookingList
                                                                    .map((bookingModel) => DataRow(cells: [
                                                                          DataCell(
                                                                            TextCustom(
                                                                              title: bookingModel.id!.isEmpty ? "N/A" : "#${bookingModel.id!.substring(0, 8)}",
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
                                                                                          child: TextButton(
                                                                                            onPressed: () {},
                                                                                            child: TextCustom(
                                                                                              title: userModel.fullName == null
                                                                                                  ? "N/A"
                                                                                                  : userModel.fullName!.isEmpty
                                                                                                      ? "N/A"
                                                                                                      : userModel.fullName.toString() == "Unknown User"
                                                                                                          ? "User Deleted"
                                                                                                          : userModel.fullName.toString(),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                  }
                                                                                }),
                                                                          ),
                                                                          DataCell(TextCustom(
                                                                              title: bookingModel.createAt == null
                                                                                  ? ''
                                                                                  : Constant.timestampToDateTime(bookingModel.createAt!))),
                                                                          DataCell(
                                                                              TextCustom(title: bool.parse(bookingModel.paymentStatus!.toString()) ? "Paid" : "Unpaid")),
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
                                                                                      // BookingHistoryDetailController bookingHistoryDetailController =
                                                                                      //     Get.put(BookingHistoryDetailController());
                                                                                      // await bookingHistoryDetailController.getArgument(bookingModel);
                                                                                      //
                                                                                      // HomeController homeController = Get.put(HomeController());
                                                                                      // homeController.currentPageIndex.value = 3;
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      "assets/icons/ic_eye.svg",
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
                                              ]),
                                            ),
                                          ),
                                        ),
                                        24.width,
                                        Expanded(
                                          flex: 3,
                                          child: Visibility(
                                            visible: controller.userList.isNotEmpty,
                                            child: ContainerCustom(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextCustom(
                                                        title: 'Recent Users'.tr,
                                                        fontSize: 20,
                                                        fontFamily: AppThemeData.bold,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          // homeController.currentPageIndex.value = 2;
                                                          Get.toNamed(Routes.PASSENGERS_SCREEN);
                                                        },
                                                        child: TextCustom(
                                                          title: 'View all'.tr,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: controller.userList.length >= 5 ? 5 : controller.userList.length,
                                                    itemBuilder: (context, index) {
                                                      return userView(context: context, userModel: controller.userList[index], themeChange: themeChange);
                                                    },
                                                    separatorBuilder: (BuildContext context, int index) {
                                                      return 12.height;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          tablet: Scaffold(
            key: controller.scaffoldKeyDrawer,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: GestureDetector(
                  onTap: () {
                    controller.toggleDrawer();
                  },
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              10.width,
                              Icon(
                                 Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
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
              // key: scaffoldKey,
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: MenuWidget(),
            ),
            body: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: [
                    Wrap(
                      children: [
                        commonView(
                          context: context,
                          title: "Total Passengers".tr,
                          value: controller.totalUser.toString(),
                          imageAssets: "assets/icons/ic_group.svg",
                          bgColor: const Color(0xffd5e4fa),
                          textColor: const Color(0xff153f8a),
                        ),
                        commonView(
                          context: context,
                          title: "Total Cab".tr,
                          value: controller.totalCab.toString(),
                          imageAssets: "assets/icons/ic_car_3.svg",
                          bgColor: const Color(0xffe5d6fb),
                          textColor: const Color(0xff7754a2),
                        ),
                        commonView(
                          context: context,
                          title: "Today's Earning".tr,
                          value: Constant.amountShow(amount: controller.todayTotalEarnings.toString()),
                          imageAssets: "assets/icons/ic_coin_2.svg",
                          bgColor: const Color(0xfffbd4f5),
                          textColor: const Color(0xff853987),
                        ),
                        commonView(
                          context: context,
                          title: "Total Earning".tr,
                          // value: controller.totalEarnings.toString(),
                          value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                          imageAssets: "assets/icons/ic_currency_dollar.svg",
                          bgColor: const Color(0xffeaeac3),
                          textColor: const Color(0xff7e723a),
                        ),
                      ],
                    ),
                    24.height,
                    Padding(
                      padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                      child: Row(children: [
                        Expanded(
                          flex: 10,
                          child: bookingChartStatistic(context),
                        ),
                        24.width,
                        Expanded(
                          flex: 7,
                          child: usersChartStatistic(context),
                        ),
                      ]),
                    ),
                    24.height,
                    controller.isUserData.value
                        ? Padding(
                            padding: paddingEdgeInsets(),
                            child: Constant.loader(),
                          )
                        : Container(
                            padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Visibility(
                                    visible: controller.recentBookingList.isNotEmpty,
                                    child: ContainerCustom(
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextCustom(
                                              title: 'Recent Bookings'.tr,
                                              fontSize: 20,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // homeController.currentPageIndex.value = 1;
                                                Get.toNamed(Routes.BOOKING_HISTORY_SCREEN);
                                              },
                                              child: TextCustom(
                                                title: 'View all'.tr,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
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
                                                : controller.recentBookingList.isEmpty
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
                                                              width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                          CommonUI.dataColumnWidget(context,
                                                              columnTitle: "Booking Date".tr,
                                                              width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.05),
                                                          CommonUI.dataColumnWidget(context,
                                                              columnTitle: "Payment Status".tr,
                                                              width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
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
                                                        rows: controller.recentBookingList
                                                            .map((bookingModel) => DataRow(cells: [
                                                                  DataCell(
                                                                    TextCustom(
                                                                      title: bookingModel.id!.isEmpty ? "N/A" : "#${bookingModel.id!.substring(0, 8)}",
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
                                                                                  child: TextButton(
                                                                                    onPressed: () {},
                                                                                    child: TextCustom(
                                                                                      title: userModel.fullName!.isEmpty
                                                                                          ? "N/A"
                                                                                          : userModel.fullName.toString() == "Unknown User"
                                                                                              ? "User Deleted"
                                                                                              : userModel.fullName.toString(),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                          }
                                                                        }),
                                                                  ),
                                                                  DataCell(TextCustom(
                                                                      title: bookingModel.createAt == null ? '' : Constant.timestampToDateTime(bookingModel.createAt!))),
                                                                  DataCell(TextCustom(title: bool.parse(bookingModel.paymentStatus!.toString()) ? "Paid" : "Unpaid")),
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
                                                                              // BookingHistoryDetailController bookingHistoryDetailController =
                                                                              //     Get.put(BookingHistoryDetailController());
                                                                              // await bookingHistoryDetailController.getArgument(bookingModel);
                                                                              //
                                                                              // HomeController homeController = Get.put(HomeController());
                                                                              // homeController.currentPageIndex.value = 3;
                                                                            },
                                                                            child: SvgPicture.asset(
                                                                              "assets/icons/ic_eye.svg",
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
                                      ]),
                                    ),
                                  ),
                                ),
                                24.width,
                                Expanded(
                                  flex: 7,
                                  child: Visibility(
                                    visible: controller.userList.isNotEmpty,
                                    child: ContainerCustom(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextCustom(
                                                title: 'Recent Users'.tr,
                                                fontSize: 20,

                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // homeController.currentPageIndex.value = 2;
                                                  Get.toNamed(Routes.PASSENGERS_SCREEN);
                                                },
                                                child: TextCustom(
                                                  title: 'View all'.tr,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(0),
                                            // height: ScreenSize.height(50, context),
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: controller.userList.length >= 5 ? 5 : controller.userList.length,
                                              itemBuilder: (context, index) {
                                                return userView(context: context, userModel: controller.userList[index], themeChange: themeChange);
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return 12.height;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

userView({required BuildContext context, required UserModel userModel, required themeChange}) {
  return AnimatedContainer(
    duration: GetNumUtils(400).milliseconds,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 60,
            width: 60,
            child: NetworkImageWidget(
              imageUrl: userModel.profilePic.toString(),
            ).paddingAll(10),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ResponsiveWidget.isMobile(context) ? MediaQuery.sizeOf(context).width * 0.6 : 250,
              child: Text(userModel.fullName.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis ,
                  style: const TextStyle(fontFamily: AppThemeData.regular, fontWeight: FontWeight.w600, color: AppThemData.gallery700, fontSize: 14)),
            ),
            Text("${Constant.timestampToTime12Hour(userModel.createdAt!)}  |  ${Constant.timestampToDate(userModel.createdAt!)}",
                style: const TextStyle(fontSize: 12, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w700, color: AppThemData.gallery500)),
          ],
        ),
      ],
    ),
  );
}

commonView({required BuildContext context, required String title, required String value, required String imageAssets, required Color bgColor, required Color textColor}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Container(
    margin: const EdgeInsets.only(right: 24, top: 24),
    padding: const EdgeInsets.all(12),
    height: 120,
    width: ResponsiveWidget.isDesktop(context) ? (ScreenSize.width(100, context) - 445) / 4 : (ScreenSize.width(100, context) - 80) / 2,
    decoration: BoxDecoration(
      // image: const DecorationImage(image: AssetImage("assets/images/Card1.png"), fit: BoxFit.fill),
      color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      // border: Border.all(color: themeChange.getTheme() ? AppColors.greyShade900 : AppColors.greyShade100.withOpacity(.5)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              imageAssets,
              color: textColor,
              height: 20,
              width: 20,
            ),
          ),
        ),
        const Spacer(),
        TextCustom(
          title: title,
          fontSize: 14,
        ),
        TextCustom(
          title: value,
          fontFamily: AppThemeData.bold,
          fontSize: 24,
        )
      ],
    ),
  );
}

bookingChartStatistic(BuildContext context) {
  return GetX<DashboardScreenController>(builder: (controller) {
    return SizedBox(
      child: ContainerCustom(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: 'Total Booking'.tr,
                    fontSize: 20,
                    fontFamily: AppThemeData.bold,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    width: ResponsiveWidget.isDesktop(context)
                        ? (ScreenSize.width(100, context) - 270) * 0.65
                        : ResponsiveWidget.isTablet(context)
                            ? (ScreenSize.width(100, context) - 270) * 0.75
                            : ScreenSize.width(74, context),
                    child: controller.isLoadingBookingChart.value
                        ? Constant.loader()
                        : SfCartesianChart(
                            borderWidth: 0,
                            tooltipBehavior: TooltipBehavior(enable: true),
                            plotAreaBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            primaryXAxis: CategoryAxis(
                              axisLine: AxisLine(color: AppThemData.textBlack.withOpacity(.5)),
                              majorGridLines: const MajorGridLines(color: Colors.transparent),
                              labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            primaryYAxis: NumericAxis(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              axisLine: const AxisLine(color: AppThemData.textBlack),
                              majorGridLines: const MajorGridLines(color: Colors.transparent, width: 0),
                              minorTickLines: const MinorTickLines(color: Colors.transparent, width: 0),
                              minimum: 0,
                              numberFormat: NumberFormat.currency(symbol: Constant.currencyModel!.symbol),
                              minorGridLines: const MinorGridLines(),
                              interval: 100,
                              labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            series: <ChartSeries<ChartData, String>>[
                              SplineAreaSeries<ChartData, String>(
                                dataSource: controller.bookingChartData!,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings: const MarkerSettings(isVisible: true),
                                name: 'Revenue',
                                color: AppThemData.primary500,
                              ),
                              LineSeries<ChartData, String>(
                                dataSource: controller.bookingChartData!,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings: const MarkerSettings(isVisible: true),
                                name: 'Revenue',
                                color: AppThemData.primary500,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}

usersChartStatistic(BuildContext context) {
  return GetX<DashboardScreenController>(builder: (controller) {
    return ContainerCustom(
      // color: Colors.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(
            title: 'Total Users'.tr,
            fontSize: 20,
            fontFamily: AppThemeData.bold,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            // width: ResponsiveWidget.isDesktop(context) ? (ScreenSize.width(100, context) - 270) * 0.25 :  ResponsiveWidget.isTablet(context) ?(ScreenSize.width(100, context) - 270) * 0.25   : (ScreenSize.width(74, context)),
            child: (controller.isUserData.value)
                ? Constant.loader()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SfCircularChart(
                          borderWidth: 0,
                          tooltipBehavior: TooltipBehavior(enable: true),
                          // plotAreaBorderColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          series: <RadialBarSeries<ChartDataCircle, String>>[
                            RadialBarSeries<ChartDataCircle, String>(
                              dataSource: [
                                ChartDataCircle('Driver'.tr, controller.totalCab.value, AppThemData.secondary500),
                                ChartDataCircle('User'.tr, controller.totalUser.value, AppThemData.blue500),
                              ],
                              xValueMapper: (ChartDataCircle data, _) => data.x,
                              yValueMapper: (ChartDataCircle data, _) => data.y,
                              pointColorMapper: (ChartDataCircle data, _) => data.color,
                              useSeriesColor: true,
                              trackOpacity: 0.2,
                              gap: '10%',
                              strokeWidth: 30,
                              cornerStyle: CornerStyle.bothCurve,
                              dataLabelSettings: const DataLabelSettings(
                                  // Renders the data label
                                  isVisible: false),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 16.0,
                                width: 16.0,
                                decoration: const BoxDecoration(
                                  color: AppThemData.secondary500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              spaceW(width: 10),
                              TextCustom(
                                title: 'Driver'.tr,
                              ),
                            ],
                          ),
                          spaceH(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 16.0,
                                width: 16.0,
                                decoration: const BoxDecoration(
                                  color: AppThemData.blue500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              spaceW(width: 10),
                              TextCustom(
                                title: 'User'.tr,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  });
}
