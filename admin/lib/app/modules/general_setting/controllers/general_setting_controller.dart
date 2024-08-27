import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../constant/constants.dart';

class GeneralSettingController extends GetxController {
  RxString title = "General Setting".tr.obs;

  Rx<TextEditingController> googleMapKeyController = TextEditingController().obs;
  Rx<TextEditingController> notificationServerKeyController = TextEditingController().obs;

  Rx<ConstantModel> constantModel = ConstantModel().obs;
  Rx<File> imageFile = File('').obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;

  Rx<File> file = Rx<File>(File(''));
  Rx<Uint8List> fileBytes = Rx<Uint8List>(Uint8List(0));
  RxString mimeType = 'application/json'.obs;
  RxString fileName = ''.obs;
  RxString uploadFileUrl = ''.obs;


  Future<String?> uploadFile() async {
    try {
      String docId = Constant.getUuid();
      String name = kIsWeb ? fileName.value : Random().nextInt(100000).toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploadedFiles/$docId/$name');

      UploadTask uploadTask = ref.putData(fileBytes.value, SettableMetadata(contentType: mimeType.value));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      uploadFileUrl.value = downloadURL;

      return downloadURL;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<void> pickJsonFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile pickedFile = result.files.first;


        if (kIsWeb) {
          fileName.value = pickedFile.name;
          fileBytes.value = pickedFile.bytes!;
          uploadFile();

        } else {
          file.value = File(pickedFile.path!);
          uploadFile();
        }
        mimeType.value = pickedFile.extension == 'json' ? 'application/json' : '';
      } else {
        print("--> No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  setDefaultData(){
     // mimeType = 'application/json'.obs;
     fileName.value = '';
     uploadFileUrl.value = '';
  }

  // void launchURL() {
  //   final String currentUrl = uploadFileUrl.value;
  //
  //
  //   if (currentUrl.isNotEmpty) {
  //     html.window.open(currentUrl, '_blank');
  //   } else {
  //     throw Exception('URL is empty');
  //   }
  // }
  //  getSettingData()  {
  //   FireStoreUtils.getGeneralSetting().then((value) {
  //     if (value != null) {
  //       constantModel.value = value;
  //       googleMapKeyController.value.text = constantModel.value.googleMapKey!;
  //       notificationServerKeyController.value.text = constantModel.value.notificationServerKey!;
  //       uploadFileUrl.value =   constantModel.value.jsonFileURL!;
  //     }
  //   });
  // }
  Future<void> getSettingData() async {
    try {
      isLoading(true);
      final settingData = await FireStoreUtils.getGeneralSetting();
      if (settingData != null) {
        constantModel.value = settingData;
        googleMapKeyController.value.text = constantModel.value.googleMapKey ?? '';
        notificationServerKeyController.value.text = constantModel.value.notificationServerKey ?? '';
        uploadFileUrl.value = constantModel.value.jsonFileURL ?? '';
      }
    } catch (e) {
      print("Error fetching setting data: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit()async {

    await getSettingData();


    super.onInit();
  }
}
