import 'package:admin/app/modules/about_app/views/about_app_view.dart';
import 'package:admin/app/modules/app_settings/views/app_settings_view.dart';
import 'package:admin/app/modules/canceling_reason/views/canceling_reason_view.dart';
import 'package:admin/app/modules/contact_us/views/contact_us_view.dart';
import 'package:admin/app/modules/currency/views/currency_view.dart';
import 'package:admin/app/modules/general_setting/views/general_setting_view.dart';
import 'package:admin/app/modules/language/views/language_view.dart';
import 'package:admin/app/modules/payment/views/payment_view.dart';
import 'package:admin/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:admin/app/modules/tax/views/tax_view.dart';
import 'package:admin/app/modules/terms_Conditions/views/terms_conditions_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenController extends GetxController {
  RxString title = "Settings".obs;
  final GlobalKey<ScaffoldState> scaffoldKeysDrawer = GlobalKey<ScaffoldState>();
  // RxBool isDrawerOpen = false.obs;
  //
  // void toggleDrawer() {
  //   final GlobalKey<ScaffoldState> scaffoldKey = scaffoldKeysDrawer;
  //   scaffoldKey.currentState?.openDrawer();
  // }

  Rx<SettingsItem> selectSettingWidget =
      SettingsItem(title: ['General Settings'], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0).obs;
  final settingsAllPage = [
    SettingsItem(title: ['General Settings'], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0),
    SettingsItem(title: ['App Settings'], icon: "assets/icons/ic_app_setting.svg", widget: [const AppSettingsView()], selectIndex: 0),
    SettingsItem(title: ['Payment'], icon: "assets/icons/ic_payment.svg", widget: [const PaymentView()], selectIndex: 0),
    SettingsItem(title: ['Taxes'], icon: "assets/icons/ic_tax.svg", widget: [const TaxView()], selectIndex: 0),
    SettingsItem(title: ['Currency'], icon: "assets/icons/ic_currency.svg", widget: [const CurrencyView()], selectIndex: 0),
    SettingsItem(title: ['Languages'], icon: "assets/icons/ic_earth.svg", widget: [const LanguageView()], selectIndex: 0),
    SettingsItem(title: ['Canceling Reason'], icon: "assets/icons/ic_canceling_reason.svg", widget: [const CancelingReasonView()], selectIndex: 0),
    SettingsItem(title: ['About App'], icon: "assets/icons/ic_about_app.svg", widget: [AboutAppView()], selectIndex: 0),
    SettingsItem(title: ['Privacy Policy'], icon: "assets/icons/ic_privacy_policy.svg", widget: [PrivacyPolicyView()], selectIndex: 0),
    SettingsItem(title: ['Terms & Condition'], icon: "assets/icons/ic_terms_&_condition.svg", widget: [TermsConditionsView()], selectIndex: 0),
    SettingsItem(title: ['Contact us'], icon: "assets/icons/ic_contacts.svg", widget: [const ContactUsView()], selectIndex: 0),
  ];
}

class SettingsItem {
  List<String>? title;
  String? icon;
  List<Widget>? widget;
  int? selectIndex;

  SettingsItem({this.title, this.icon, this.widget, this.selectIndex});
}
