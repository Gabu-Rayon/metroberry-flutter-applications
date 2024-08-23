import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/app/modules/select_location/views/widgets/confirm_pickup_location.dart';
import 'package:customer/app/modules/select_location/views/widgets/finding_driver.dart';
import 'package:customer/app/modules/select_location/views/widgets/select_location_bottom_sheet.dart';
import 'package:customer/app/modules/select_location/views/widgets/select_vehicle_type_bottom_sheet.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/select_location_controller.dart';

class SelectLocationView extends StatelessWidget {
  const SelectLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SelectLocationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(title: "Select Location", bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            body: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      SizedBox(
                        height: Responsive.height(80, context),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(controller.sourceLocation!.latitude, controller.sourceLocation!.longitude),
                            zoom: 5,
                          ),
                          padding: const EdgeInsets.only(
                            top: 22.0,
                          ),
                          polylines: Set<Polyline>.of(controller.polyLines.values),
                          markers: Set<Marker>.of(controller.markers.values),
                          onMapCreated: (GoogleMapController mapController) {
                            controller.mapController = mapController;
                          },
                        ),
                      ),
                      if (controller.popupIndex.value == 0) ...{
                        DraggableScrollableSheet(
                          initialChildSize: 0.82,
                          snapSizes: const [0.82],
                          minChildSize: 0.82,
                          snap: true,
                          expand: true,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return const SelectLocationBottomSheet();
                          },
                        ),
                      },
                      if (controller.popupIndex.value == 1) ...{
                        DraggableScrollableSheet(
                          initialChildSize: 0.50,
                          snapSizes: const [0.31, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60],
                          minChildSize: 0.31,
                          maxChildSize: 0.60,
                          snap: true,
                          expand: true,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return SelectVehicleTypeBottomSheet(
                              scrollController: scrollController,
                            );
                          },
                        ),
                      },
                      if (controller.popupIndex.value == 2) ...{
                        DraggableScrollableSheet(
                          initialChildSize: 0.25,
                          snapSizes: const [0.21, 0.25, 0.30],
                          minChildSize: 0.21,
                          maxChildSize: 0.30,
                          snap: true,
                          expand: true,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return ConfirmPickupBottomSheet(
                              scrollController: scrollController,
                            );
                          },
                        ),
                      },
                      if (controller.popupIndex.value == 3) ...{
                        DraggableScrollableSheet(
                          initialChildSize: 0.50,
                          snapSizes: const [0.31, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60],
                          minChildSize: 0.31,
                          maxChildSize: 0.60,
                          snap: true,
                          expand: true,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return FindingDriverBottomSheet(
                              scrollController: scrollController,
                            );
                          },
                        ),
                      },
                      InkWell(
                        onTap: () {
                          if (controller.bookingModel.value.id == null || controller.bookingModel.value.id == "") {
                            if (controller.popupIndex.value == 0) {
                              controller.setBookingData(true);
                              Get.offAll(const HomeView());
                            } else if (controller.popupIndex.value == 2) {
                              controller.popupIndex.value = 1;
                            } else {
                              controller.popupIndex.value = 0;
                              controller.dropFocusNode.requestFocus();
                              controller.setBookingData(true);
                            }
                          } else {
                            Get.offAll(const HomeView());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.fromLTRB(20, 55, 20, 30),
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back,
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
