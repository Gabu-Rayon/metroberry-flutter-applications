// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/terms_conditions_controller.dart';

class TermsConditionsView extends GetView<TermsConditionsController> {
  TermsConditionsView({super.key});

  final HtmlEditorController htmlEditorController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<TermsConditionsController>(
      init: TermsConditionsController(),
      builder: (controller) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContainerCustom(
              child:
              Column(children: [
                ResponsiveWidget.isDesktop(context) ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ResponsiveWidget.isDesktop(context)
                        ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                        spaceH(height: 2),
                        Row(children: [
                          GestureDetector(
                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                        ])
                      ],
                    ) :
                    TextCustom(title: '${"Terms&Condition"}', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primaryBlack),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: () {
                            htmlEditorController.undo();
                          },
                          icon: const Icon(
                            Icons.undo_outlined,
                            color: AppThemData.greyShade500,
                          ),
                        ),
                        spaceW(),
                        IconButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              htmlEditorController.clear();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: AppThemData.greyShade500,
                            )),
                        spaceW(),
                        IconButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              htmlEditorController.toggleCodeView();
                            },
                            icon: const Icon(
                              Icons.code,
                              color: AppThemData.greyShade500,
                            )),
                        CustomButtonWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          buttonTitle: "Save",
                          onPress: () async {
                            if (Constant.isDemo) {
                              DialogBox.demoDialogBox();
                            } else {
                              var txt = await htmlEditorController.getText();
                              if (txt.contains('src="data:')) {
                                txt = '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                              }

                              controller.result.value = txt;

                              Constant.waitingLoader();
                              Constant.constantModel!.termsAndConditions = controller.result.value;
                              await FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                ShowToast.successToast("Terms and conditions updated");

                                Get.back();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ) : Column(
                  children: [
                    ResponsiveWidget.isDesktop(context)
                        ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                        spaceH(height: 2),
                        Row(children: [
                          GestureDetector(
                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                        ])
                      ],
                    ) :
                    TextCustom(title: '${"Terms&Condition"}', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primaryBlack),
                    spaceH(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: () {
                            htmlEditorController.undo();
                          },
                          icon: const Icon(
                            Icons.undo_outlined,
                            color: AppThemData.greyShade500,
                          ),
                        ),
                        spaceW(),
                        IconButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              htmlEditorController.clear();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: AppThemData.greyShade500,
                            )),
                        spaceW(),
                        IconButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              htmlEditorController.toggleCodeView();
                            },
                            icon: const Icon(
                              Icons.code,
                              color: AppThemData.greyShade500,
                            )),
                        CustomButtonWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          buttonTitle: "Save",
                          onPress: () async {
                            if (Constant.isDemo) {
                              DialogBox.demoDialogBox();
                            } else {
                              var txt = await htmlEditorController.getText();
                              if (txt.contains('src="data:')) {
                                txt = '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                              }

                              controller.result.value = txt;

                              Constant.waitingLoader();
                              Constant.constantModel!.termsAndConditions = controller.result.value;
                              await FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                ShowToast.successToast("Terms and conditions updated");

                                Get.back();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ) ,
                spaceH(height: 20),
                FutureBuilder<ConstantModel?>(
                    future: FireStoreUtils.getGeneralSetting(),
                    builder: (BuildContext context, AsyncSnapshot<ConstantModel?> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: Constant.loader());
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            ConstantModel constantModel = snapshot.data!;

                            return SingleChildScrollView(
                              child: Container(
                                height: 0.6.sh,
                                decoration: BoxDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: HtmlEditor(
                                  controller: htmlEditorController,
                                  htmlEditorOptions: HtmlEditorOptions(
                                    hint: 'Your text here...',
                                    initialText: constantModel.termsAndConditions,
                                    shouldEnsureVisible: true,
                                  ),
                                  htmlToolbarOptions: HtmlToolbarOptions(
                                    toolbarPosition: ToolbarPosition.aboveEditor,
                                    //by default
                                    toolbarType: ToolbarType.nativeScrollable,
                                    //by default
                                    onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                                      log("button '${describeEnum(type)}' pressed, the current selected status is $status");
                                      return true;
                                    },
                                    onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                                      log("dropdown '${describeEnum(type)}' changed to $changed");
                                      return true;
                                    },
                                    mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                                      log(url);
                                      return true;
                                    },
                                  ),
                                  otherOptions: const OtherOptions(height: 500),
                                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                                    log('html before change is $currentHtml');
                                  }, onChangeContent: (String? changed) {
                                    log('content changed to $changed');
                                  }, onChangeCodeview: (String? changed) {
                                    log('code changed to $changed');
                                  }, onChangeSelection: (EditorSettings settings) {
                                    log('parent element is ${settings.parentElement}');
                                    log('font name is ${settings.fontName}');
                                  }, onDialogShown: () {
                                    log('dialog shown');
                                  }, onEnter: () {
                                    log('enter/return pressed');
                                  }, onFocus: () {
                                    log('editor focused');
                                  }, onBlur: () {
                                    log('editor unfocused');
                                  }, onBlurCodeview: () {
                                    log('codeview either focused or unfocused');
                                  }, onInit: () {
                                    log('init');
                                  }, onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                                    log(describeEnum(error));
                                    log(base64Str ?? '');
                                    if (file != null) {
                                      log(file.name.toString());
                                      log(file.size.toString());
                                      log(file.type.toString());
                                    }
                                  }, onKeyDown: (int? keyCode) {
                                    log('$keyCode key downed');
                                    log('current character count: ${htmlEditorController.characterCount}');
                                  }, onKeyUp: (int? keyCode) {
                                    log('$keyCode key released');
                                  }, onMouseDown: () {
                                    log('mouse downed');
                                  }, onMouseUp: () {
                                    log('mouse released');
                                  }, onNavigationRequestMobile: (String url) {
                                    log(url);
                                    return NavigationActionPolicy.ALLOW;
                                  }, onPaste: () {
                                    log('pasted into editor');
                                  }, onScroll: () {
                                    log('editor scrolled');
                                  }),
                                  plugins: [
                                    SummernoteAtMention(
                                        getSuggestionsMobile: (String value) {
                                          var mentions = <String>['test1', 'test2', 'test3'];
                                          return mentions.where((element) => element.contains(value)).toList();
                                        },
                                        mentionsWeb: ['test1', 'test2', 'test3'],
                                        onSelect: (String value) {
                                          log(value);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          }
                      }
                    }),
                spaceH(),
              ]),
            )
          ]),
        );
      },
    );
  }
}
