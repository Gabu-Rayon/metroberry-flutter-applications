// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final String? buttonTitle;

  final VoidCallback? onPress;

  const CustomButtonWidget({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.buttonColor,
    this.borderRadius,
    this.buttonTitle,
    this.textColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
        color: buttonColor ?? AppThemData.primary500,
        elevation: 0,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: radius(borderRadius ?? 10),
        ),
        padding: padding ?? paddingEdgeInsets(),
        height: height ?? 50,
        width: width,
        onTap: onPress,
        child: Text(buttonTitle ?? "", style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 16, color: textColor ?? AppThemData.primaryBlack), textAlign: TextAlign.center));
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String value;
  final String imageAssets;

  const CustomCard({super.key, required this.value, required this.imageAssets, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        margin: const EdgeInsets.all(10),
        // padding: const EdgeInsets.only(left: 25),
        height: 100,
        width: 310,
        decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage("assets/images/Card1.png"), fit: BoxFit.fill),
          border: Border.all(color: AppThemData.lightGrey06.withOpacity(.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.primaryWhite.withOpacity(.2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    imageAssets,
                    color: Colors.white,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: Constant.defaultTextStyle(size: 14, color: AppThemData.primaryWhite.withOpacity(.7)),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: 5,),
                    FittedBox(
                      child: Text(
                        value,
                        style: Constant.defaultTextStyle(size: 18, color: AppThemData.primaryWhite),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
