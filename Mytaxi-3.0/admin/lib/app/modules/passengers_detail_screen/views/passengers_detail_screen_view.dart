import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/extension/date_time_extension.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/wallet_transaction_model.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/passengers_detail_screen_controller.dart';

class PassengersDetailScreenView extends GetView<PassengersDetailScreenController> {
  const PassengersDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PassengersDetailScreenController>(
      init: PassengersDetailScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
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
                  child: controller.isLoading.value
                      ? Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(
                              padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                              child: ContainerCustom(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          GestureDetector(
                                              onTap: () => Get.back(),
                                              child: TextCustom(title: 'Users'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                        ])
                                      ]),
                                    ],
                                  ),
                                  spaceH(height: 20),
                                  ResponsiveWidget(
                                    mobile: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextCustom(
                                                    title: "User Details".tr,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.bold,
                                                  ),
                                                  spaceH(height: 16),
                                                  rowDataWidget(name: "Name", value: controller.userModel.value.fullName.toString(), themeChange: themeChange),
                                                  spaceH(height: 10),
                                                  rowDataWidget(
                                                      name: "Phone Number",
                                                      value: Constant.maskMobileNumber(
                                                          mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                          countryCode: controller.userModel.value.countryCode.toString()),
                                                      themeChange: themeChange),
                                                  spaceH(height: 10),
                                                  rowDataWidget(
                                                      name: "Email ", value: Constant.maskEmail(email: controller.userModel.value.email.toString()), themeChange: themeChange),
                                                  spaceH(height: 10),
                                                  rowDataWidget(name: "Gender", value: controller.userModel.value.gender.toString(), themeChange: themeChange),
                                                ],
                                              ),
                                            ).expand(),
                                          ],
                                        ),
                                        spaceH(height: 20),
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(image: AssetImage("assets/image/wallet_card.png"), fit: BoxFit.fill),
                                                border: Border.all(color: AppThemData.lightGrey06.withOpacity(.5)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.primaryWhite.withOpacity(.2)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SvgPicture.asset(
                                                            'assets/icons/ic_wallet.svg',
                                                            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                            height: 30,
                                                            width: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      spaceW(width: 14),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextCustom(
                                                              title: 'Wallet Amount',
                                                              fontSize: 14,
                                                              color:
                                                                  themeChange.isDarkTheme() ? AppThemData.primaryWhite.withOpacity(.7) : AppThemData.primaryBlack.withOpacity(.7),
                                                              fontFamily: AppThemeData.medium,
                                                            ),
                                                            spaceH(height: 7),
                                                            FittedBox(
                                                              child: Text(
                                                                Constant.amountShow(amount: controller.userModel.value.walletAmount!),
                                                                style: Constant.defaultTextStyle(
                                                                  size: 18,
                                                                  color: themeChange.isDarkTheme()
                                                                      ? AppThemData.primaryWhite.withOpacity(.7)
                                                                      : AppThemData.primaryBlack.withOpacity(.7),
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  spaceH(height: 20),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      CustomButtonWidget(
                                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                                        buttonTitle: "Top Up".tr,
                                                        borderRadius: 60,
                                                        width: 70,
                                                        textColor: AppThemData.primaryWhite,
                                                        buttonColor: AppThemData.primaryBlack,
                                                        onPress: () {
                                                          controller.setDefaultData();
                                                          showDialog(context: context, builder: (context) => const TopUpDialog());
                                                        },
                                                      ).expand(),
                                                      spaceW(width: 10),
                                                      CustomButtonWidget(
                                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                                        buttonTitle: "Transaction History".tr,
                                                        borderRadius: 60,
                                                        width: 70,
                                                        textColor: AppThemData.primaryBlack,
                                                        buttonColor: AppThemData.primary200,
                                                        onPress: () {
                                                          controller.setDefaultData();
                                                          showDialog(context: context, builder: (context) => const TransactionHistoryDialog());
                                                        },
                                                      ).expand(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ).expand(),
                                          ],
                                        ),
                                      ],
                                    ),
                                    tablet: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextCustom(
                                                title: "User Details".tr,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
                                              ),
                                              spaceH(height: 16),
                                              rowDataWidget(name: "Name", value: controller.userModel.value.fullName.toString(), themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(
                                                  name: "Phone Number",
                                                  value: Constant.maskMobileNumber(
                                                      mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                      countryCode: controller.userModel.value.countryCode.toString()),
                                                  themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(
                                                  name: "Email ", value: Constant.maskEmail(email: controller.userModel.value.email.toString()), themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(name: "Gender", value: controller.userModel.value.gender.toString(), themeChange: themeChange),
                                            ],
                                          ),
                                        ).expand(),
                                        spaceW(width: 20),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(image: AssetImage("assets/image/wallet_card.png"), fit: BoxFit.fill),
                                            border: Border.all(color: AppThemData.lightGrey06.withOpacity(.5)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.primaryWhite.withOpacity(.2)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/ic_wallet.svg',
                                                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  spaceW(width: 14),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                          title: 'Wallet Amount',
                                                          fontSize: 14,
                                                          color: themeChange.isDarkTheme() ? AppThemData.primaryWhite.withOpacity(.7) : AppThemData.primaryBlack.withOpacity(.7),
                                                          fontFamily: AppThemeData.medium,
                                                        ),
                                                        spaceH(height: 7),
                                                        FittedBox(
                                                          child: Text(
                                                            Constant.amountShow(amount: controller.userModel.value.walletAmount!),
                                                            style: Constant.defaultTextStyle(
                                                              size: 18,
                                                              color:
                                                                  themeChange.isDarkTheme() ? AppThemData.primaryWhite.withOpacity(.7) : AppThemData.primaryBlack.withOpacity(.7),
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 20),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    buttonTitle: "Top Up".tr,
                                                    borderRadius: 60,
                                                    width: 70,
                                                    textColor: AppThemData.primaryWhite,
                                                    buttonColor: AppThemData.primaryBlack,
                                                    onPress: () {
                                                      controller.setDefaultData();
                                                      showDialog(context: context, builder: (context) => const TopUpDialog());
                                                    },
                                                  ).expand(),
                                                  spaceW(width: 10),
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    buttonTitle: "Transaction History".tr,
                                                    borderRadius: 60,
                                                    width: 70,
                                                    textColor: AppThemData.primaryBlack,
                                                    buttonColor: AppThemData.primary200,
                                                    onPress: () {
                                                      controller.setDefaultData();
                                                      showDialog(context: context, builder: (context) => const TransactionHistoryDialog());
                                                    },
                                                  ).expand(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                      ],
                                    ),
                                    desktop: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextCustom(
                                                title: "User Details".tr,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.bold,
                                              ),
                                              spaceH(height: 16),
                                              rowDataWidget(name: "Name", value: controller.userModel.value.fullName.toString(), themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(
                                                  name: "Phone Number",
                                                  value: Constant.maskMobileNumber(
                                                      mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                      countryCode: controller.userModel.value.countryCode.toString()),
                                                  themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(
                                                  name: "Email ", value: Constant.maskEmail(email: controller.userModel.value.email.toString()), themeChange: themeChange),
                                              spaceH(height: 10),
                                              rowDataWidget(name: "Gender", value: controller.userModel.value.gender.toString(), themeChange: themeChange),
                                            ],
                                          ),
                                        ).expand(),
                                        spaceW(width: 20),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                                          width: 400,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(image: AssetImage("assets/image/wallet_card.png"), fit: BoxFit.fill),
                                            border: Border.all(color: AppThemData.lightGrey06.withOpacity(.5)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.primaryWhite.withOpacity(.2)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/ic_wallet.svg',
                                                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  spaceW(width: 14),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                          title: 'Wallet Amount',
                                                          fontSize: 14,
                                                          color: themeChange.isDarkTheme() ? AppThemData.primaryWhite.withOpacity(.7) : AppThemData.primaryBlack.withOpacity(.7),
                                                          fontFamily: AppThemeData.medium,
                                                        ),
                                                        spaceH(height: 7),
                                                        FittedBox(
                                                          child: Text(
                                                            Constant.amountShow(amount: controller.userModel.value.walletAmount!),
                                                            style: Constant.defaultTextStyle(
                                                              size: 18,
                                                              color:
                                                                  themeChange.isDarkTheme() ? AppThemData.primaryWhite.withOpacity(.7) : AppThemData.primaryBlack.withOpacity(.7),
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 20),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    buttonTitle: "Top Up".tr,
                                                    borderRadius: 60,
                                                    width: 70,
                                                    textColor: AppThemData.primaryWhite,
                                                    buttonColor: AppThemData.primaryBlack,
                                                    onPress: () {
                                                      controller.setDefaultData();
                                                      showDialog(context: context, builder: (context) => const TopUpDialog());
                                                    },
                                                  ).expand(),
                                                  spaceW(width: 10),
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    buttonTitle: "Transaction History".tr,
                                                    borderRadius: 60,
                                                    width: 70,
                                                    textColor: AppThemData.primaryBlack,
                                                    buttonColor: AppThemData.primary200,
                                                    onPress: () {
                                                      controller.setDefaultData();
                                                      showDialog(context: context, builder: (context) => const TransactionHistoryDialog());
                                                    },
                                                  ).expand(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  spaceH(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
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
                                            hint: TextCustom(title: 'Payment Status'.tr),
                                            onChanged: (String? taxType) {
                                              controller.selectedPayoutStatus.value = taxType ?? "All";
                                              controller.getBookingDataForConverter();
                                            },
                                            value: controller.selectedPayoutStatus.value,
                                            items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
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
                                      spaceW(),
                                      NumberOfRowsDropDown(
                                        controller: controller,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 20),
                                  Obx(
                                    () => SingleChildScrollView(
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
                                                    headingRowColor:
                                                        MaterialStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                                    columns: [
                                                      CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Customer Name".tr,
                                                          width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Booking Date".tr,
                                                          width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.17),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Booking Status".tr,
                                                          width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.10),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Payment Status".tr,
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
                                                                                title: userModel.fullName!.isEmpty || userModel.fullName == null
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
                                                              DataCell(TextCustom(title: bookingModel.createAt == null ? '' : Constant.timestampToDate(bookingModel.createAt!))),
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
                              ),
                            )
                          ]),
                        )),
            ],
          ),
        );
      },
    );
  }
}

