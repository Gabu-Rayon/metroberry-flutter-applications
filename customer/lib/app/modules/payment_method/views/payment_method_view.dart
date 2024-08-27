import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/modules/coupon_screen/views/coupon_screen_view.dart';
import 'package:customer/app/modules/home/views/widgets/category_view.dart';
import 'package:customer/app/modules/payment_method/views/widgets/price_row_view.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentMethodView extends StatelessWidget {
  final int index;

  const PaymentMethodView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: SelectLocationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Payment Method".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 21, left: ((Responsive.width(100, context) - 208) / 2), right: ((Responsive.width(100, context) - 208) / 2)),
              child: RoundShapeButton(
                title: "Confirm".tr,
                buttonColor: AppThemData.primary500,
                buttonTextColor: AppThemData.black,
                onTap: () {
                  Get.back();
                },
                size: const Size(208, 52),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryView(
                      vehicleType: Constant.vehicleTypeList![index],
                      index: index,
                      isForPayment: true,
                    ),
                    Container(
                      width: Responsive.width(100, context),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: ShapeDecoration(
                        color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PriceRowView(
                              price: controller.bookingModel.value.subTotal.toString(),
                              title: "Amount".tr,
                              priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            ),
                            const SizedBox(height: 16),
                            PriceRowView(
                                price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                title: "Discount".tr,
                                priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                            const SizedBox(height: 16),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.bookingModel.value.taxList!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                return Column(
                                  children: [
                                    PriceRowView(
                                        price: Constant.amountToShow(
                                            amount:
                                                Constant.calculateTax(amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel).toString()),
                                        title: "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                        priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Divider(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            const SizedBox(height: 12),
                            PriceRowView(
                              price: Constant.amountToShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                              title: "Total Amount".tr,
                              priceColor: AppThemData.primary500,
                              titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async => await Get.to(const CouponScreenView()),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Coupons'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded, color: themeChange.isDarkTheme() ? AppThemData.grey500 : AppThemData.grey400)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var result = await Get.to(const CouponScreenView());
                        // if (result != null && result == true) {
                        //   log("result $result");
                        //   controller.couponCode.value = "WEEKEND50";
                        //   controller.isCouponCode.value = true;
                        // }
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.couponCode.value,
                                  style: GoogleFonts.inter(
                                    color: controller.isCouponCode.value
                                        ? themeChange.isDarkTheme()
                                            ? AppThemData.grey25
                                            : AppThemData.grey950
                                        : themeChange.isDarkTheme()
                                            ? AppThemData.grey400
                                            : AppThemData.grey500,
                                    fontSize: 16,
                                    fontWeight: controller.isCouponCode.value ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => controller.isCouponCode.value
                                  ? InkWell(
                                      onTap: () {
                                        controller.selectedCouponModel.value = CouponModel();
                                        controller.couponCode.value = 'Enter coupon code'.tr;
                                        controller.bookingModel.value.discount = ('0.0').toString();
                                        controller.bookingModel.value.coupon = null;
                                        controller.isCouponCode.value = false;
                                        controller.bookingModel.value = BookingModel.fromJson(controller.bookingModel.value.toJson());
                                      },
                                      child: const Icon(Icons.close))
                                  : Text(
                                      'Apply',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        color: AppThemData.primary500,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 24),
                      child: Text(
                        'Payment Methods'.tr,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 0.09,
                        ),
                      ),
                    ),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: Constant.paymentModel!.cash != null && Constant.paymentModel!.cash!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.cash!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/ic_cash.svg",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.cash!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.cash!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.wallet != null && Constant.paymentModel!.wallet!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.wallet!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/ic_wallet.svg",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.wallet!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.wallet!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.wallet!.name;

                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.paypal != null && Constant.paymentModel!.paypal!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.paypal!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paypal.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.paypal!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.paypal!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.paypal!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.strip != null && Constant.paymentModel!.strip!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.strip!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_stripe.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.strip!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.strip!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.strip!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.razorpay != null && Constant.paymentModel!.razorpay!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.razorpay!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_razorpay.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.razorpay!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.razorpay!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.razorpay!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.payStack != null && Constant.paymentModel!.payStack!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payStack!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paystack.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payStack!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payStack!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.payStack!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.mercadoPago != null && Constant.paymentModel!.mercadoPago!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.mercadoPago!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_marcadopago.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.mercadoPago!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.mercadoPago!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.mercadoPago!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.payFast != null && Constant.paymentModel!.payFast!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payFast!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_payfast.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payFast!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payFast!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.payFast!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.flutterWave != null && Constant.paymentModel!.flutterWave!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.flutterWave!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_flutterwave.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.flutterWave!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.flutterWave!.name.toString();
                                      controller.bookingModel.value.paymentType = Constant.paymentModel!.flutterWave!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
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
            ),
          );
        });
  }
}
