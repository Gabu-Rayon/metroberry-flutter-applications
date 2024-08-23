// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/screen_size.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.darkGrey01,
        borderRadius: BorderRadius.circular(borderRadius ?? 60),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 60),
        child: CachedNetworkImage(
          fit: fit ?? BoxFit.cover,
          height: height ?? ScreenSize.height(8, context),
          width: width ?? ScreenSize.width(15, context),
          imageUrl: imageUrl,
          color: color,
          progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
          errorWidget: (context, url, error) =>
              errorWidget ??
              Image.asset(
                Constant.userPlaceHolder,
                height: height ?? ScreenSize.height(8, context),
                width: width ?? ScreenSize.width(15, context),
              ),
        ),
      ),
    );
  }
}
