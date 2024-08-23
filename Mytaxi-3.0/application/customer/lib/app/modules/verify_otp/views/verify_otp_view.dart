import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/signup/views/signup_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<VerifyOtpController>(
        init: VerifyOtpController(),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              bool isFocus = FocusScope.of(context).hasFocus;
              if (isFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              appBar: AppBar(
                backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_rounded)),
                iconTheme: IconThemeData(color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 31),
                child: Column(
                  children: [
                    Text(
                      "Verify Your Phone Number".tr,
                      style: GoogleFonts.inter(fontSize: 24, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 33),
                      child: Text(
                        "Enter  6-digit code sent to your mobile number to complete verification.".tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                    OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 40,
                      style: GoogleFonts.inter(fontSize: 16, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w500),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      otpFieldStyle: OtpFieldStyle(
                        focusBorderColor: AppThemData.primary500,
                        borderColor: AppThemData.grey100,
                        enabledBorderColor: AppThemData.grey100,
                      ),
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) async {
                        if (pin.length == 6) {
                          ShowToastDialog.showLoader("verify_OTP".tr);
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: pin);
                          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                            if (value.additionalUserInfo!.isNewUser) {
                              String fcmToken = await NotificationService.getToken();
                              UserModel userModel = UserModel();
                              userModel.id = value.user!.uid;
                              userModel.countryCode = controller.countryCode.value;
                              userModel.phoneNumber = controller.phoneNumber.value;
                              userModel.loginType = Constant.phoneLoginType;
                              userModel.fcmToken = fcmToken;

                              ShowToastDialog.closeLoader();
                              Get.off(const SignupView(), arguments: {
                                "userModel": userModel,
                              });
                            } else {
                              await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
                                ShowToastDialog.closeLoader();
                                if (userExit == true) {
                                  UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                  if (userModel != null) {
                                    if (userModel.isActive == true) {
                                      Get.offAll(const HomeView());
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      ShowToastDialog.showToast("user_disable_admin_contact".tr);
                                    }
                                  }
                                } else {
                                  String fcmToken = await NotificationService.getToken();
                                  UserModel userModel = UserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.countryCode = controller.countryCode.value;
                                  userModel.phoneNumber = controller.phoneNumber.value;
                                  userModel.loginType = Constant.phoneLoginType;
                                  userModel.fcmToken = fcmToken;

                                  Get.off(const SignupView(), arguments: {
                                    "userModel": userModel,
                                  });
                                }
                              });
                            }
                          }).catchError((error) {
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("invalid_code".tr);
                          });
                        } else {
                          controller.otpCode.value = pin;
                        }
                      },
                    ),
                    const SizedBox(height: 90),
                    RoundShapeButton(
                        size: const Size(200, 45),
                        title: "verify_OTP".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () async {
                          if (controller.otpCode.value.length == 6) {
                            ShowToastDialog.showLoader("verify_OTP".tr);
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: controller.otpCode.value);
                            String fcmToken = await NotificationService.getToken();
                            await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                              if (value.additionalUserInfo!.isNewUser) {
                                UserModel userModel = UserModel();
                                userModel.id = value.user!.uid;
                                userModel.countryCode = controller.countryCode.value;
                                userModel.phoneNumber = controller.phoneNumber.value;
                                userModel.loginType = Constant.phoneLoginType;
                                userModel.fcmToken = fcmToken;

                                ShowToastDialog.closeLoader();
                                Get.off(const SignupView(), arguments: {
                                  "userModel": userModel,
                                });
                              } else {
                                await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
                                  ShowToastDialog.closeLoader();
                                  if (userExit == true) {
                                    UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                    if (userModel != null) {
                                      if (userModel.isActive == true) {
                                        Get.offAll(const HomeView());
                                      } else {
                                        await FirebaseAuth.instance.signOut();
                                        ShowToastDialog.showToast("user_disable_admin_contact".tr);
                                      }
                                    }
                                  } else {
                                    UserModel userModel = UserModel();
                                    userModel.id = value.user!.uid;
                                    userModel.countryCode = controller.countryCode.value;
                                    userModel.phoneNumber = controller.phoneNumber.value;
                                    userModel.loginType = Constant.phoneLoginType;
                                    userModel.fcmToken = fcmToken;

                                    Get.off(const SignupView(), arguments: {
                                      "userModel": userModel,
                                    });
                                  }
                                });
                              }
                            }).catchError((error) {
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast("invalid_code".tr);
                            });
                          } else {
                            ShowToastDialog.showToast("enter_valid_otp".tr);
                          }
                        }),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            controller.sendOTP();
                          },
                        children: [
                          TextSpan(
                            text: 'Did’t Receive a code ?'.tr,
                            style: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey400, fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: ' ${'Resend Code'.tr}',
                            style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w600),
                          ),
                        ],
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
