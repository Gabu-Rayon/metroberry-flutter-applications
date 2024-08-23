import 'package:flutter/material.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class TextCustom extends StatelessWidget {
  final int? maxLine;
  final String title;
  final double? fontSize;
  final Color? color;
  final bool isLineThrough;
  final bool isUnderLine;
  final String? fontFamily;
  final FontWeight? fontWeight;

  const TextCustom(
      {super.key, this.isUnderLine = false, required this.title, this.isLineThrough = false, this.maxLine, this.fontSize = 14, this.fontFamily = AppThemeData.medium, this.color,this.fontWeight});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Text(title,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: fontSize,
            color: color ?? (themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
            decorationColor: color ?? (themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
            decoration: isLineThrough
                ? TextDecoration.lineThrough
                : isUnderLine
                    ? TextDecoration.underline
                    : null,
           fontWeight: fontWeight,
            fontFamily: fontFamily));
  }
}
