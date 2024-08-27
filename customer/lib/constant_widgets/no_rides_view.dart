import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/select_location/views/select_location_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NoRidesView extends StatelessWidget {
  final double? height;

  const NoRidesView({
    super.key,
    required this.themeChange,
    this.height,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Responsive.height(75, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icon/ic_no_rides.svg"),
          const SizedBox(
            height: 24,
          ),
          Text(
            'No Rides Found'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 24),
            child: Text(
              'Your ride history is currently empty. Start your journey with MyTaxi by booking your first ride now!'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: RoundShapeButton(
                size: const Size(200, 45),
                title: "Book Now".tr,
                buttonColor: AppThemData.primary500,
                buttonTextColor: AppThemData.black,
                onTap: () {
                  Get.to(const SelectLocationView());
                }),
          ),
        ],
      ),
    );
  }
}