rowDataWidget({required String name, required String value, required themeChange}) {
  return Row(
    children: [
      TextCustom(title: name.tr, fontSize: 14, fontFamily: AppThemeData.medium).expand(flex: 1),
      const TextCustom(title: ":   ", fontSize: 14, fontFamily: AppThemeData.medium),
      TextCustom(
        title: value,
        fontSize: 14,
        fontFamily: AppThemeData.regular,
      ).expand(flex: 2),
    ],
  );
}

class TopUpDialog extends StatelessWidget {
  const TopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<PassengersDetailScreenController>(
      init: PassengersDetailScreenController(),
      builder: (controller) {
        return CustomDialog(
          title: "Top Up",
          widgetList: [
            SizedBox(
              child: CustomTextFormField(title: "Top up Amount".tr, hintText: "Enter Top up Amount".tr, controller: controller.topupController.value),
            ),
          ],
          bottomWidgetList: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  buttonTitle: "Close".tr,
                  buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                  onPress: () {
                    controller.topupController.value.text = "";
                    Navigator.pop(context);
                  },
                ),
                spaceW(),
                CustomButtonWidget(
                  buttonTitle: "Top up".tr,
                  onPress: () {
                    if (Constant.isDemo) {
                      DialogBox.demoDialogBox();
                    } else {
                      controller.completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
                    }
                  },
                ),
              ],
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}

class TransactionHistoryDialog extends StatelessWidget {
  const TransactionHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<PassengersDetailScreenController>(
      init: PassengersDetailScreenController(),
      builder: (controller) {
        return CustomDialog(
          title: "Transaction History",
          widgetList: [
            Obx(
              () => controller.currentPageWalletTransaction.isEmpty
                  ? const TextCustom(title: "Transaction History not available")
                  : ListView.builder(
                      itemCount: controller.currentPageWalletTransaction.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        WalletTransactionModel walletTransactionModel = controller.currentPageWalletTransaction[index];
                        return Container(
                          width: 358,
                          height: 80,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: ShapeDecoration(
                                  color: (walletTransactionModel.isCredit ?? false)
                                      ? themeChange.isDarkTheme()
                                          ? AppThemData.green950
                                          : AppThemData.green50
                                      : themeChange.isDarkTheme()
                                          ? AppThemData.secondary950
                                          : AppThemData.secondary50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    // "assets/icon/ic_my_wallet.svg",
                                    "assets/icons/ic_my_wallet.svg",
                                    colorFilter: ColorFilter.mode((walletTransactionModel.isCredit ?? false) ? AppThemData.green500 : AppThemData.red500, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextCustom(
                                              title: walletTransactionModel.note ?? '',
                                              fontSize: 16,
                                              fontFamily: AppThemeData.medium,
                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          TextCustom(
                                            title: Constant.amountToShow(amount: walletTransactionModel.amount ?? ''),
                                            fontSize: 16,
                                            fontFamily: AppThemeData.bold,
                                            color: (walletTransactionModel.isCredit ?? false) ? AppThemData.green500 : AppThemData.red500,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextCustom(
                                                  title: (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().dateMonthYear(),
                                                  fontFamily: AppThemeData.medium,
                                                  fontSize: 14,
                                                  color: themeChange.isDarkTheme() ? AppThemData.greyShade400 : AppThemData.greyShade500,
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  height: 16,
                                                  decoration: ShapeDecoration(
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        width: 1,
                                                        strokeAlign: BorderSide.strokeAlignCenter,
                                                        color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                TextCustom(
                                                  title: (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().time(),
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemData.greyShade400 : AppThemData.greyShade500,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
          bottomWidgetList: [
            Visibility(
              visible: controller.totalPage.value > 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: WebPagination(
                        currentPage: controller.currentPage.value,
                        totalPage: controller.totalPage.value,
                        displayItemCount: controller.pageValue("3"),
                        onPageChanged: (page) {
                          controller.currentPage.value = page;
                          controller.setPaginationForTransactionHistory(controller.totalItemPerPage.value);
                        }),
                  ),
                ],
              ),
            )
          ],
          controller: controller,
        );
      },
    );
  }
}
