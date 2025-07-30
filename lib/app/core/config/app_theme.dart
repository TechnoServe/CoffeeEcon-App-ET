import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

/// Defines the application's theme data and color schemes.
/// This class provides consistent theming across the application
/// with responsive typography and custom color schemes.
class AppTheme {
  /// Private constructor to prevent instantiation.
  /// This class is designed to be used as a static utility class.
  AppTheme._();

  /// The light theme configuration for the app.
  /// This theme defines the visual appearance of the application
  /// including colors, typography, and component styling.
  static ThemeData get light => ThemeData(
        // Disable splash effects for cleaner button interactions
        splashFactory: NoSplash.splashFactory,
        // Remove highlight color for better touch feedback
        highlightColor: Colors.transparent,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.textWhite100,
        // Use custom font family for consistent typography
        fontFamily: 'EuclidCircularB',
        
        // App bar theme configuration
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0, // Flat design without shadow
          iconTheme: IconThemeData(color: AppColors.primary),
        ),
        
        // Text theme with responsive font sizes
        textTheme: TextTheme(
          // Large headlines for main titles
          headlineLarge: TextStyle(
            fontSize: 32.sp, // Responsive font size
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack100,
          ),
          // Medium headlines for section titles
          headlineMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.normal,
            color: AppColors.textBlack100,
          ),
          // Medium titles for important text
          titleMedium: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          // Small titles for secondary headings
          titleSmall: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack100,
          ),
          // Large body text for main content
          bodyLarge: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          // Medium body text for regular content
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          // Small body text for secondary content
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.textBlack60,
          ),
          // Small labels for form fields and captions
          labelSmall: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack60,
          ),
          // Medium labels for smaller text elements
          labelMedium: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlack60,
          ),
        ),
        
        // Color scheme with custom secondary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.secondary,
        ),
      );
}
