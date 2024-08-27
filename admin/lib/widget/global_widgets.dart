import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:provider/provider.dart';

Widget spaceH({double? height}) => SizedBox(height: height ?? 10.0);

Widget spaceW({double? width}) => SizedBox(width: width ?? 10.0);

void printLog(String data) => log(data.toString());

EdgeInsets paddingEdgeInsets({double horizontal = 16, double vertical = 16}) {
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

divider(context, {Color? color, double height = 1}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Container(height: height, color: color ?? (themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50));
}

Widget customRadioButton(context, {required parameter, dynamic onChangeOne, dynamic onChangeTwo, required String title, required String radioOne, required String radioTwo}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      TextCustom(
        title: title,
        fontSize: 12,
      ),
      spaceH(height: 20),
      SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onChangeOne,
                  child: Row(
                    children: [
                      parameter == radioOne
                          ? const Icon(Icons.radio_button_checked, color: AppThemData.primary500, size: 18)
                          : Icon(Icons.circle_outlined, color: themeChange.isDarkTheme() ? AppThemData.greyShade100 : AppThemData.greyShade950, size: 18),
                      spaceW(width: 4),
                      TextCustom(title: radioOne)
                    ],
                  ),
                ),
              ),
              spaceW(),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onChangeTwo,
                  child: Row(children: [
                    parameter == radioTwo
                        ? const Icon(Icons.radio_button_checked, color: AppThemData.primary500, size: 18)
                        : Icon(Icons.circle_outlined, color: themeChange.isDarkTheme() ? AppThemData.greyShade100 : AppThemData.greyShade950, size: 18),
                    spaceW(width: 4),
                    TextCustom(title: radioTwo)
                  ]),
                ),
              )
            ],
          )),
    ],
  );
}
