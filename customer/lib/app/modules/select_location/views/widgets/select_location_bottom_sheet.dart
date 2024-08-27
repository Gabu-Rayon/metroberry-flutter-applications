import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/google_places_flutter.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/model/prediction.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class SelectLocationBottomSheet extends StatelessWidget {
  const SelectLocationBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: SelectLocationController(),
        builder: (controller) {
          log("===> ${Constant.mapAPIKey}");
          return Container(
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
              color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: ShapeDecoration(
                    color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Text(
                  'Select Location'.tr,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Timeline.tileBuilder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  theme: TimelineThemeData(
                    nodePosition: 0,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  builder: TimelineTileBuilder.connected(
                    contentsAlign: ContentsAlign.basic,
                    indicatorBuilder: (context, index) {
                      return index == 0 ? SvgPicture.asset("assets/icon/ic_pick_up.svg") : SvgPicture.asset("assets/icon/ic_drop_in.svg");
                    },
                    connectorBuilder: (context, index, connectorType) {
                      return DashedLineConnector(
                        color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey300,
                      );
                    },
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: index == 0 ? controller.pickupLocationController : controller.dropLocationController,
                        googleAPIKey: Constant.mapAPIKey,
                        boxDecoration: BoxDecoration(
                          color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        inputDecoration: InputDecoration(
                          hintText: index == 0 ? "Pick up Location".tr : "Destination Location".tr,
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          hintStyle: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textStyle: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        clearData: () {
                          if (index == 0) {
                            controller.sourceLocation = null;
                            controller.updateData();
                            controller.polyLines.clear();
                          } else {
                            controller.destination = null;
                            controller.updateData();
                            controller.polyLines.clear();
                          }
                        },
                        debounceTime: 800,
                        isLatLngRequired: true,
                        focusNode: index == 0 ? controller.pickUpFocusNode : controller.dropFocusNode,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          if (index == 0) {
                            controller.sourceLocation = LatLng(double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                            controller.updateData();
                          } else {
                            controller.destination = LatLng(double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                            controller.updateData();
                          }
                        },
                        itemClick: (postalCodeResponse) {
                          if (index == 0) {
                            controller.pickupLocationController.text = postalCodeResponse.description ?? '';
                          } else {
                            controller.dropLocationController.text = postalCodeResponse.description ?? '';
                          }
                        },
                        itemBuilder: (context, index, Prediction prediction) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                    child: Text(
                                  prediction.description ?? "",
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ))
                              ],
                            ),
                          );
                        },
                        seperatedBuilder: Container(),
                        isCrossBtnShown: true,
                        containerHorizontalPadding: 10,
                      ),
                    ),
                    itemCount: 2,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
