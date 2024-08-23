import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/error_text.svg",
          color: Colors.black,
          height: 395,
        ),
        const SizedBox(height: 30),
        CustomButtonWidget(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          buttonTitle: "Go to Home",
          borderRadius: 60,
          buttonColor: Colors.black,
          textColor: Colors.white,
          onPress: () async {
            bool isLogin = await AppSharedPreference.appSharedPreference.getIsUserLoggedIn();
            if (!isLogin) {
              Get.offAllNamed(Routes.LOGIN_PAGE);
            } else {
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            }
          },
        ),
      ],
    );
  }
}
