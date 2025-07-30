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
/// This function initializes the Flutter framework and sets up the app configuration
/// before launching the main app widget.
void main() async {
  // Ensure Flutter bindings are initialized before any platform channels are used
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock the app to portrait orientation only for consistent UI experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // Optional
  ]);
  
  // Load translation files for internationalization support
  await AppTranslations.loadTranslations();

  // Configure system UI overlay to have transparent status bar with light icons
  // This creates a more immersive app experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // Load environment variables and configuration from .env files
  // This must be done before any services that depend on environment variables
  await Env.load();

  // Initialize all application services (API clients, databases, etc.)
  await initServices();
  
  // Retrieve the user's saved language preference
  await LanguageService().getSavedLocale();

  // Get the saved locale again to ensure we have the latest value
  final savedLocale = await LanguageService().getSavedLocale();

  // Launch the main application with the user's preferred locale
  runApp(MyApp(savedLocale: savedLocale));
}

/// The root widget of the application.
/// This widget sets up the GetX material app with all necessary configurations
/// including translations, routing, theming, and responsive design.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance with the given [savedLocale].
  const MyApp({required this.savedLocale, super.key});

  /// The locale to use for the app, retrieved from user preferences
  final Locale savedLocale;
  
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        // Set the design size for responsive UI scaling
        // This ensures the app looks consistent across different screen sizes
        designSize: const Size(375, 812),
        // Enable minimum text adaptation for better text scaling
        minTextAdapt: true,
        builder: (context, child) => GetMaterialApp(
          // Configure internationalization with custom translations
          translations: AppTranslations(),
          // Use the user's saved locale preference
          locale: savedLocale,
          // Fallback locale if the saved locale is not available
          fallbackLocale: const Locale('en', 'US'),
          // Disable the debug banner in release builds
          debugShowCheckedModeBanner: false,
          // Set the app title from constants
          title: AppConstants.appName,
          // Apply the light theme configuration
          theme: AppTheme.light,
          // Initialize dependency injection bindings
          initialBinding: AppBindings(),
          // Define all app routes for navigation
          getPages: AppPages.routes,
          // Set the initial route to splash screen
          initialRoute: AppRoutes.SPLASH,
        ),
      );
}
