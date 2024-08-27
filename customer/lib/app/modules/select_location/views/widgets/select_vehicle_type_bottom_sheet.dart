import 'package:customer/app/modules/home/views/widgets/category_view.dart';
import 'package:customer/app/modules/payment_method/views/payment_method_view.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectVehicleTypeBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const SelectVehicleTypeBottomSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: SelectLocationController(),
        builder: (controller) {
          return Container(
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
              color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: ShapeDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Obx(() => (controller.mapModel.value == null)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gathering options'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const LinearProgressIndicator()
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    Text(
                                      'Choose a trip'.tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: Constant.vehicleTypeList!.length,
                                      padding: const EdgeInsets.only(bottom: 80),
                                      itemBuilder: (context, index) {
                                        return CategoryView(
                                          vehicleType: Constant.vehicleTypeList![index],
                                          index: index,
                                          isForPayment: false,
                                        );
                                      },
                                    )
                                  ]))
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.mapModel.value != null,
                      child: Container(
                        width: Responsive.width(100, context),
                        decoration: BoxDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                            border: Border(
                              top: BorderSide(width: 1.0, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            )),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total'.tr,
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        Constant.amountToShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(PaymentMethodView(
                                        index: controller.selectVehicleTypeIndex.value,
                                      ));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          padding: const EdgeInsets.all(5),
                                          decoration: ShapeDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                          ),
                                          child: (controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name)
                                              ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                              : (controller.selectedPaymentMethod.value == Constant.paymentModel!.wallet!.name)
                                                  ? SvgPicture.asset("assets/icon/ic_wallet.svg")
                                                  : (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name)
                                                      ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                                      : (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name)
                                                          ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                                          : (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name)
                                                              ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                                              : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name)
                                                                  ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                                  : (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name)
                                                                      ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                                      : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name)
                                                                          ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                                          : (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name)
                                                                              ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                              : const SizedBox(height: 24, width: 24),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width:80 ,
                                          child: Text(
                                            controller.selectedPaymentMethod.value.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(Icons.keyboard_arrow_right_rounded)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),
                            RoundShapeButton(
                                size: const Size(151, 45),
                                title: "Continue".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {
                                  controller.popupIndex.value = 2;
                                }),
                          ],
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }
}
