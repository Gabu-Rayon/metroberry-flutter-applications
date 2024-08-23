// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:admin/app/models/admin_commission_model.dart';
import 'package:admin/app/models/admin_model.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/models/currency_model.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/models/payment_method_model.dart';
import 'package:admin/app/models/tax_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum Status { active, inactive }

class Constant {
  static const userPlaceHolder = 'assets/image/user_placeholder.png';
  static List<String> numOfPageIemList = ['10', '20', '50', '100'];
  static bool isDemo = true;
  static ConstantModel? constantModel;
  static UserModel? userModel;
  static AdminModel? adminModel;
  static PaymentModel? paymentModel;
  static String mapAPIKey = "";
  static String? appColor;
  static String? appName;
  static String googleMapKey = "";
  static String distanceType = "KM";
  static String minimumAmountToDeposit = "100";
  static String minimumAmountToWithdrawal = "100";
  static String notificationServerKey = "";
  static AdminCommission? adminCommission;
  static CurrencyModel? currencyModel;
  static int? vehicleModelLength = 0;
  static int? vehicleBrandLength = 0;
  static int? usersLength = 0;
  static int? bookingLength = 0;
  static int? driverLength = 0;
  static BoxShadow boxShadow = BoxShadow(offset: const Offset(2, 3), color: AppThemData.textBlack.withOpacity(.2), blurRadius: .2, spreadRadius: .2);
  static BoxDecoration boxDecoration = BoxDecoration(
    color: AppThemData.primaryWhite,
    borderRadius: BorderRadius.circular(10),
  );
  static BoxDecoration searchBoxDecoration = BoxDecoration(
    color: AppThemData.lightGrey05,
    borderRadius: BorderRadius.circular(10),
  );

