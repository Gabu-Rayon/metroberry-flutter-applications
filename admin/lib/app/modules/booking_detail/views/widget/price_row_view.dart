import 'package:flutter/material.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:provider/provider.dart';

class PriceRowView extends StatelessWidget {
  final String price;
  final String title;
  final Color priceColor;
  final Color titleColor;

  const PriceRowView({
    super.key,
    required this.price,
    required this.title,
    required this.priceColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: TextCustom(
             title:  title,
              fontFamily: AppThemeData.medium,
              fontSize: 14,

              // style: GoogleFonts.inter(
              //   color: titleColor,
              //   fontSize: 14,
              //   fontWeight: FontWeight.w400,
              // ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            child: Text(
              price,
              textAlign: TextAlign.right,
              style: TextStyle(color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
              // style:
              // GoogleFonts.inter(
              //   color: priceColor,
              //   fontSize: 14,
              //   fontWeight: FontWeight.w600,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
