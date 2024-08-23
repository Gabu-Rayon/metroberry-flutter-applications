// ignore_for_file: non_constant_identifier_names

class ConstantModel {
  String? googleMapKey;
  String? jsonFileURL;
  String? minimumAmountDeposit;
  String? minimumAmountWithdraw;
  String? notificationServerKey;
  String? privacyPolicy;
  String? termsAndConditions;
  String? aboutApp;
  String? appColor;
  String? appName;

  ConstantModel({
    this.googleMapKey,
    this.jsonFileURL,
    this.minimumAmountDeposit,
    this.minimumAmountWithdraw,
    this.notificationServerKey,
    this.privacyPolicy,
    this.termsAndConditions,
    this.aboutApp,
    this.appColor,
    this.appName,
  });

  ConstantModel.fromJson(Map<String, dynamic> json) {
    googleMapKey = json['googleMapKey'];
    jsonFileURL = json['jsonFileURL'];
    minimumAmountDeposit = json['minimum_amount_deposit'];
    minimumAmountWithdraw = json['minimum_amount_withdraw'];
    notificationServerKey = json['notification_senderId'];
    privacyPolicy = json['privacyPolicy'];
    termsAndConditions = json['termsAndConditions'];
    aboutApp = json['aboutApp'];
    appColor = json['appColor'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['googleMapKey'] = googleMapKey ?? "";
    data['jsonFileURL'] = jsonFileURL ?? "";
    data['minimum_amount_deposit'] = minimumAmountDeposit ?? "";
    data['minimum_amount_withdraw'] = minimumAmountWithdraw ?? "";
    data['notification_senderId'] = notificationServerKey ?? "";
    data['privacyPolicy'] = privacyPolicy ?? "";
    data['termsAndConditions'] = termsAndConditions ?? "";
    data['aboutApp'] = aboutApp ?? "";
    data['appColor'] = appColor ?? "";
    data['appName'] = appName ?? "";
    return data;
  }
}
