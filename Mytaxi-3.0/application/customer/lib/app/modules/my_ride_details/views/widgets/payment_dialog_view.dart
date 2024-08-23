import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/modules/my_ride_details/controllers/my_ride_details_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant_widgets/custom_dialog_box.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentDialogView extends StatelessWidget {
  const PaymentDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyRideDetailsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 25),
                  decoration: ShapeDecoration(
                    color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
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
                        visible: controller.paymentModel.value.cash != null && controller.paymentModel.value.cash!.isActive == true,
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
                                      height: 25,
                                      width: 25,
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
                        visible: controller.paymentModel.value.wallet != null && controller.paymentModel.value.wallet!.isActive == true,
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
                                      height: 40,
                                      width: 40,
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
                        visible: controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.isActive == true,
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
                        visible: controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.isActive == true,
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
                        visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.isActive == true,
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
                        visible: controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.isActive == true,
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
                        visible: controller.paymentModel.value.payStack != null && controller.paymentModel.value.payStack!.isActive == true,
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
                        visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.isActive == true,
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
                        visible: controller.paymentModel.value.payFast != null && controller.paymentModel.value.payFast!.isActive == true,
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
                Padding(
                  padding: EdgeInsets.only(bottom: 21, left: ((Responsive.width(100, context) - 208) / 2), right: ((Responsive.width(100, context) - 208) / 2)),
                  child: RoundShapeButton(
                    title: "Confirm",
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () async {
                      if (controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                themeChange: themeChange,
                                title: "Confirm Cash Payment".tr,
                                descriptions: "Are you sure you want to pay with cash payment?".tr,
                                positiveString: "Complete".tr,
                                negativeString: "Cancel".tr,
                                positiveClick: () async {
                                  controller.completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
                                  Navigator.pop(context);
                                },
                                negativeClick: () {
                                  Navigator.pop(context);
                                },
                                img: Icon(
                                  Icons.monetization_on,
                                  color: AppThemData.primary500,
                                  size: 40,
                                ),
                              );
                            });
                      } else {
                        DriverUserModel? receiverUserModel = await FireStoreUtils.getDriverUserProfile(controller.bookingModel.value.driverId.toString());
                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.bookingModel.value.id};
                        await SendNotification.sendOneNotification(
                            type: "order",
                            token: receiverUserModel!.fcmToken.toString(),
                            title: 'Payment Method Changed'.tr,
                            body: 'Customer has opted to pay with ${controller.selectedPaymentMethod.value}',
                            bookingId: controller.bookingModel.value.id,
                            driverId: controller.bookingModel.value.driverId.toString(),
                            senderId: FireStoreUtils.getCurrentUid(),
                            payload: playLoad);
                        Navigator.pop(context);
                      }
                    },
                    size: const Size(210, 52),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
