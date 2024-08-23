import 'package:admin/app/modules/error_screen/views/widget/error_text.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/error_screen_controller.dart';

class ErrorScreenView extends GetView<ErrorScreenController> {
  const ErrorScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ErrorScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemData.greyShade50,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveWidget.isMobile(context)
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 500,
                              width: 300,
                              child: ErrorText(),
                            ),
                            spaceH(height: 50),
                            FittedBox(
                              child: Image.asset(
                                "assets/animation/cab_animation.gif",
                                fit: BoxFit.fitWidth,
                                height: 400,
                                width: 1000,
                              ),
                            ),
                          ],
                        )
                      : FittedBox(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/animation/cab_animation.gif",
                                fit: BoxFit.fitWidth,
                                height: 400.0,
                                width: 1000.0,
                              ),
                              const ErrorText(),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
