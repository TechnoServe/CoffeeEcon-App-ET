import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_theme.dart';
import 'package:flutter_template/app/core/config/app_constant.dart';
import 'package:flutter_template/app/core/localization/translations.dart';
import 'package:flutter_template/app/core/services/language_service.dart';

import 'package:flutter_template/app/init/app_binding.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/utils/env_loader.dart';
import 'package:get/get.dart';

import 'app/init/service_initializer.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // Optional
  ]);
  await AppTranslations.loadTranslations();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  // Load the appropriate env file
  await Env.load();

  await initServices();
  await LanguageService().getSavedLocale();

  final savedLocale = await LanguageService().getSavedLocale();

  runApp(MyApp(savedLocale: savedLocale));
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance with the given [savedLocale].
  const MyApp({required this.savedLocale, super.key});

  /// The locale to use for the app.
  final Locale savedLocale;
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => GetMaterialApp(
          translations: AppTranslations(),
          locale: savedLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.light,
          initialBinding: AppBindings(),
          getPages: AppPages.routes,
          initialRoute: AppRoutes.SPLASH,
        ),
      );
}
