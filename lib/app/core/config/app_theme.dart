import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

/// Defines the application's theme data and color schemes.
class AppTheme {
  /// Private constructor to prevent instantiation.
  AppTheme._();

  /// The light theme configuration for the app.
  static ThemeData get light => ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.textWhite100,
        fontFamily: 'EuclidCircularB',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primary),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack100,
          ),
          headlineMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.normal,
            color: AppColors.textBlack100,
          ),
          titleMedium: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack100,
          ),
          bodyLarge: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.textBlack60,
          ),
          labelSmall: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack60,
          ),
          labelMedium: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack60,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.secondary,
        ),
      );
}
