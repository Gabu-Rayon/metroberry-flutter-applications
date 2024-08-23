// ignore_for_file: deprecated_member_use

import 'package:admin/app/modules/error_screen/bindings/error_screen_binding.dart';
import 'package:admin/app/modules/error_screen/views/error_screen_view.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/services/localization_service.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return ScreenUtilInit(
              designSize: const Size(390, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return GetMaterialApp(
                  scrollBehavior: MyCustomScrollBehavior(),
                  theme:
                      ThemeData(useMaterial3: false, primaryColor: AppThemData.primaryBlack, primaryTextTheme: const TextTheme(), unselectedWidgetColor: AppThemData.greyShade500),
                  themeMode: ThemeMode.light,
                  debugShowCheckedModeBanner: false,
                  locale: LocalizationService.locale,
                  fallbackLocale: LocalizationService.locale,
                  translations: LocalizationService(),
                  title: "MyTaxi",
                  initialRoute: AppPages.INITIAL,
                  getPages: AppPages.routes,
                  unknownRoute: GetPage(name: Routes.ERROR_SCREEN, page: () => const ErrorScreenView(), binding: ErrorScreenBinding(), transition: Transition.fadeIn),
                );
              });
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
