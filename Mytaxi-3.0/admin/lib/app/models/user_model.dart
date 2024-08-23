import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? slug;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? gender;
  bool? isActive;
  Timestamp? createdAt;

  UserModel(
      {this.fullName,
      this.slug,
      this.id,
      this.isActive,
      this.dateOfBirth,
      this.email,
      this.loginType,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.walletAmount,
      this.gender,
      this.createdAt});

  @override
  String toString() {
    return 'UserModel{fullName: $fullName, slug: $slug, id: $id, email: $email, loginType: $loginType, profilePic: $profilePic, dateOfBirth: $dateOfBirth, fcmToken: $fcmToken, countryCode: $countryCode, phoneNumber: $phoneNumber, walletAmount: $walletAmount, gender: $gender, isActive: $isActive, createdAt: $createdAt}';
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'] ?? "";
    slug = json['slug'] ?? "";
    id = json['id'] ?? "";
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'] ?? "";
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['slug'] = slug;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive;
    return data;
  }
}
