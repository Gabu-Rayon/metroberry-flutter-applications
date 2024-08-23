import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  RxString title = "Privacy Policy".tr.obs;

  RxString result = ''.obs;
  RxString parsedString = ''.obs;

  String sampleRichText = """
<h1 id="hf19cd910e2">Heading 1</h1>
<p>Flutter is an open-source UI software development kit created by Google.</p>
""";
  Rx<ConstantModel> constantModel = ConstantModel().obs;

  getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) {
      if (value != null) {
        constantModel.value = value;
      }
    });
  }

  @override
  void onInit() {
    getSettingData();
    super.onInit();
  }
}
