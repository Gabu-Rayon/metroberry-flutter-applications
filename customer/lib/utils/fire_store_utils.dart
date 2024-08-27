import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/admin_commission.dart';
import 'package:customer/app/models/banner_model.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/app/models/currencies_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/language_model.dart';
import 'package:customer/app/models/notification_model.dart';
import 'package:customer/app/models/payment_method_model.dart';
import 'package:customer/app/models/review_customer_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/app/models/wallet_transaction_model.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.users).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.users).doc(userModel.id).set(userModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<UserModel?> getUserProfile(String uuid) async {
    UserModel? userModel;
    await fireStore.collection(CollectionName.users).doc(uuid).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<bool?> deleteUser() async {
    bool? isDelete;
    try {
      await fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).delete();

      // delete user  from firebase auth
      await FirebaseAuth.instance.currentUser!.delete().then((value) {
        isDelete = true;
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isDelete;
  }

  static Future<bool?> updateUserWallet({required String amount}) async {
    bool isAdded = false;
    await getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
      if (value != null) {
        UserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateOtherUserWallet({required String amount, required String id}) async {
    bool isAdded = false;
    await getDriverUserProfile(id).then((value) async {
      if (value != null) {
        DriverUserModel driverUserModel = value;
        driverUserModel.walletAmount = (double.parse(driverUserModel.walletAmount.toString()) + double.parse(amount)).toStringAsFixed(2).toString();
        driverUserModel.totalEarning = (double.parse(driverUserModel.totalEarning.toString()) + double.parse(amount)).toStringAsFixed(2).toString();
        await FireStoreUtils.updateDriverUser(driverUserModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore.collection(CollectionName.currency).where("active", isEqualTo: true).get().then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  getSettings() async {
    await fireStore.collection(CollectionName.settings).doc("constant").get().then((value) {
      if (value.exists) {
        Constant.mapAPIKey = value.data()!["googleMapKey"];
        Constant.senderId = value.data()!["notification_senderId"];
        Constant.jsonFileURL = value.data()!["jsonFileURL"];
        Constant.minimumAmountToWithdrawal = value.data()!["minimum_amount_withdraw"];
        Constant.minimumAmountToDeposit = value.data()!["minimum_amount_deposit"];
        Constant.appName = value.data()!["appName"];
        Constant.appColor = value.data()!["appColor"];
        Constant.termsAndConditions = value.data()!["termsAndConditions"];
        Constant.privacyPolicy = value.data()!["privacyPolicy"];
        Constant.aboutApp = value.data()!["aboutApp"];
      }
    });
    await fireStore.collection(CollectionName.settings).doc("globalValue").get().then((value) {
      if (value.exists) {
        Constant.distanceType = value.data()!["distanceType"];
        Constant.driverLocationUpdate = value.data()!["driverLocationUpdate"];
        Constant.radius = value.data()!["radius"];
      }
    });
    await fireStore.collection(CollectionName.settings).doc("canceling_reason").get().then((value) {
      if (value.exists) {
        Constant.cancellationReason = value.data()!["reasons"];
      }
    });

    // await fireStore.collection(CollectionName.settings).doc("global").get().then((value) {
    //   if (value.exists) {
    //     Constant.termsAndConditions = value.data()!["termsAndConditions"];
    //     Constant.privacyPolicy = value.data()!["privacyPolicy"];
    //     // Constant.appVersion = value.data()!["appVersion"];
    //   }
    // });

    await fireStore.collection(CollectionName.settings).doc("admin_commission").get().then((value) {
      AdminCommission adminCommission = AdminCommission.fromJson(value.data()!);
      if (adminCommission.active == true) {
        Constant.adminCommission = adminCommission;
      }
    });

    // await fireStore.collection(CollectionName.settings).doc("referral").get().then((value) {
    //   if (value.exists) {
    //     Constant.referralAmount = value.data()!["referralAmount"];
    //   }
    // });
    //
    // await fireStore.collection(CollectionName.settings).doc("contact_us").get().then((value) {
    //   if (value.exists) {
    //     Constant.supportURL = value.data()!["supportURL"];
    //   }
    // });
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore.collection(CollectionName.settings).doc("payment").get().then((value) {
      paymentModel = PaymentModel.fromJson(value.data()!);
      Constant.paymentModel = PaymentModel.fromJson(value.data()!);
    });
    print("Payment Data : ${json.encode(paymentModel!.toJson().toString())}");
    return paymentModel;
  }

  static Future<List<VehicleTypeModel>?> getVehicleType() async {
    List<VehicleTypeModel> vehicleTypeList = [];
    await fireStore.collection(CollectionName.vehicleType).where("isActive", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        VehicleTypeModel vehicleTypeModel = VehicleTypeModel.fromJson(element.data());
        vehicleTypeList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return vehicleTypeList;
  }

  Future<List<TaxModel>?> getTaxList() async {
    List<TaxModel> taxList = [];

    await fireStore.collection(CollectionName.countryTax).where('country', isEqualTo: Constant.country).where('active', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        TaxModel taxModel = TaxModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<List<CouponModel>?> getCoupon() async {
    List<CouponModel> couponList = [];
    await fireStore
        .collection(CollectionName.coupon)
        .where("active", isEqualTo: true)
        .where("isPrivate", isEqualTo: false)
        .where('expireAt', isGreaterThanOrEqualTo: Timestamp.now())
        .get()
        .then((value) {
      for (var element in value.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());
        couponList.add(couponModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return couponList;
  }

  static Future<bool?> setBooking(BookingModel bookingModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.bookings).doc(bookingModel.id).set(bookingModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to add ride: $error");
      isAdded = false;
    });
    return isAdded;
  }

  StreamController<List<DriverUserModel>>? getNearestDriverController;

  Future<List<DriverUserModel>> sendOrderData(BookingModel bookingModel) async {
    getNearestDriverController = StreamController<List<DriverUserModel>>.broadcast();

    List<DriverUserModel> ordersList = [];
    List<String> driverIdList = [];
    Query query =
        fireStore.collection(CollectionName.driverUsers).where('driverVehicleDetails.vehicleTypeId', isEqualTo: bookingModel.vehicleType!.id).where('isOnline', isEqualTo: true);
    GeoFirePoint center = GeoFlutterFire().point(latitude: bookingModel.pickUpLocation!.latitude ?? 0.0, longitude: bookingModel.pickUpLocation!.longitude ?? 0.0);
    Stream<List<DocumentSnapshot>> stream =
        GeoFlutterFire().collection(collectionRef: query).within(center: center, radius: double.parse(Constant.radius), field: 'position', strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) async {
      ordersList.clear();
      if (getNearestDriverController != null) {
        for (var document in documentList) {
          final data = document.data() as Map<String, dynamic>;
          DriverUserModel driverUserModel = DriverUserModel.fromJson(data);
          ordersList.add(driverUserModel);
          if (driverUserModel.fcmToken != null && !driverIdList.contains(driverUserModel.id)) {
            driverIdList.add(driverUserModel.id ?? '');
            Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};
            await SendNotification.sendOneNotification(
                type: "order",
                token: driverUserModel.fcmToken.toString(),
                title: 'New Ride Available'.tr,
                body: 'A customer has placed an ride near your location.'.tr,
                bookingId: bookingModel.id,
                senderId: FireStoreUtils.getCurrentUid(),
                payload: playLoad);
          }

          if (!getNearestDriverController!.isClosed) {
            getNearestDriverController!.sink.add(ordersList);
          }
        }
      }
    });
    log("------>$getNearestDriverController");
    getNearestDriverController!.close();
    log("------>${getNearestDriverController!.isClosed}");
    return ordersList;
  }

  closeStream() {
    log("------>$getNearestDriverController");
    if (getNearestDriverController != null) {
      log("==================>getNearestDriverController.close()");
      getNearestDriverController == null;
      getNearestDriverController!.close();
    }
  }

  StreamController<List<BookingModel>>? getHomeOngoingBookingController;

  Stream<List<BookingModel>> getHomeOngoingBookings() async* {
    getHomeOngoingBookingController = StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];
    String customerId = getCurrentUid();
    Stream<QuerySnapshot> stream1 = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', whereIn: [BookingStatus.bookingAccepted, BookingStatus.bookingPlaced, BookingStatus.bookingOngoing])
        .where("customerId", isEqualTo: customerId)
        .orderBy("createAt", descending: true)
        .snapshots();
    stream1.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        bookingsList.add(bookingModel);
      }
      // final closetsDateTimeToNow = bookingsList.reduce(
      //         (a, b) => (a.bookingTime!).toDate().difference(DateTime.now()).abs() < (b.bookingTime!).toDate().difference(DateTime.now()).abs() ? a : b);

      getHomeOngoingBookingController!.sink.add(bookingsList);
    });

    yield* getHomeOngoingBookingController!.stream;
  }

  closeHomeOngoingStream() {
    if (getHomeOngoingBookingController != null) {
      getHomeOngoingBookingController!.close();
    }
  }

  StreamController<BookingModel>? getBookingStatusController;

  Stream<BookingModel> getBookingStatusData(String bookingId) async* {
    getBookingStatusController ??= StreamController<BookingModel>.broadcast();

    Stream<QuerySnapshot> stream = fireStore.collection(CollectionName.bookings).where('id', isEqualTo: bookingId).snapshots();
    stream.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      for (var document in querySnapshot.docs) {
        if (getBookingStatusController != null) {
          final data = document.data() as Map<String, dynamic>;
          BookingModel bookingModel = BookingModel.fromJson(data);
          if ((bookingModel.bookingStatus ?? '') == BookingStatus.bookingOngoing) {
            ShowToastDialog.showToast("Your ride started...");
            Get.offAll(const HomeView());
          } else {}
          if (!getBookingStatusController!.isClosed) {
            getBookingStatusController!.sink.add(bookingModel);
          }
        }
      }
    });
    yield* getBookingStatusController!.stream;
  }

  closeBookingStatusStream() {
    if (getBookingStatusController != null) {
      getBookingStatusController == null;
      getBookingStatusController!.close();
    }
  }

  static Future<BookingModel?> getRideDetails(String bookingId) async {
    BookingModel? bookingModel;
    await fireStore.collection(CollectionName.bookings).where("id", isEqualTo: bookingId).get().then((value) {
      for (var element in value.docs) {
        bookingModel = BookingModel.fromJson(element.data());
      }
    }).catchError((error) {
      log(error.toString());
    });
    return bookingModel;
  }

  static Future<List<BookingModel>?> getOngoingRides() async {
    String customerId = getCurrentUid();
    List<BookingModel> bookingList = [];
    await fireStore
        .collection(CollectionName.bookings)
        .where("customerId", isEqualTo: customerId)
        .where('bookingStatus', whereIn: [BookingStatus.bookingPlaced, BookingStatus.bookingAccepted, BookingStatus.bookingOngoing])
        .orderBy("createAt", descending: true)
        .get()
        .then((value) {
          for (var element in value.docs) {
            BookingModel vehicleTypeModel = BookingModel.fromJson(element.data());
            bookingList.add(vehicleTypeModel);
          }
        })
        .catchError((error) {
          log(error.toString());
        });
    return bookingList;
  }

  static Future<List<BookingModel>?> getCompletedRides() async {
    String customerId = getCurrentUid();
    List<BookingModel> bookingList = [];
    await fireStore
        .collection(CollectionName.bookings)
        .where("customerId", isEqualTo: customerId)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCompleted)
        .orderBy("createAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        BookingModel vehicleTypeModel = BookingModel.fromJson(element.data());
        bookingList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return bookingList;
  }

  static Future<List<BookingModel>?> getRejectedRides() async {
    String customerId = getCurrentUid();
    List<BookingModel> bookingList = [];
    await fireStore
        .collection(CollectionName.bookings)
        .where("customerId", isEqualTo: customerId)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCancelled)
        .orderBy("createAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        BookingModel vehicleTypeModel = BookingModel.fromJson(element.data());
        bookingList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return bookingList;
  }

  static Future<DriverUserModel?> getDriverUserProfile(String uuid) async {
    DriverUserModel? userModel;
    await fireStore.collection(CollectionName.driverUsers).doc(uuid).get().then((value) {
      if (value.exists) {
        userModel = DriverUserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to get user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    log("====> 3");
    await fireStore.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModelList = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
        .where('type', isEqualTo: "customer")
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WalletTransactionModel walletTransactionModel = WalletTransactionModel.fromJson(element.data());
        walletTransactionModelList.add(walletTransactionModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModelList;
  }

  static Future<ReviewModel?> getReview(String orderId) async {
    ReviewModel? reviewModel;
    await fireStore.collection(CollectionName.review).doc(orderId).get().then((value) {
      if (value.data() != null) {
        reviewModel = ReviewModel.fromJson(value.data()!);
      }
    });
    return reviewModel;
  }

  static Future<bool?> setReview(ReviewModel reviewModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.review).doc(reviewModel.id).set(reviewModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool> updateDriverUser(DriverUserModel userModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.drivers).doc(userModel.id).set(userModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<NotificationModel>?> getNotificationList() async {
    List<NotificationModel> notificationModel = [];
    await fireStore
        .collection(CollectionName.notification)
        .where('customerId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        NotificationModel taxModel = NotificationModel.fromJson(element.data());
        notificationModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return notificationModel;
  }

  static Future<bool?> setNotification(NotificationModel notificationModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.notification).doc(notificationModel.id).set(notificationModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<BannerModel>?> getBannerList() async {
    List<BannerModel> bannerList = [];
    await fireStore.collection(CollectionName.banner).where("isEnable", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        BannerModel bannerModel = BannerModel.fromJson(element.data());
        bannerList.add(bannerModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return bannerList;
  }

  static Future<List<LanguageModel>> getLanguage() async {
    List<LanguageModel> languageModelList = [];
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.languages).get();
    for (var document in snap.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        languageModelList.add(LanguageModel.fromJson(data));
      } else {
        print('getLanguage is null ');
      }
    }
    return languageModelList;
  }
}
