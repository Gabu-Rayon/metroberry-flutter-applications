import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/documents_model.dart';
import 'package:admin/app/modules/document_screen/views/document_screen_view.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentScreenController extends GetxController {
  RxString title = "Document".tr.obs;

  Rx<TextEditingController> documentNameController = TextEditingController().obs;
  Rx<SideAt> documentSide = SideAt.isOneSide.obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  Rx<String> editingId = "".obs;
  RxList<DocumentsModel> documentsList = <DocumentsModel>[].obs;

  @override
  Future<void> onInit() async {
    await getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    documentsList.clear();
    List<DocumentsModel> data = await FireStoreUtils.getDocument();
    documentsList.addAll(data);
    isLoading(false);
  }

  setDefaultData() {
    documentNameController.value.text = "";
    editingId.value = "";
    documentSide = SideAt.isOneSide.obs;
    isActive.value = false;
    isEditing.value = false;
  }

  updateDocument() async {
    isEditing = true.obs;
    await FireStoreUtils.addDocument(
        DocumentsModel(id: editingId.value, isEnable: isActive.value, isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false, title: documentNameController.value.text));
    await getData();
    isEditing = false.obs;
  }

  addDocument() async {
    isLoading = true.obs;
    await FireStoreUtils.addDocument(DocumentsModel(
        id: Constant.getRandomString(20), isEnable: isActive.value, isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false, title: documentNameController.value.text));
    await getData();
    isLoading = false.obs;
  }

  removeDocument(DocumentsModel documentsModel) async {
    isLoading = true.obs;

    await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentsModel.id).delete().then((value) {
      ShowToastDialog.toast("Document deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await getData();
    isLoading = false.obs;
  }
}
