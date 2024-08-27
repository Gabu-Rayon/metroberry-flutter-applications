// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:customer/app/models/banner_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  RxString profilePic = "https://firebasestorage.googleapis.com/v0/b/mytaxi-a8627.appspot.com/o/constant_assets%2F59.png?alt=media&token=a0b1aebd-9c01-45f6-9569-240c4bc08e23".obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  PageController pageController = PageController();
  RxInt curPage = 0.obs;
  RxInt drawerIndex = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getUserData();
    updateCurrentLocation();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getUserData() async {
    isLoading.value = true;

    UserModel? userModel = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());
    if (userModel != null) {
      profilePic.value = (userModel.profilePic ?? "").isNotEmpty
          ? userModel.profilePic ??
              "https://firebasestorage.googleapis.com/v0/b/mytaxi-a8627.appspot.com/o/constant_assets%2F59.png?alt=media&token=a0b1aebd-9c01-45f6-9569-240c4bc08e23"
          : "https://firebasestorage.googleapis.com/v0/b/mytaxi-a8627.appspot.com/o/constant_assets%2F59.png?alt=media&token=a0b1aebd-9c01-45f6-9569-240c4bc08e23";
      name.value = userModel.fullName ?? '';
      phoneNumber.value = (userModel.countryCode ?? '') + (userModel.phoneNumber ?? '');
      userModel.fcmToken = await NotificationService.getToken();
      await FireStoreUtils.updateUser(userModel);
      await FireStoreUtils.getBannerList().then((value) {
        bannerList.value = value ?? [];
      });
    }
    await Utils.getCurrentLocation();
  }

  Location location = Location();

  updateCurrentLocation() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
      location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdate.toString()), interval: 2000);
      location.onLocationChanged.listen((locationData) {
        log("------>");
        log(locationData.toString());
        Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
        // FireStoreUtils
        //     .getDriverUserProfile(FireStoreUtils.getCurrentUid())
        //     .then((value) {
        //   // DriverUserModel driverUserModel = value!;
        //   // if (driverUserModel.isOnline == true) {
        //   //   driverUserModel.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
        //   //   GeoFirePoint position = GeoFlutterFire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);
        //
        //   // driverUserModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
        //   // driverUserModel.rotation = locationData.heading;
        //   // FireStoreUtils.updateDriverUser(driverUserModel);
        // // }
        //     });
        log("------>1");
      });
    } else {
      location.requestPermission().then((permissionStatus) {
        log("------>3");
        if (permissionStatus == PermissionStatus.granted) {
          location.enableBackgroundMode(enable: true);
          location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdate.toString()), interval: 2000);
          location.onLocationChanged.listen((locationData) async {
            Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
            log("------>4");

            // FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
            //   DriverUserModel driverUserModel = value!;
            //   if (driverUserModel.isOnline == true) {
            //     driverUserModel.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
            //     driverUserModel.rotation = locationData.heading;
            //     GeoFirePoint position = GeoFlutterFire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);
            //
            //     driverUserModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
            //
            //     FireStoreUtils.updateDriverUser(driverUserModel);
            //   }
            // });
          });
        }
        log("------>5");
      });
      log("------>6");
    }
    isLoading.value = false;
    update();
  }
}
