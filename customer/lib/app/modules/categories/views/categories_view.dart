import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      appBar: AppBarWithBorder(title: 'Categories'.tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
      body: const Center(
          // child: ListView.builder(
          //   itemCount: 10,
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          //   itemBuilder: (context, index) {
          //     return const CategoryView(
          //     );
          //   },
          // ),
          ),
    );
  }
}
