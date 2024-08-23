import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/app_ar.dart';
import '../lang/app_en.dart';
import '../lang/app_hi.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static final locales = [
    const Locale('en'),
    const Locale('hi'),
    const Locale('ar'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS,
        'hi': hiIN,
        'ar': lnAr,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    Get.updateLocale(Locale(lang));
  }
}
