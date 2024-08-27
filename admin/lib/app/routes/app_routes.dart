// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN_PAGE = _Paths.LOGIN_PAGE;
  static const DASHBOARD_SCREEN = _Paths.DASHBOARD_SCREEN;
  static const BOOKING_HISTORY_SCREEN = _Paths.BOOKING_HISTORY_SCREEN;
  static const PASSENGERS_SCREEN = _Paths.PASSENGERS_SCREEN;
  static const DRIVER_SCREEN = _Paths.DRIVER_SCREEN;
  static const VERIFY_DOCUMENT_SCREEN = _Paths.VERIFY_DOCUMENT_SCREEN;
  static const BANNER_SCREEN = _Paths.BANNER_SCREEN;
  static const DOCUMENT_SCREEN = _Paths.DOCUMENT_SCREEN;
  static const COUPON_SCREEN = _Paths.COUPON_SCREEN;
  static const VEHICLE_BRAND_SCREEN = _Paths.VEHICLE_BRAND_SCREEN;
  static const VEHICLE_MODEL_SCREEN = _Paths.VEHICLE_MODEL_SCREEN;
  static const SETTING_SCREEN = _Paths.SETTING_SCREEN;
  static const PAYOUT_REQUEST = _Paths.PAYOUT_REQUEST;
  static const PAYMENT = _Paths.PAYMENT;
  static const TAX = _Paths.TAX;
  static const CURRENCY = _Paths.CURRENCY;
  static const APP_SETTINGS = _Paths.APP_SETTINGS;
  static const LANGUAGE = _Paths.LANGUAGE;
  static const ABOUT_APP = _Paths.ABOUT_APP;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
  static const TERMS_CONDITIONS = _Paths.TERMS_CONDITIONS;
  static const GENERAL_SETTING = _Paths.GENERAL_SETTING;
  static const CONTACT_US = _Paths.CONTACT_US;
  static const BOOKING_DETAIL = _Paths.BOOKING_DETAIL;
  static const CANCELING_REASON = _Paths.CANCELING_REASON;
  static const ADMIN_PROFILE = _Paths.ADMIN_PROFILE;
  static const VEHICLE_TYPE_SCREEN = _Paths.VEHICLE_TYPE_SCREEN;
  static const ERROR_SCREEN = _Paths.ERROR_SCREEN;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const PASSENGERS_DETAIL_SCREEN = _Paths.PASSENGERS_DETAIL_SCREEN;
  static const DRIVER_DETAIL_SCREEN = _Paths.DRIVER_DETAIL_SCREEN;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN_PAGE = '/login-page';
  static const DASHBOARD_SCREEN = '/dashboard-screen';
  static const BOOKING_HISTORY_SCREEN = '/booking-history-screen';
  static const PASSENGERS_SCREEN = '/passengers-screen';
  static const DRIVER_SCREEN = '/driver-screen';
  static const VERIFY_DOCUMENT_SCREEN = '/verify-document-screen';
  static const BANNER_SCREEN = '/banner-screen';
  static const DOCUMENT_SCREEN = '/document-screen';
  static const COUPON_SCREEN = '/coupon-screen';
  static const VEHICLE_BRAND_SCREEN = '/vehicle-screen';
  static const VEHICLE_MODEL_SCREEN = '/vehicle-model-screen';
  static const SETTING_SCREEN = '/setting-screen';
  static const PAYOUT_REQUEST = '/payout-request';
  static const PAYMENT = '/payment';
  static const TAX = '/tax';
  static const CURRENCY = '/currency';
  static const APP_SETTINGS = '/app-settings';
  static const LANGUAGE = '/language';
  static const ABOUT_APP = '/about-app';
  static const PRIVACY_POLICY = '/privacy-policy';
  static const TERMS_CONDITIONS = '/terms-conditions';
  static const GENERAL_SETTING = '/general-setting';
  static const CONTACT_US = '/contact-us';
  static const BOOKING_DETAIL = '/booking-detail';
  static const CANCELING_REASON = '/canceling-reason';
  static const ADMIN_PROFILE = '/admin-profile';
  static const VEHICLE_TYPE_SCREEN = '/vehicle-type-screen';
  static const ERROR_SCREEN = '/page-not-found';
  static const SPLASH_SCREEN = '/splash-screen';
  static const PASSENGERS_DETAIL_SCREEN = '/passengers-detail-screen';
  static const DRIVER_DETAIL_SCREEN = '/driver-detail-screen';
}
