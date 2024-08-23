import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoDataView extends StatelessWidget {
  final double? height;

  const NoDataView({
    super.key,
    required this.themeChange,
    this.height,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Responsive.height(50, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/animation/error.json', height: 300, width: 300),
          const SizedBox(
            height: 24,
          ),
          Text(
            'No Data Found'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