  static List<TaxModel>? taxList;

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();
  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static defaultTextStyle({double size = 24.00, Color color = Colors.black}) {
    return TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600, fontFamily: AppThemeData.medium);
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(color:AppThemData.primary500),
    );
  }

  static Widget CustomDivider() {
    return Padding(
      padding: paddingEdgeInsets(horizontal: 0, vertical: 5),
      child: const SizedBox(
        height: 1,
        child: ContainerCustom(),
      ),
    );
  }

  static waitingLoader() {
    Get.dialog(const Center(
      child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: AppThemData.lightGrey01,
          child: CircularProgressIndicator(
            color: AppThemData.primary500,
          )),
    ));
  }

  static String getUuid() {
    return const Uuid().v4();
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String timestampToDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy hh:mm aa').format(dateTime);
  }

  static bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static String timestampToTime12Hour(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime);
  }

  // static String amountShow({required String? amount}) {
  //   if (Constant.currencyModel!.symbolAtRight == true) {
  //     return "${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.currencyModel!.symbol.toString()}";
  //   } else {
  //     return "${Constant.currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
  //   }
  // }
  static String maskMobileNumber({String? mobileNumber, String? countryCode}) {
    // String code = countryCode.splitAfter("+");
    // code = "x" * code.length;

    String maskedNumber = 'x' * (mobileNumber!.length - 2) + mobileNumber.substring(mobileNumber.length - 2);
    return Constant.isDemo ? "$countryCode $maskedNumber" : "$countryCode $mobileNumber";
  }

  static String maskEmail({String? email}) {
    List<String> parts = email!.split('@');
    if (parts.length != 2) {
      throw ArgumentError("Invalid email address");
    }
    String username = parts[0];
    String domain = parts[1];
    String maskedUsername = username.substring(0, 2) + 'x' * (username.length - 2);
    return Constant.isDemo ? '$maskedUsername@$domain' : email;
  }

  static getAdminData() async {
    AdminModel adminModel = AdminModel();
    await FireStoreUtils.getAdmin().then((value) async {
      if (value != null) {
        adminModel = value;
        await AppSharedPreference.appSharedPreference.saveEmail(adminModel.email.toString());
        await AppSharedPreference.appSharedPreference.saveName(adminModel.name.toString());
        await AppSharedPreference.appSharedPreference.savePassword(adminModel.password.toString());
        if (kDebugMode) {
          print('--------->Run in debug');
          Constant.isDemo = false;
        } else {
          Constant.isDemo = adminModel.isDemo!;
        }
        // Constant.isDemo = false;
      }
    });
  }

  static getCurrencyData() async {
    await FireStoreUtils.getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, active: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
  }

  static String amountShow({required String? amount}) {
    if (amount == null || amount.isEmpty) {
      return "N/A"; // Return a default value or handle the case when amount is null or empty
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return "Invalid Amount"; // Return a message indicating that the amount is invalid
    }

    if (Constant.currencyModel != null) {
      if (Constant.currencyModel!.symbolAtRight == true) {
        return "${parsedAmount.toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.currencyModel!.symbol.toString()}";
      } else {
        return "${Constant.currencyModel!.symbol.toString()} ${parsedAmount.toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
      }
    }
    return '';
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static String amountToShow({required String? amount}) {
    if (Constant.currencyModel!.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}${Constant.currencyModel!.symbol.toString()}";
    } else {
      return "${Constant.currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
    }
  }

  static Future<LanguageModel> getLanguageData() async {
    final String language = await AppSharedPreference.getString(AppSharedPreference.languageCodeKey);
    if (language.isEmpty) {
      await AppSharedPreference.setString(AppSharedPreference.languageCodeKey, json.encode({"active": true, "code": "en", "id": "CcrGiUvJbPTXaU31s5l8", "name": "English"}));
      return LanguageModel.fromJson({"active": true, "code": "en", "id": "CcrGiUvJbPTXaU31s5l8", "name": "English"});
    }
    Map<String, dynamic> languageMap = jsonDecode(language);
    return LanguageModel.fromJson(languageMap);
  }

  String? validateRequired(String? value, String type) {
    if (value!.isEmpty) {
      return '$type required';
    }
    return null;
  }

  static double amountBeforeTax(BookingModel bookingModel) {
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString()));
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.active == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  static double calculateFinalAmount(BookingModel bookingModel) {
    RxString taxAmount = "0.0".obs;
    for (var element in (bookingModel.taxList ?? [])) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant.calculateTax(
                  amount: ((double.parse(bookingModel.subTotal ?? '0.0')) - double.parse((bookingModel.discount ?? '0.0').toString())).toString(), taxModel: element))
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
    }
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString())) + double.parse(taxAmount.value);
  }

  static String timestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm aa').format(dateTime);
  }

  static DefaultInputDecoration(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InputDecoration(
        iconColor: AppThemData.primary500,
        isDense: true,
        filled: true,
        fillColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
          ),
        ),
        hintText: "Select Brand",
        hintStyle: TextStyle(
            fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.greyShade400 : AppThemData.greyShade950, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium));
  }

  static bookingStatusText(BuildContext context, String? status) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: status == "booking_accepted"
            ? AppThemData.blue500.withOpacity(0.2)
            : status == "Pending"
                ? AppThemData.blue500.withOpacity(0.2)
                : status == "booking_ongoing"
                    ? AppThemData.yellow600.withOpacity(0.2)
                    : status == "booking_completed"
                        ? AppThemData.green500.withOpacity(0.2)
                        : status == "Complete"
                            ? AppThemData.green500.withOpacity(0.2)
                            : status == "booking_cancelled"
                                ? AppThemData.red500.withOpacity(0.2)
                                : status == "booking_rejected"
                                    ? AppThemData.secondary500.withOpacity(0.2)
                                    : status == "Rejected"
                                        ? AppThemData.secondary500.withOpacity(0.2)
                                        : status == "booking_placed"
                                            ? AppThemData.primary500.withOpacity(0.2)
                                            : AppThemData.greyShade800.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status == "booking_accepted"
            ? "Accepted"
            : status == "Pending"
                ? "Pending"
                : status == "booking_ongoing"
                    ? "OnGoing"
                    : status == "booking_completed"
                        ? "Completed"
                        : status == "Complete"
                            ? "Complete"
                            : status == "booking_cancelled"
                                ? "Cancelled"
                                : status == "booking_rejected"
                                    ? "Rejected"
                                    : status == "Rejected"
                                        ? "Rejected"
                                        : status == "booking_placed"
                                            ? "Placed"
                                            : "Unknown Status",
        style: TextStyle(
          color: status == "Pending"
              ? AppThemData.blue500
              : status == "booking_ongoing"
                  ? AppThemData.yellow600
                  : status == "booking_completed"
                      ? AppThemData.green500
                      : status == "Complete"
                          ? AppThemData.green500
                          : status == "booking_cancelled"
                              ? AppThemData.red500
                              : status == "booking_rejected"
                                  ? AppThemData.secondary500
                                  : status == "Rejected"
                                      ? AppThemData.secondary500
                                      : status == "booking_placed"
                                          ? AppThemData.primary500
                                          : AppThemData.greyShade800,
          fontFamily: AppThemeData.regular,
          fontSize: 12,
        ),
      ),
    );
  }


}

class StatusDetails {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  StatusDetails({required this.text, required this.textColor, required this.backgroundColor});
}
