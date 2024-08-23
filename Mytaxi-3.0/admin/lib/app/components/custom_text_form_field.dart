// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatelessWidget {
  final String? title;
  final String hintText;
  final String? tooltipsText;
  final TextEditingController? controller;
  final Function()? onPress;
  final dynamic onChanged;
  final dynamic onSubmit;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? obscureText;
  final int? maxLine;
  final TextInputType? textInputType;
  final double bottom;
  final double top;
  final bool tooltipsShow;
  final bool isReadOnly;
  final validator;
  final Color? color;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField(
      {super.key,
      this.textInputType,
      this.enable,
      this.prefix,
      this.suffix,
      this.title,
      this.tooltipsText,
      required this.hintText,
      required this.controller,
      this.onPress,
      this.maxLine,
      this.isReadOnly = false,
      this.inputFormatters,
      this.obscureText,
      this.top = 0,
      this.bottom = 16.0,
      this.tooltipsShow = false,
      this.onChanged,
      this.onSubmit,
      this.validator,
      this.color
      });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null) ...{
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tooltipsShow == true
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: ResponsiveWidget.isDesktop(context) ? 200 :80,
                            child: TextCustom(
                              title: title ?? '',
                              maxLine: 1,
                              fontSize: 14,
                            ),
                          ),
                          Tooltip(
                            message: tooltipsText,
                            child: IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {},
                            ),
                          )
                        ],
                      )
                    : TextCustom(
                        title: title ?? '',
                        fontSize: 14,
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          },
          TextFormField(
            onTap: onPress,
            readOnly: isReadOnly,
            validator: validator ?? (value) => value != null && value.isNotEmpty ? null : 'required',
            cursorColor: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            maxLines: maxLine ?? 1,
            textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            onFieldSubmitted: onSubmit,
            style: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950, fontFamily: AppThemeData.medium),
            decoration: InputDecoration(
                errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.greyShade100,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: prefix != null ? 0 : 10),
                prefixIcon: prefix,
                prefixIconColor: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                suffixIcon: suffix,
                suffixIconColor: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                  ),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: themeChange.isDarkTheme() ? AppThemData.greyShade400 : AppThemData.greyShade950,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppThemeData.medium)),
          ),
        ],
      ),
    );
  }
}
