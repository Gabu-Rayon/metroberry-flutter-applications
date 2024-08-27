import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/admin_commission_model.dart';
import 'package:admin/app/models/admin_model.dart';
import 'package:admin/app/models/banner_model.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/brand_model.dart';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/models/contact_us_model.dart';
import 'package:admin/app/models/coupon_model.dart';
import 'package:admin/app/models/currency_model.dart';
import 'package:admin/app/models/documents_model.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/global_value_model.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/models/model_vehicle_model.dart';
import 'package:admin/app/models/payment_method_model.dart';
import 'package:admin/app/models/payout_request_model.dart';
import 'package:admin/app/models/tax_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
import 'package:admin/app/models/verify_driver_model.dart';
import 'package:admin/app/models/wallet_transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.users).doc(uid).get().then(
      (value) {
        if (value.exists) {
          Constant.userModel = UserModel.fromJson(value.data()!);
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

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static getSettings() async {
    await fireStore.collection(CollectionName.settings).doc("constant").get().then((value) {
      if (value.exists) {
        Constant.appColor = value.data()!["appColor"];
        Constant.appName = value.data()!["appName"];
        Constant.distanceType = value.data()!["distanceType"] ?? "KM";
        Constant.googleMapKey = value.data()!["googleMapKey"] ?? "";
        Constant.minimumAmountToDeposit = value.data()!["minimum_amount_deposit"];
        Constant.minimumAmountToWithdrawal = value.data()!["minimum_amount_withdraw"];
        Constant.notificationServerKey = value.data()!["notification_server_key"] ?? "";
      }
    });

    await fireStore.collection(CollectionName.settings).doc("admin_commission").get().then((value) {
      Constant.adminCommission = AdminCommission.fromJson(value.data()!);
    });
  }

  static Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore.collection(CollectionName.currencies).where("active", isEqualTo: true).get().then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  static Future<int> countUsers() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.users);
    AggregateQuerySnapshot query = await userList.count().get();
    log('The number of users: ${query.count}');
    Constant.usersLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countSearchUsers(String searchQuery, String searchType) async {
    final Query<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.users).where(
          searchType,
          isGreaterThanOrEqualTo: searchQuery,
          isLessThan: "$searchQuery\uf8ff",
        );
    AggregateQuerySnapshot query = await userList.count().get();
    log('The number of search users: ${query.count}');
    Constant.usersLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<List<UserModel>> getUsers(int pageNumber, int pageSize, String searchQuery, String searchType) async {
    List<UserModel> userList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.users)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.users)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.users)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore.collection(CollectionName.users).orderBy('createdAt', descending: true).limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore.collection(CollectionName.users).orderBy('createdAt', descending: true).startAfterDocument(lastDocument).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.users).orderBy('createdAt', descending: true).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              UserModel userModel = UserModel.fromJson(element.data());
              userList.add(userModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      }
    } catch (error) {
      log(error.toString());
    }
    return userList;
  }

  static Future<List<UserModel>> getRecentUsers() async {
    List<UserModel> usersModelList = [];
    await fireStore.collection(CollectionName.users).orderBy('createdAt', descending: true).limit(5).get().then((value) {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromJson(element.data());
        usersModelList.add(userModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return usersModelList;
  }

  // static Future<List<BookingModel>> getBooking( status ) async {
  //   List<BookingModel> bookingModelList = [];
  //   await fireStore.collection(CollectionName.bookings).orderBy('createAt', descending: true).get().then((value) {
  //     for (var element in value.docs) {
  //       BookingModel bookingModel = BookingModel.fromJson(element.data());
  //       bookingModelList.add(bookingModel);
  //     }
  //   }).catchError((error) {
  //     log("get booking error${error.toString()}");
  //   });
  //   return bookingModelList;
  // }

  static Future<List<VerifyDriverModel>> getVerifyDriverModel() async {
    List<VerifyDriverModel> verifyDriverModelList = [];
    await fireStore.collection(CollectionName.verifyDriver).orderBy('createAt', descending: true).get().then((value) {
      for (var element in value.docs) {
        VerifyDriverModel verifyDriverModel = VerifyDriverModel.fromJson(element.data());
        verifyDriverModelList.add(verifyDriverModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return verifyDriverModelList;
  }

  static Future<int> countDrivers() async {
    final CollectionReference<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.drivers);
    AggregateQuerySnapshot query = await userList.count().get();
    Constant.driverLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countSearchDrivers(String searchQuery, String searchType) async {
    final Query<Map<String, dynamic>> userList = FirebaseFirestore.instance.collection(CollectionName.drivers).where(
          searchType,
          isGreaterThanOrEqualTo: searchQuery,
          isLessThan: "$searchQuery\uf8ff",
        );
    AggregateQuerySnapshot query = await userList.count().get();
    log('The number of search drivers: ${query.count}');
    Constant.driverLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<List<DriverUserModel>> getDriver(int pageNumber, int pageSize, String searchQuery, String searchType) async {
    List<DriverUserModel> userList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (searchQuery.isNotEmpty) {
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.drivers)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.drivers)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.drivers)
              .where(
                searchType,
                isGreaterThanOrEqualTo: searchQuery,
                isLessThan: "$searchQuery\uf8ff",
              )
              .orderBy('createdAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      } else {
        if (pageNumber > 1) {
          var documents = await fireStore.collection(CollectionName.drivers).orderBy('createdAt', descending: true).limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore.collection(CollectionName.drivers).orderBy('createdAt', descending: true).startAfterDocument(lastDocument).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.drivers).orderBy('createdAt', descending: true).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              DriverUserModel driverModel = DriverUserModel.fromJson(element.data());
              userList.add(driverModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      }
    } catch (error) {
      log(error.toString());
    }
    return userList;
  }

  static Future<List<DriverUserModel>> getRecentDriver() async {
    List<DriverUserModel> driverUserModelList = [];
    await fireStore.collection(CollectionName.drivers).orderBy('createdAt', descending: true).limit(5).get().then((value) {
      for (var element in value.docs) {
        DriverUserModel driverUserModel = DriverUserModel.fromJson(element.data());
        driverUserModelList.add(driverUserModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return driverUserModelList;
  }

  static Future<bool> updateDriver(DriverUserModel driverUserModel) async {
    return FirebaseFirestore.instance.collection(CollectionName.drivers).doc(driverUserModel.id).update(driverUserModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<UserModel?> getUserByUserID(String id) async {
    UserModel? userModel;

    await FirebaseFirestore.instance.collection(CollectionName.users).doc(id).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      } else {
        userModel = UserModel(fullName: "Unknown User");
      }
    }).catchError((error) {
      return null;
    });
    return userModel;
  }

  static Future<DocumentsModel?> getDocumentByDocumentId(String id) async {
    DocumentsModel? documentModel;

    await FirebaseFirestore.instance.collection(CollectionName.documents).doc(id).get().then((value) {
      if (value.exists) {
        documentModel = DocumentsModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      return null;
    });
    return documentModel;
  }

  static Future<DriverUserModel?> getDriverByDriverID(String id) async {
    DriverUserModel? driverUserModel;
    // driverUserModel
    await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(id).get().then((value) {
      if (value.exists) {
        driverUserModel = DriverUserModel.fromJson(value.data()!);
      } else {
        driverUserModel = DriverUserModel(fullName: "Unknown Driver");
      }
    }).catchError((error) {
      return null;
    });
    return driverUserModel;
  }

  static Future<BrandModel?> getVehicleBrandByBrandId(String id) async {
    BrandModel? vehicleBrandModel;
    await FirebaseFirestore.instance.collection(CollectionName.vehicleBrand).doc(id).get().then((value) {
      if (value.exists) {
        vehicleBrandModel = BrandModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return vehicleBrandModel;
  }

  static Future<int> countVehicleBrand() async {
    final CollectionReference<Map<String, dynamic>> productList = FirebaseFirestore.instance.collection(CollectionName.vehicleBrand);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    Constant.vehicleBrandLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<List<BrandModel>> getVehicleBrand(int pageNumber, int pageSize) async {
    List<BrandModel> vehicleBrandModelList = [];
    try {
      DocumentSnapshot? lastDocument;
      if (pageNumber > 1) {
        var documents = await fireStore.collection(CollectionName.vehicleBrand).orderBy("title").limit(pageSize * (pageNumber - 1)).get();
        if (documents.docs.isNotEmpty) {
          lastDocument = documents.docs.last;
        }
      }
      if (lastDocument != null) {
        await fireStore.collection(CollectionName.vehicleBrand).orderBy("title").startAfterDocument(lastDocument).limit(pageSize).get().then((value) {
          for (var element in value.docs) {
            BrandModel vehicleBrandModel = BrandModel.fromJson(element.data());
            vehicleBrandModelList.add(vehicleBrandModel);
          }
        }).catchError((error) {
          log(error.toString());
        });
      } else {
        await fireStore.collection(CollectionName.vehicleBrand).orderBy("title").limit(pageSize).get().then((value) {
          for (var element in value.docs) {
            BrandModel vehicleBrandModel = BrandModel.fromJson(element.data());
            vehicleBrandModelList.add(vehicleBrandModel);
          }
        }).catchError((error) {
          log(error.toString());
        });
      }
    } catch (error) {
      log(error.toString());
    }
    return vehicleBrandModelList;
  }

  static Future<List<BrandModel>> getVehicleBrandAllData() async {
    List<BrandModel> vehicleBrandModelList = [];
    await fireStore.collection(CollectionName.vehicleBrand).orderBy("title").get().then((value) {
      for (var element in value.docs) {
        BrandModel vehicleBrandModel = BrandModel.fromJson(element.data());
        vehicleBrandModelList.add(vehicleBrandModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return vehicleBrandModelList;
  }

  static Future<bool> addVehicleBrand(BrandModel vehicleBrandModel) {
    return fireStore.collection(CollectionName.vehicleBrand).doc(vehicleBrandModel.id).set(vehicleBrandModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Vehicle Brand Saved...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<bool> updateVehicleBrand(BrandModel vehicleBrandModel) {
    return fireStore.collection(CollectionName.vehicleBrand).doc(vehicleBrandModel.id).update(vehicleBrandModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Vehicle Brand Saved...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<int> countVehicleModel() async {
    final CollectionReference<Map<String, dynamic>> productList = FirebaseFirestore.instance.collection(CollectionName.vehicleModel);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    Constant.vehicleModelLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<List<ModelVehicleModel>> getVehicleModel(int pageNumber, int pageSize, String id) async {
    List<ModelVehicleModel> modelVehicleModelList = [];
    try {
      if (id == "") {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore.collection(CollectionName.vehicleModel).orderBy("title").limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore.collection(CollectionName.vehicleModel).orderBy("title").startAfterDocument(lastDocument).limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ModelVehicleModel modelVehicleModel = ModelVehicleModel.fromJson(element.data());
              modelVehicleModelList.add(modelVehicleModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.vehicleModel).orderBy("title").limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ModelVehicleModel modelVehicleModel = ModelVehicleModel.fromJson(element.data());
              modelVehicleModelList.add(modelVehicleModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      } else {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents =
              await fireStore.collection(CollectionName.vehicleModel).where("brandId", isEqualTo: id).orderBy("title").limit(pageSize * (pageNumber - 1)).get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.vehicleModel)
              .where("brandId", isEqualTo: id)
              .orderBy("title")
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              ModelVehicleModel modelVehicleModel = ModelVehicleModel.fromJson(element.data());
              modelVehicleModelList.add(modelVehicleModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore.collection(CollectionName.vehicleModel).where("brandId", isEqualTo: id).orderBy("title").limit(pageSize).get().then((value) {
            for (var element in value.docs) {
              ModelVehicleModel modelVehicleModel = ModelVehicleModel.fromJson(element.data());
              modelVehicleModelList.add(modelVehicleModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      }
    } catch (error) {
      log(error.toString());
    }
    return modelVehicleModelList;
  }

  static Future<bool> addVehicleModel(ModelVehicleModel modelVehicleModel) {
    return fireStore.collection(CollectionName.vehicleModel).doc(modelVehicleModel.id).set(modelVehicleModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Model Saved...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<bool> updateVehicleModel(ModelVehicleModel modelVehicleModel) {
    return fireStore.collection(CollectionName.vehicleModel).doc(modelVehicleModel.id).update(modelVehicleModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Model Updated...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<AdminModel?> getAdmin() async {
    AdminModel? adminModel;
    await FirebaseFirestore.instance.collection(CollectionName.admin).doc("admin").get().then((value) {
      if (value.exists) {
        adminModel = AdminModel.fromJson(value.data()!);
        Constant.adminModel = AdminModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      adminModel = null;
    });
    return adminModel;
  }

  static Future<bool> setAdmin(AdminModel adminModel) {
    return FirebaseFirestore.instance.collection(CollectionName.admin).doc("admin").set(adminModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
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

  static Future<bool> addLanguage(LanguageModel languageModel) {
    return fireStore.collection(CollectionName.languages).doc(languageModel.id).set(languageModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Saved...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<bool> updateLanguage(LanguageModel languageModel) {
    return fireStore.collection(CollectionName.languages).doc(languageModel.id).update(languageModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Language Updated...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("payment").get().then((value) {
      if (value.exists) {
        Constant.paymentModel = PaymentModel.fromJson(value.data()!);
        paymentModel = PaymentModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      paymentModel = null;
    });
    return paymentModel;
  }

  static Future<bool> setPayment(PaymentModel paymentModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("payment").update(paymentModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Saved...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<ConstantModel?> getGeneralSetting() async {
    ConstantModel? constantModel;
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("constant").get().then((value) {
      if (value.exists) {
        Constant.constantModel = ConstantModel.fromJson(value.data()!);
        constantModel = ConstantModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to get getGeneral Setting: $error");
      constantModel = null;
    });
    return constantModel;
  }

  static Future<GlobalValueModel?> getGlobalValueSetting() async {
    GlobalValueModel? globalValueModel;
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("globalValue").get().then((value) {
      if (value.exists) {
        Constant.constantModel = ConstantModel.fromJson(value.data()!);
        globalValueModel = GlobalValueModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to get user: $error");
      globalValueModel = null;
    });
    return globalValueModel;
  }

  static Future<bool> setGlobalValueSetting(GlobalValueModel globalValueModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("globalValue").set(globalValueModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      print('error in set Global value $error');
      return false;
    });
  }

  static Future<bool> setGeneralSetting(ConstantModel constantModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("constant").set(constantModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<List<TaxModel>?> getTax() async {
    List<TaxModel> taxList = [];

    await fireStore.collection(CollectionName.countryTax).get().then((value) {
      for (var element in value.docs) {
        TaxModel taxModel = TaxModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<bool> addTaxes(TaxModel taxModel) {
    return FirebaseFirestore.instance.collection(CollectionName.countryTax).doc(taxModel.id).set(taxModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Country Tax Saved...!");
        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<bool> addCancelingReason(List<String> reasonList) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("canceling_reason").set(<String, List<String>>{"reasons": reasonList});
      ShowToastDialog.toast("Canceling Reason Saved...!");
      return true;
    } catch (error) {
      log('Error adding canceling reason: $error');
      ShowToastDialog.toast("Something went wrong");
      return false;
    }
  }

  static Future<List<String>> getCancelingReason() async {
    final List<String> reasonList = [];

    try {
      await FirebaseFirestore.instance.collection(CollectionName.settings).doc("canceling_reason").get().then((value) {
        if (value.exists) {
          final List<dynamic> data = value.data()?["reasons"] ?? [];
          reasonList.addAll(data.map((element) => element.toString()));
        }
      });
    } catch (error) {
      // Rethrow the error to be caught by the caller
      throw 'Error fetching canceling reasons: $error';
    }

    return reasonList;
  }

  static Future<bool> updateTax(TaxModel taxModel) {
    return FirebaseFirestore.instance.collection(CollectionName.countryTax).doc(taxModel.id).update(taxModel.toJson()).then(
      (value) {
        ShowToastDialog.toast("Country Tax Updated...!");

        return true;
      },
    ).catchError((error) {
      ShowToastDialog.toast("Something went wrong");

      return false;
    });
  }

  static Future<bool> addCurrency(CurrencyModel currencyModel) {
    return FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).set(currencyModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<bool> updateCurrency(CurrencyModel currencyModel) {
    return FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).update(currencyModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<List<CurrencyModel>> getCurrencyList() async {
    List<CurrencyModel> currencyModelList = [];
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.currencies).get();
    for (var document in snap.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        currencyModelList.add(CurrencyModel.fromJson(data));
      }
    }
    return currencyModelList;
  }

  static Future<bool> setContactusSetting(ContactUsModel contactUsModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("contact_us").set(contactUsModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<ContactUsModel?> getContactusSetting() async {
    ContactUsModel? contactUsModel;
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("contact_us").get().then((value) {
      if (value.exists) {
        contactUsModel = ContactUsModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      contactUsModel = null;
    });
    return contactUsModel;
  }

  static Future<AdminCommission?> getAdminCommission() async {
    AdminCommission? adminCommissionModel;
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("admin_commission").get().then((value) {
      if (value.exists) {
        adminCommissionModel = AdminCommission.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      adminCommissionModel = null;
    });
    return adminCommissionModel;
  }

  static Future<bool> setAdminCommission(AdminCommission adminCommissionModel) {
    return FirebaseFirestore.instance.collection(CollectionName.settings).doc("admin_commission").set(adminCommissionModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<bool> addBanner(BannerModel bannerModel) {
    return FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).set(bannerModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<bool> updateBanner(BannerModel bannerModel) {
    return FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).update(bannerModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<List<BannerModel>> getBanner() async {
    List<BannerModel> bannerModel = [];
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(CollectionName.banner).get();
    for (var document in snap.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        bannerModel.add(BannerModel.fromJson(data));
      }
    }
    return bannerModel;
  }

  static Future<bool> removeBanner(String docId, String url) {
    return FirebaseFirestore.instance.collection(CollectionName.banner).doc(docId).delete().then((value) async {
      await FirebaseStorage.instance.refFromURL(url).delete().then((value) {});
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<String> uploadPic(PickedFile image, String fileName, String filePath, String mimeType) async {
    //Create a reference to the location you want to upload to in firebase
    UploadTask uploadTask;
    Reference ref = FirebaseStorage.instance.ref().child(fileName).child(filePath);

    //Upload the file to firebase
    uploadTask = ref.putData(
        await image.readAsBytes(),
        SettableMetadata(
          contentType: mimeType,
          customMetadata: {'picked-file-path': image.path},
        ));

    String url = await uploadTask.then((taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    });

    return url;
  }

  static Future<String> uploadMultiplePic(XFile image, String filePath, String fileName) async {
    Reference ref = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask;
    uploadTask = ref.putData(
        await image.readAsBytes(),
        SettableMetadata(
          contentType: "image/png",
          customMetadata: {'picked-file-path': image.path},
        ));
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<DocumentsModel>> getDocument() async {
    List<DocumentsModel> documentModelList = [];
    await fireStore.collection(CollectionName.documents).get().then((value) {
      for (var element in value.docs) {
        DocumentsModel documentModel = DocumentsModel.fromJson(element.data());
        documentModelList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });

    return documentModelList;
  }

  static Future<bool> addDocument(DocumentsModel documentModel) {
    return FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentModel.id).set(documentModel.toJson()).then((value) {
      ShowToastDialog.toast("Save Document...!");

      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<bool> addVehicleType(VehicleTypeModel vehicleTypeModel) {
    return FirebaseFirestore.instance.collection(CollectionName.vehicleType).doc(vehicleTypeModel.id).set(vehicleTypeModel.toJson()).then((value) {
      ShowToastDialog.toast("Save VehicleType...!");

      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<List<BookingModel>> getBookingByDriverId(String? status, String? driverId) async {
    List<BookingModel> bookingModelList = [];
    try {
      QuerySnapshot querySnapshot;

      if (status == 'All') {
        querySnapshot = await fireStore.collection(CollectionName.bookings).orderBy('createAt', descending: true).where('driverId', isEqualTo: driverId).get();
      } else {
        querySnapshot = await fireStore
            .collection(CollectionName.bookings)
            .where('driverId', isEqualTo: driverId)
            .where('bookingStatus', isEqualTo: status)
            .orderBy('createAt', descending: true)
            .get();
      }
      for (var element in querySnapshot.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data() as Map<String, dynamic>);
        bookingModelList.add(bookingModel);
      }
    } catch (error) {
      print('error in get booking history $error');
    }
    return bookingModelList;
  }

  static Future<List<VehicleTypeModel>> getVehicleType() async {
    List<VehicleTypeModel> vehicleTypeList = [];
    await fireStore.collection(CollectionName.vehicleType).get().then((value) {
      for (var element in value.docs) {
        VehicleTypeModel couponModel = VehicleTypeModel.fromJson(element.data());

        vehicleTypeList.add(couponModel);
      }
    }).catchError((error) {
      log('error in getVehicle type ${error.toString()}');
    });
    return vehicleTypeList;
  }

  static Future<List<WithdrawModel>> getPayoutRequest({String status = "All"}) async {
    List<WithdrawModel> payoutRequestList = [];
    try {
      QuerySnapshot querySnapshot;

      if (status == "All") {
        querySnapshot = await FirebaseFirestore.instance.collection(CollectionName.withDrawHistory).get();
      } else {
        querySnapshot = await FirebaseFirestore.instance.collection(CollectionName.withDrawHistory).where('paymentStatus', isEqualTo: status).get();
      }

      for (var element in querySnapshot.docs) {
        WithdrawModel payoutRequest = WithdrawModel.fromJson(element.data() as Map<String, dynamic>);
        payoutRequestList.add(payoutRequest);
      }
    } catch (error) {
      print("get payout request error: ${error.toString()}");
    }

    return payoutRequestList;
  }

  static Future<int> countBooking() async {
    final CollectionReference<Map<String, dynamic>> bookingList = FirebaseFirestore.instance.collection(CollectionName.bookings);
    AggregateQuerySnapshot query = await bookingList.count().get();
    log('The number of Booking: ${query.count}');
    Constant.bookingLength = query.count ?? 0;
    return query.count ?? 0;
  }

  static Future<int> countStatusWiseBooking(String? status, DateTimeRange? dateTimeRange) async {
    if (status == 'All') {
      final Query<Map<String, dynamic>> bookingList =
          FirebaseFirestore.instance.collection(CollectionName.bookings).where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThan: dateTimeRange!.end);
      AggregateQuerySnapshot query = await bookingList.count().get();
      log('The number of StatusWise Booking: ${query.count}');
      Constant.bookingLength = query.count ?? 0;
      return query.count ?? 0;
    } else {
      final Query<Map<String, dynamic>> bookingList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where('bookingStatus', isEqualTo: status)
          .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThan: dateTimeRange!.end);
      AggregateQuerySnapshot query = await bookingList.count().get();
      log('The number of StatusWise Booking: ${query.count}');
      Constant.bookingLength = query.count ?? 0;
      return query.count ?? 0;
    }
  }

  static Future<List<BookingModel>> getBooking(int pageNumber, int pageSize, String? status, DateTimeRange? dateTimeRange) async {
    List<BookingModel> bookingList = [];
    try {
      if (status == 'All') {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.bookings)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.bookings)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              BookingModel bookingModel = BookingModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.bookings)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              BookingModel bookingModel = BookingModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      } else {
        DocumentSnapshot? lastDocument;
        if (pageNumber > 1) {
          var documents = await fireStore
              .collection(CollectionName.bookings)
              .where('bookingStatus', isEqualTo: status)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .limit(pageSize * (pageNumber - 1))
              .get();
          if (documents.docs.isNotEmpty) {
            lastDocument = documents.docs.last;
          }
        }
        if (lastDocument != null) {
          await fireStore
              .collection(CollectionName.bookings)
              .where('bookingStatus', isEqualTo: status)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .startAfterDocument(lastDocument)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              BookingModel bookingModel = BookingModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        } else {
          await fireStore
              .collection(CollectionName.bookings)
              .where('bookingStatus', isEqualTo: status)
              .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange!.end)
              .orderBy('createAt', descending: true)
              .limit(pageSize)
              .get()
              .then((value) {
            for (var element in value.docs) {
              BookingModel bookingModel = BookingModel.fromJson(element.data());
              bookingList.add(bookingModel);
            }
          }).catchError((error) {
            log(error.toString());
          });
        }
      }
    } catch (error) {
      log(error.toString());
    }
    return bookingList;
  }

  static Future<List<BookingModel>> getRecentBooking(String? status) async {
    List<BookingModel> bookingModelList = [];
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await fireStore.collection(CollectionName.bookings).orderBy('createAt', descending: true).get();
      for (var element in querySnapshot.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data() as Map<String, dynamic>);
        bookingModelList.add(bookingModel);
      }
    } catch (error) {
      print('error in get booking history $error');
    }

    return bookingModelList;
  }

  static Future<List<BookingModel>> getBookingByUserId(String? status, String? userId) async {
    List<BookingModel> bookingModelList = [];
    try {
      QuerySnapshot querySnapshot;

      if (status == 'All') {
        querySnapshot = await fireStore.collection(CollectionName.bookings).orderBy('createAt', descending: true).where('customerId', isEqualTo: userId).get();
      } else {
        querySnapshot = await fireStore
            .collection(CollectionName.bookings)
            .where('customerId', isEqualTo: userId)
            .where('bookingStatus', isEqualTo: status)
            .orderBy('createAt', descending: true)
            .get();
      }
      for (var element in querySnapshot.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data() as Map<String, dynamic>);
        bookingModelList.add(bookingModel);
      }
    } catch (error) {
      print('error in get booking history $error');
    }
    return bookingModelList;
  }

  static Future<bool> updatePayoutRequest(WithdrawModel payoutRequestModel) {
    // return true;
    // static Future<bool> updatePayoutRequest(WithdrawModel payoutRequestModel) {
    return FirebaseFirestore.instance.collection(CollectionName.withDrawHistory).doc(payoutRequestModel.id).update(payoutRequestModel.toJson()).then((value) {
      ShowToastDialog.toast("Save Payout Request...!");

      return true;
    }).catchError((error) {
      log('error in update payout request $error');
      return false;
    });
  }

  // static Future<bool> updatePayoutRequest(WithdrawModel payoutRequestModel) async {
  //   final docRef = FirebaseFirestore.instance
  //       .collection(CollectionName.withDrawHistory)
  //       .doc(payoutRequestModel.id);
  //
  //   try {
  //     // Check if the document exists
  //     final docSnapshot = await docRef.get();
  //     if (!docSnapshot.exists) {
  //       log('Document not found: ${payoutRequestModel.id}');
  //       ShowToastDialog.toast("Payout Request not found.");
  //       return false;
  //     }
  //
  //     // Update the document
  //     await docRef.update(payoutRequestModel.toJson());
  //     ShowToastDialog.toast("Payout Request updated successfully.");
  //     return true;
  //   } catch (error) {
  //     log('Error in updating payout request: $error');
  //     ShowToastDialog.toast("Error updating Payout Request.");
  //     return false;
  //   }
  // }

  static Future<bool> updateVehicleType(VehicleTypeModel vehicleTypeModel) {
    return FirebaseFirestore.instance.collection(CollectionName.vehicleType).doc(vehicleTypeModel.id).update(vehicleTypeModel.toJson()).then((value) {
      ShowToastDialog.toast("Save VehicleType...!");

      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<List<CouponModel>> getCoupon() async {
    List<CouponModel> couponModelList = [];
    await fireStore.collection(CollectionName.coupon).get().then((value) {
      for (var element in value.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());

        couponModelList.add(couponModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return couponModelList;
  }

  static Future<bool> addCoupon(CouponModel couponModel) {
    return FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).set(couponModel.toJson()).then((value) {
      ShowToastDialog.toast("Save Coupon...!");
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<bool> updateCoupon(CouponModel couponModel) {
    return FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).update(couponModel.toJson()).then((value) {
      ShowToastDialog.toast("Save Coupon...!");

      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<bool> updateDocument(DocumentsModel documentModel) {
    return FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentModel.id).update(documentModel.toJson()).then((value) {
      ShowToastDialog.toast("Save Document...!");

      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    await FirebaseFirestore.instance.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> updateUserWallet({required String amount, required String userId}) async {
    bool isAdded = false;
    await getUserByUserID(userId).then((value) async {
      if (value != null) {
        UserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await updateUsers(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateDriverWallet({required String amount, required String userId}) async {
    bool isAdded = false;
    await getDriverByDriverID(userId).then((value) async {
      if (value != null) {
        DriverUserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await updateDriver(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<UserModel?> getCustomerByCustomerID(String id) async {
    UserModel? userModel;

    await FirebaseFirestore.instance.collection(CollectionName.users).doc(id).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      } else {
        userModel = UserModel(fullName: "Unknown User");
      }
    }).catchError((error) {
      return null;
    });
    return userModel;
  }

  static Future<bool> updateUsers(UserModel userModel) {
    return FirebaseFirestore.instance.collection(CollectionName.users).doc(userModel.id).update(userModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      log(error.toString());
      return false;
    });
  }

  static Future<bool> updateVerifyDocuments(VerifyDriverModel verifyDriverModel, driverID) {
    return FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverID).update(verifyDriverModel.toJson()).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  static Future<List<WalletTransactionModel>?> getWalletTransactionOfUser(String? userid) async {
    List<WalletTransactionModel> walletTransactionModelList = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: userid)
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
}
