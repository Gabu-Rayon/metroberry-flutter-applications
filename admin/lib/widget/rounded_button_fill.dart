import 'package:flutter/material.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class RoundedButtonFill extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double radius;
  final double? fontSizes;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final bool? isRight;
  final String? fontFamily;
  final Function()? onPress;

  const RoundedButtonFill(
      {super.key,
      required this.title,
      this.radius = 10,
      this.height,
      required this.onPress,
      this.width,
      this.color,
      this.borderColor,
      this.icon,
      this.fontSizes,
      this.textColor,
      this.isRight,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPress!();
      },
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? color ?? const Color(0xFF000000)),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isRight == false) ? Padding(padding: const EdgeInsets.only(right: 5), child: icon) : const SizedBox(),
            Text(
              title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontFamily ?? AppThemeData.bold,
                color: textColor ?? (themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite),
                fontSize: fontSizes ?? 12,
              ),
            ),
            (isRight == true) ? Padding(padding: const EdgeInsets.only(left: 5), child: icon) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
