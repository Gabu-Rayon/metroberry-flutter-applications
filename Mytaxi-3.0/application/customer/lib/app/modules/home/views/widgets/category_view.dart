import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatelessWidget {
  final VehicleTypeModel vehicleType;
  final int index;
  final bool isForPayment;

  const CategoryView({super.key, required this.vehicleType, required this.index, required this.isForPayment});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final controller = Get.find<SelectLocationController>();
    return Obx(
      () => InkWell(
        onTap: () {
          controller.changeVehicleType(index);
        },
        child: Container(
          width: Responsive.width(100, context),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: isForPayment
                  ? BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100)
                  : controller.selectVehicleTypeIndex.value == index
                      ? BorderSide(width: 1, color: AppThemData.primary500)
                      : BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: vehicleType.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Constant.loader(),
                errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleType.title,
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${'We will arrived in '.tr}${controller.mapModel.value!.rows!.first.elements!.first.duration!.text ?? ''}',
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Constant.amountToShow(amount: controller.amountShow(vehicleType, controller.mapModel.value!)),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                      const SizedBox(width: 6),
                      Text(
                        vehicleType.persons,
                        style: GoogleFonts.inter(
                          color: AppThemData.primary500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
