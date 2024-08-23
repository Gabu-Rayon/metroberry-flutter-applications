import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';

class CommonDialog extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final String positiveButtonLabel;
  final Function(String) onPositiveButtonPressed;
  final String negativeButtonLabel;
  final Function()? onNegativeButtonPressed;
  final Widget? prefix;

  // final List<TextInputFormatter>? inputFormatters;

  const CommonDialog({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
    this.prefix,
    required this.positiveButtonLabel,
    required this.onPositiveButtonPressed,
    this.negativeButtonLabel = 'Cancel',
    this.onNegativeButtonPressed,
  });

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_walletTopUp.svg',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 5,
                  left: 16,
                ),
                suffixIconColor: AppThemData.borderGrey,
                fillColor: AppThemData.lightGrey01,
                filled: true,
                hintText: widget.hintText,
                prefix: widget.prefix,
                hintStyle: const TextStyle(fontFamily: AppThemeData.regular, color: AppThemData.green800),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(width: 0.5, color: AppThemData.red400),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        CustomButtonWidget(
            buttonColor: AppThemData.borderGrey,
            buttonTitle: widget.negativeButtonLabel,
            width: 150,
            onPress: () async {
              if (widget.onNegativeButtonPressed != null) {
                widget.onNegativeButtonPressed!();
              } else {
                Get.back();
              }
            }),
        CustomButtonWidget(
            buttonTitle: widget.positiveButtonLabel,
            width: 150,
            onPress: () async {
              log('===>');
              widget.onPositiveButtonPressed(widget.controller.text);
                        }),
        // TextButton(
        //   onPressed: () {
        //     if (onNegativeButtonPressed != null) {
        //       onNegativeButtonPressed!();
        //     } else {
        //       Get.back();
        //     }
        //   },
        //   child: Text(negativeButtonLabel),
        // ),
        // TextButton(
        //   onPressed: () {
        //     onPositiveButtonPressed(controller.text);
        //   },
        //   child: Text(positiveButtonLabel),
        // ),
      ],
    );
  }
}
