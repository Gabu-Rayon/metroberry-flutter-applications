import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: Scaffold(
        body: Center(
            child: SingleChildScrollView(
          child: SizedBox(
            // margin: const EdgeInsets.only(left: 10, right: 10),
            // height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.9,
            // color: AppThemData.primaryWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 40.height,
                // Container(
                //   height: 300,
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   decoration: const BoxDecoration(
                //       color: Color(0xFFfff8f0),
                //       image: DecorationImage(
                //         image: AssetImage('assets/image/login.png'),
                //       )),
                // ),
                50.height,
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/logo.png",
                        height: 50,
                        color: AppThemData.primary500,
                      ),
                      spaceW(),
                      const TextCustom(
                        title: 'My Taxi',
                        color: AppThemData.primary500,
                        fontSize: 30,
                        fontFamily: AppThemeData.semiBold,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                ),
                30.height,
                TextCustom(
                  title: 'Unlock Your Admin \n Dashboard'.tr,
                  fontSize: 25,
                  maxLine: 2,
                  fontFamily: AppThemeData.bold,
                  // style: TextStyle(fontSize: 25, color: AppThemData.appColor, fontFamily: AppThemeData.bold, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: 'Password'.tr,
                      fontSize: 14,
                    ),
                    10.height,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                          style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                          autofocus: false,
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please enter your email".tr);
                            }
                            // reg expression for email validatio
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return ("Please enter a valid email".tr);
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // controller.emailController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          cursorColor: AppThemData.appColor,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              size: 18,
                              color: AppThemData.primaryBlack,
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                            hintText: "Enter your email".tr,
                            hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                            fillColor: AppThemData.primaryWhite,
                            filled: true,
                            isDense: true,
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: AppThemData.appColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: 'Password'.tr,
                      fontSize: 14,
                    ),
                    10.height,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Obx(
                        () => TextFormField(
                            style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                            cursorColor: AppThemData.appColor,
                            autofocus: false,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return ("Please enter your password".tr);
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter valid password(Min. 6 Character)".tr);
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) async {
                              controller.checkLogin();
                            },
                            onSaved: (value) {},
                            textInputAction: TextInputAction.next,
                            obscureText: controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () {
                                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                  },
                                  child: Icon(
                                    controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                    color: AppThemData.lightGrey01,
                                  )),
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                color: AppThemData.primaryBlack,
                              ),
                              isDense: true,
                              hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                              contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                              hintText: "Enter your password".tr,
                              fillColor: AppThemData.primaryWhite,
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    //color: Colors.blue,
                                    ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    controller.checkLogin();
                    // Get.toNamed(Routes.HOME);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text('LOGIN'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                  ),
                ),
                30.height,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: "Credentials : ".tr,
                            fontSize: 14,
                            fontFamily: AppThemeData.medium,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  "Email : ${controller.email.value}",
                                  style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.black),
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    controller.emailController.text = controller.email.value;
                                    controller.passwordController.text = controller.password.value;
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 14,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  "Password : ${controller.password.value}",
                                  style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.black),
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    controller.emailController.text = controller.email.value;
                                    controller.passwordController.text = controller.password.value;
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 14,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        )),
      ),
      desktop: Scaffold(
        body: Center(
            child: Container(
          // margin: const EdgeInsets.only(left: 20, right: 20),
          // height: MediaQuery.of(context).size.height * 0.6,
          // width: MediaQuery.of(context).size.width * 0.55,
          color: AppThemData.primaryWhite,
          child: Row(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.68,
                decoration: const BoxDecoration(
                    color: Color(0xFFfff8f0),
                    image: DecorationImage(
                      image: AssetImage('assets/image/login.png'),
                    )),
              ),
              // #fff8f0
              // Color(0xfff8f0)
              const SizedBox(
                width: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                // color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 50,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                    30.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextCustom(
                        title: 'Unlock Your Admin Dashboard'.tr, fontSize: 25, fontFamily: AppThemeData.bold,
                        // style: TextStyle(fontSize: 25, color: AppColors.appColor, fontFamily: AppThemeData.bold, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextCustom(
                          title: 'Email ID'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: TextFormField(
                              style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                              autofocus: false,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please enter your email".tr);
                                }
                                // reg expression for email validatio
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                  return ("Please enter a valid email".tr);
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // controller.emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: AppThemData.appColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 18,
                                  color: AppThemData.primaryBlack,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                hintText: "Enter your email".tr,
                                hintStyle: const TextStyle(color: AppThemData.gallery950, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                fillColor: AppThemData.primaryWhite,
                                filled: true,
                                isDense: true,
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: AppThemData.appColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Password'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Obx(
                            () => TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                cursorColor: AppThemData.appColor,
                                autofocus: false,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Please enter your password".tr);
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(Min. 6 Character)".tr);
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) async {
                                  controller.checkLogin();
                                },
                                onSaved: (value) {},
                                textInputAction: TextInputAction.next,
                                obscureText: controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                      child: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        color: AppThemData.lightGrey01,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  isDense: true,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontSize: 14, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your password".tr,
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        //color: Colors.blue,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.checkLogin();
                        // Get.toNamed(Routes.DASHBOARD_SCREEN);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.20,
                        decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Text('LOGIN'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                      ),
                    ),
                    30.height,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "Credentials : ".tr,
                                fontSize: 14,
                                fontFamily: AppThemeData.medium,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                      "Email : ${controller.email.value}",
                                      style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        controller.emailController.text = controller.email.value;
                                        controller.passwordController.text = controller.password.value;
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 14,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                      "Password : ${controller.password.value}",
                                      style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        controller.emailController.text = controller.email.value;
                                        controller.passwordController.text = controller.password.value;
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 14,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
      tablet: Scaffold(
        body: Center(
            child: Container(
          color: AppThemData.primaryWhite,
          child: Row(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.56,
                decoration: const BoxDecoration(
                    color: Color(0xFFfff8f0),
                    image: DecorationImage(
                      image: AssetImage('assets/image/login.png'),
                    )),
              ),
              // #fff8f0
              // Color(0xfff8f0)
              const SizedBox(
                width: 17,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                // color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo.png",
                            height: 50,
                            color: AppThemData.primary500,
                          ),
                          spaceW(),
                          const TextCustom(
                            title: 'My Taxi',
                            color: AppThemData.primary500,
                            fontSize: 30,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                    30.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextCustom(
                        title: 'Unlock Your Admin Dashboard'.tr, fontSize: 16, fontFamily: AppThemeData.bold,
                        // style: TextStyle(fontSize: 25, color: AppColors.appColor, fontFamily: AppThemeData.bold, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextCustom(
                          title: 'Email ID'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: TextFormField(
                              style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                              autofocus: false,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please enter your email".tr);
                                }
                                // reg expression for email validatio
                                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                  return ("Please enter a valid email".tr);
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // controller.emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: AppThemData.appColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 18,
                                  color: AppThemData.primaryBlack,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                hintText: "Enter your email".tr,
                                hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                fillColor: AppThemData.primaryWhite,
                                filled: true,
                                isDense: true,
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: AppThemData.appColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Password'.tr,
                          fontSize: 14,
                        ),
                        10.height,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Obx(
                            () => TextFormField(
                                style: TextStyle(color: AppThemData.primaryBlack, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                cursorColor: AppThemData.appColor,
                                autofocus: false,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Please enter your password".tr);
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(Min. 6 Character)".tr);
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) async {
                                  controller.checkLogin();
                                },
                                onSaved: (value) {},
                                textInputAction: TextInputAction.next,
                                obscureText: controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                      child: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        color: AppThemData.lightGrey01,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    color: AppThemData.primaryBlack,
                                  ),
                                  isDense: true,
                                  hintStyle: const TextStyle(color: AppThemData.gallery950, fontFamily: AppThemeData.medium, fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                  hintText: "Enter your password".tr,
                                  fillColor: AppThemData.primaryWhite,
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        //color: Colors.blue,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.checkLogin();
                        // Get.toNamed(Routes.HOME);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Text('LOGIN'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppThemeData.bold), textAlign: TextAlign.center)),
                      ),
                    ),
                    30.height,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "Credentials : ".tr,
                                fontSize: 13,
                                fontFamily: AppThemeData.medium,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => TextCustom(
                                      title: "Email : ${controller.email.value}",
                                      fontSize: 13,
                                      fontFamily: AppThemeData.medium,
                                      // style: const TextStyle(
                                      //     fontFamily: AppThemeData.medium,
                                      //     fontSize: 14,
                                      //     color: Colors.black
                                      // ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        controller.emailController.text = controller.email.value;
                                        controller.passwordController.text = controller.password.value;
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 13,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                      "Password : ${controller.password.value}",
                                      style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 13, color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        controller.emailController.text = controller.email.value;
                                        controller.passwordController.text = controller.password.value;
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 13,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
