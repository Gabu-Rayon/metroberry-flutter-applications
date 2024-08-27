// ignore_for_file: depend_on_referenced_packages

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static bool isWebBrowser(BuildContext context) {
    return kIsWeb ? true : false;
  }

  static bool isAndroid(BuildContext context) {
    return ResponsiveWidget.isWebBrowser(context)
        ? false
        : Platform.isAndroid
            ? true
            : false;
  }

  static bool isiOS(BuildContext context) {
    return ResponsiveWidget.isWebBrowser(context)
        ? false
        : Platform.isIOS
            ? true
            : false;
  }

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
