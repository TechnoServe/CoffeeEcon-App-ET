import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

/// Defines commonly used text styles for the app UI.
/// This class provides consistent typography styles across the application
/// with responsive font sizes and proper color schemes.
class AppTextStyles {
  /// Private constructor to prevent instantiation.
  /// This class is designed to be used as a static utility class.
  AppTextStyles._();

  /// Extra large heading style.
  /// Used for main page titles and prominent headings.
  /// Responsive font size that adapts to screen size.
  static final headingXL = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Large heading style.
  /// Used for section titles and important headings.
  /// Responsive font size for consistent scaling across devices.
  static final heading = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Subtitle style.
  /// Used for secondary headings and important text elements.
  /// Medium weight for emphasis without being too heavy.
  static final subtitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Small title style.
  /// Used for tertiary headings and card titles.
  /// Provides hierarchy without overwhelming the main content.
  static final smallTitle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Body text style.
  /// Used for main content and readable text.
  /// Normal weight for optimal readability.
  static final body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Label text style.
  /// Used for form labels and interactive element text.
  /// Medium weight for better visibility and emphasis.
  static final label = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Caption text style.
  /// Used for secondary information, captions, and helper text.
  /// Smaller size and lighter color for subtle information.
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textBlack60,
  );

  /// Hint text style.
  /// Used for placeholder text and input hints.
  /// Responsive size with lighter color for subtle appearance.
  static final hint = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack60,
  );

  /// Small text style.
  /// Used for fine print, metadata, and very small text elements.
  /// Smallest size for minimal information display.
  static final small = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack60,
  );
}
