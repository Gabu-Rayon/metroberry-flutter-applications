import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? bannerDescription;
  String? bannerName;
  String? id;
  String? image;
  bool? isOfferBanner;
  String? offerText;
  Timestamp? createdAt;

  BannerModel({
    this.bannerDescription,
    this.bannerName,
    this.id,
    this.image,
    this.isOfferBanner,
    this.offerText,
    this.createdAt,
  });

  factory BannerModel.fromRawJson(String str) => BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        bannerDescription: json["bannerDescription"],
        bannerName: json["bannerName"],
        id: json["id"],
        image: json["image"],
        isOfferBanner: json["isOfferBanner"],
        offerText: json["offerText"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "bannerDescription": bannerDescription,
        "bannerName": bannerName,
        "id": id,
        "image": image,
        "isOfferBanner": isOfferBanner,
        "offerText": offerText,
        "createdAt": createdAt,
      };
}
