import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/wallet_transaction_model.dart';
import 'package:customer/app/modules/my_wallet/views/widgets/add_money_dialog_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/no_data_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/title_view.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/my_wallet_controller.dart';

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: MyWalletController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "My Wallet".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // ),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Responsive.width(100, context),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: ShapeDecoration(
                        color: AppThemData.secondary500,
                        image: const DecorationImage(image: AssetImage("assets/images/bg_wallet.png")),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance'.tr,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                () => Text(
                                  Constant.amountToShow(amount: controller.userModel.value.walletAmount ?? '0.0'),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          RoundShapeButton(
                            title: "title",
                            buttonColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                            buttonTextColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                            titleWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Add Money'.tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return const AddMoneyDialogView();
                                },
                              );
                            },
                            size: const Size(171, 48),
                          ),
                        ],
                      ),
                    ),
                    TitleView(titleText: "Transaction History".tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 16)),
                    Obx(
                      () => controller.walletTransactionList.isEmpty
                          ? NoDataView(
                              themeChange: themeChange,
                              height: Responsive.height(30, context),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.walletTransactionList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                WalletTransactionModel walletTransactionModel = controller.walletTransactionList[index];
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
                                                  ? AppThemData.success950
                                                  : AppThemData.success50
                                              : themeChange.isDarkTheme()
                                                  ? AppThemData.secondary950
                                                  : AppThemData.secondary50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icon/ic_my_wallet.svg",
                                            colorFilter: ColorFilter.mode(
                                                (walletTransactionModel.isCredit ?? false) ? AppThemData.success500 : AppThemData.danger500,
                                                BlendMode.srcIn),
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
                                                color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
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
                                                    child: Text(
                                                      walletTransactionModel.note ?? '',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    Constant.amountToShow(amount: walletTransactionModel.amount ?? ''),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.inter(
                                                      color:
                                                          (walletTransactionModel.isCredit ?? false) ? AppThemData.success500 : AppThemData.danger500,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
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
                                                        Text(
                                                          (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().dateMonthYear(),
                                                          style: GoogleFonts.inter(
                                                            color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          height: 16,
                                                          decoration: ShapeDecoration(
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 1,
                                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                                color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          (walletTransactionModel.createdDate ?? Timestamp.now()).toDate().time(),
                                                          style: GoogleFonts.inter(
                                                            color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                          ),
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
                ),
              ),
            ),
          );
        });
  }
}
