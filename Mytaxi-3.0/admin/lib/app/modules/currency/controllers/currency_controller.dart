import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/currency_model.dart';
import 'package:admin/app/modules/currency/views/currency_view.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class CurrencyController extends GetxController {
  RxString title = "Currency".tr.obs;

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  Rx<TextEditingController> symbolController = TextEditingController().obs;
  Rx<TextEditingController> decimalDigitsController = TextEditingController().obs;
  Rx<bool> isActive = false.obs;
  Rx<SymbolAt> symbolAt = SymbolAt.symbolAtLeft.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<CurrencyModel> currencyList = <CurrencyModel>[].obs;
  Rx<CurrencyModel> currencyModel = CurrencyModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    currencyList.clear();
    List<CurrencyModel> data = await FireStoreUtils.getCurrencyList();
    currencyList.addAll(data);
    isLoading(false);
  }

  setDefaultData() {
    nameController.value.text = "";
    symbolController.value.text = "";
    decimalDigitsController.value.text = "";
    codeController.value.text = "";
    isActive = false.obs;
    symbolAt = SymbolAt.symbolAtLeft.obs;
    isEditing = false.obs;
    isLoading = false.obs;
  }

  updateCurrency() async {
    currencyModel.value.active = isActive.value;
    // currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.updateCurrency(currencyModel.value);
    await getData();
  }

  addCurrency() async {
    isLoading = true.obs;
    currencyModel.value.id = Constant.getRandomString(20);
    currencyModel.value.active = isActive.value;
    currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.addCurrency(currencyModel.value);
    await getData();
    isLoading = false.obs;
  }

  removeCurrency(CurrencyModel currencyModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).delete().then((value) {
      ShowToastDialog.toast("Currency deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }
}
