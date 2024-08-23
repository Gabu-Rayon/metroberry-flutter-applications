// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/documents_model.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/screen_size.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/verify_document_screen_controller.dart';

class VerifyDocumentScreenView extends GetView<VerifyDocumentScreenController> {
  const VerifyDocumentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<VerifyDocumentScreenController>(
      init: VerifyDocumentScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            leadingWidth: 200,
            // title: title,
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (!ResponsiveWidget.isDesktop(context)) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: !ResponsiveWidget.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.menu,
                              size: 30,
                              color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                            ),
                          )
                        : SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 45,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (themeChange.darkTheme == 1) {
                    themeChange.darkTheme = 0;
                  } else if (themeChange.darkTheme == 0) {
                    themeChange.darkTheme = 1;
                  } else if (themeChange.darkTheme == 2) {
                    themeChange.darkTheme = 0;
                  } else {
                    themeChange.darkTheme = 2;
                  }
                },
                child: themeChange.isDarkTheme()
                    ? SvgPicture.asset(
                        "assets/icons/ic_sun.svg",
                        color: AppThemData.yellow600,
                        height: 20,
                        width: 20,
                      )
                    : SvgPicture.asset(
                        "assets/icons/ic_moon.svg",
                        color: AppThemData.blue400,
                        height: 20,
                        width: 20,
                      ),
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            // key: scaffoldKey,
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            child: const MenuWidget(),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
              Expanded(
                child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ContainerCustom(
                          child: Column(children: [
                            ResponsiveWidget.isDesktop(context) ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                  spaceH(height: 2),
                                  Row(children: [
                                    GestureDetector(
                                        onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                        child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                    TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                  ])
                                ]),
                                NumberOfRowsDropDown(
                                  controller: controller,
                                )
                              ],
                            ) : Column(
                              mainAxisAlignment:  MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                  spaceH(height: 2),
                                  Row(children: [
                                    GestureDetector(
                                        onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                        child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                    TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                  ])
                                ]),
                                spaceH(),
                                NumberOfRowsDropDown(
                                  controller: controller,
                                ),
                              ],
                            ),
                            spaceH(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.isLoading.value
                                    ? Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Constant.loader(),
                                      )
                                    : controller.currentPageVerifyDriver.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 65,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: MaterialStateColor.resolveWith(
                                                (states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Driver Name".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.20),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Driver Email".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 250 : MediaQuery.of(context).size.width * 0.25),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Document Verify".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 140 : MediaQuery.of(context).size.width * 0.14),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12),
                                            ],
                                            rows: controller.currentPageVerifyDriver
                                                .map((verifyDriverModel) => DataRow(cells: [
                                                      DataCell(
                                                          TextCustom(title: verifyDriverModel.driverName!.isEmpty ? "N/A" : verifyDriverModel.driverName.toString())),
                                                      DataCell(TextCustom(
                                                          title: verifyDriverModel.driverEmail!.isEmpty
                                                              ? "N/A"
                                                              : Constant.maskEmail(email: verifyDriverModel.driverEmail.toString()))),
                                                      DataCell(
                                                        FutureBuilder<DriverUserModel?>(
                                                          future: FireStoreUtils.getDriverByDriverID(verifyDriverModel.driverId.toString()),
                                                          builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                            switch (snapshot.connectionState) {
                                                              case ConnectionState.waiting:
                                                                return const SizedBox();
                                                              default:
                                                                if (snapshot.hasError) {
                                                                  return TextCustom(
                                                                    title: 'Error: ${snapshot.error}',
                                                                  );
                                                                } else {
                                                                  if (snapshot.data == null) {
                                                                    // Handle null data case
                                                                    return TextCustom(
                                                                      title: 'Error: Data is null'.tr,
                                                                    );
                                                                  } else {
                                                                    DriverUserModel driverUserModel = snapshot.data!;
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                      child: InkWell(
                                                                        onTap: () {},
                                                                        child: driverUserModel.isVerified!
                                                                            ? SvgPicture.asset(
                                                                                "assets/icons/ic_check.svg",
                                                                                color: AppThemData.green500,
                                                                                height: 20,
                                                                                width: 20,
                                                                              )
                                                                            : SvgPicture.asset(
                                                                                "assets/icons/ic_close.svg",
                                                                                color: AppThemData.red500,
                                                                                height: 20,
                                                                                width: 20,
                                                                              ),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  // controller.getDriverVehicleDetails(e.driverId);
                                                                  controller.editingVerifyDocumentId.value = verifyDriverModel.driverId!;
                                                                  controller.getDriverDetails(verifyDriverModel.driverId);
                                                                  controller.verifyDriverModel.value = verifyDriverModel;
                                                                  controller.verifyDocumentList.value = verifyDriverModel.verifyDocument!;
                                                                  showDialog(context: context, builder: (context) => const VerifyDriverDialog());
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_edit.svg",
                                                                  color: AppThemData.greyShade400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  // controller.removeVerifyDocument(verifyDriverModel);
                                                                  // controller.getData();
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    // controller.removeVehicleTypeModel(vehicleTypeModel);
                                                                    // controller.getData();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await controller.removeVerifyDocument(verifyDriverModel);
                                                                      controller.getData();
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  color: AppThemData.greyShade400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                              ),
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                          ]),
                        )
                      ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VerifyDriverDialog extends StatelessWidget {
  const VerifyDriverDialog({super.key, data});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: VerifyDocumentScreenController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: CustomDialog(
            title: controller.title.value,
            widgetList: [
              SizedBox(
                height: ScreenSize.height(70, context),
                child: ListView(
                  children: [
                    ContainerCustom(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  child: NetworkImageWidget(
                                    imageUrl: '${controller.driverUserModel.value.profilePic}',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                TextCustom(title: controller.verifyDriverModel.value.driverName.toString(), fontSize: 14, fontFamily: AppThemeData.bold),
                                TextCustom(
                                    title: Constant.maskEmail(email: controller.verifyDriverModel.value.driverEmail.toString()),
                                    fontSize: 14,
                                    fontFamily: AppThemeData.bold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceH(),
                    ContainerCustom(
                      // borderColor: Colors.pink,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Obx(
                            () => DataTable(
                                horizontalMargin: 20,
                                columnSpacing: 30,
                                dataRowMaxHeight: 65,
                                headingRowHeight: 65,
                                border: TableBorder.all(
                                  color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                headingRowColor:
                                    MaterialStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                                columns: [
                                  CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                  CommonUI.dataColumnWidget(context, columnTitle: "Document".tr, width: 150),
                                  CommonUI.dataColumnWidget(context, columnTitle: "Verify".tr, width: 100),
                                ],
                                rows: controller.verifyDocumentList
                                    .map((verifyDocumentModel) => DataRow(cells: [
                                          DataCell(
                                            FutureBuilder<DocumentsModel?>(
                                                future: FireStoreUtils.getDocumentByDocumentId(verifyDocumentModel.documentId.toString()), // async work
                                                builder: (BuildContext context, AsyncSnapshot<DocumentsModel?> snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.waiting:
                                                      // return Center(child: Constant.loader());
                                                      return const SizedBox();
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return TextCustom(
                                                          title: 'Error: ${snapshot.error}',
                                                        );
                                                      } else {
                                                        DocumentsModel documentModel = snapshot.data!;
                                                        return Container(
                                                          alignment: Alignment.centerLeft,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: TextButton(
                                                            onPressed: () {},
                                                            child: TextCustom(
                                                              title: documentModel.title!.isEmpty ? "N/A".tr : documentModel.title.toString(),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  }
                                                }),
                                          ),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () {
                                                viewURLImage(verifyDocumentModel.documentImage!.first.toString());
                                              },
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                child: NetworkImageWidget(
                                                  imageUrl: '${verifyDocumentModel.documentImage!.first}',
                                                  borderRadius: 10,
                                                  height: 40,
                                                  width: 100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              height: 10,
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: CupertinoSwitch(
                                                  activeColor: AppThemData.primary500,
                                                  value: verifyDocumentModel.isVerify ?? false,
                                                  onChanged: (value) async {
                                                    int index = controller.verifyDocumentList.indexOf(verifyDocumentModel);
                                                    if (index != -1) {
                                                      controller.verifyDocumentList[index] = verifyDocumentModel.copyWith(isVerify: value);
                                                      controller.verifyDocumentList.refresh();
                                                    }
                                                    // verifyDocumentModel.isVerify = value;
                                                    controller.isVerify.value = value;
                                                    // controller.updateVerifyStatus(verifyDocumentModel, value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]))
                                    .toList()),
                          ),
                        ),
                      ),
                    ),
                    spaceH(),
                    ContainerCustom(
                      padding: const EdgeInsets.all(0),
                      borderColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      child: Obx(
                        () {
                          if (controller.isLoadingVehicleDetails.value) {
                            // Show loader while loading
                            return Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            );
                          } else {
                            // Loading is complete
                            if (controller.driverUserDetails.value.driverVehicleDetails == null) {
                              // Data is not available
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Drive has not add other data ',
                                    style: TextStyle(
                                      color: AppThemData.primaryBlack,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Data is available, show details
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'Verify'.tr,
                                        ),
                                        SizedBox(
                                          height: 10,
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeColor: AppThemData.primary500,
                                              value: controller.driverUserDetails.value.driverVehicleDetails!.isVerified ?? false,
                                              onChanged: (value) async {
                                                controller.driverUserDetails.value.driverVehicleDetails!.isVerified = value;
                                                controller.driverUserDetails.refresh();
                                                // Save this change to Firestore or your backend.
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'BrandName'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.driverUserDetails.value.driverVehicleDetails!.brandName ?? "Driver has not added brand name",
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'ModelName'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.driverUserDetails.value.driverVehicleDetails!.modelName.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'VehicleNumber'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.driverUserDetails.value.driverVehicleDetails!.vehicleNumber.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'VehicleTypeName'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.driverUserDetails.value.driverVehicleDetails!.vehicleTypeName.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
            bottomWidgetList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    buttonTitle: "Close".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                    onPress: () {
                      Navigator.pop(context);
                    },
                  ),
                  spaceW(),
                  CustomButtonWidget(
                    buttonTitle: "Save".tr,
                    buttonColor: AppThemData.primary500,
                    onPress: () {
                      // editingVerifyDocumentId
                      // controller.updateVerifyStatus();
                      controller.saveData();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
            controller: controller,
          ),
        );
      },
    );
  }
}

rowDataWidget({required String name, required String value, required themeChange}) {
  return Row(
    children: [
      TextCustom(
        title: "${name.tr}  : ",
        fontSize: 14,
        fontFamily: AppThemeData.regular,
      ),
      TextCustom(
        title: value,
        fontSize: 14,
        fontFamily: AppThemeData.bold,
      ),
    ],
  );
}

viewURLImage(String image) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 300,
          width: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NetworkImageWidget(
                borderRadius: 12,
                height: 300,
                width: 400,
                imageUrl: image,
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppThemData.greyShade500),
                    child: const Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
