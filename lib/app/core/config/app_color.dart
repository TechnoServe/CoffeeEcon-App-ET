import 'dart:ui';

/// Defines the color palette used throughout the app.
/// This class centralizes all color definitions to ensure consistency
/// and make it easier to maintain the app's visual design system.
class AppColors {
  // Base colors for the app's design system
  /// The primary brand color.
  /// Used for main actions, buttons, and brand elements.
  static const Color primary = Color(0xFF07696D);

  /// The secondary background color.
  /// Used for subtle backgrounds and secondary UI elements.
  static const Color secondary = Color(0xFFF5F5F5);

  /// The main background color.
  /// Used as the default background for screens and containers.
  static const Color background = Color(0xFFFBFBFB);

  /// A lighter background color.
  /// Used for subtle background variations and hover states.
  static const Color background60 = Color(0xFFFAFAFA);

  /// The main stroke color.
  /// Used for borders, dividers, and subtle separators.
  static const Color stroke100 = Color(0xFFE8E8E8);

  /// The surface color for cards and sheets.
  /// Used for elevated surfaces like cards and bottom sheets.
  static const Color surface = Color(0xFFFFFFFF);

  /// A cyan accent color.
  /// Used for special highlights and accent elements.
  static const Color themeCyan = Color(0xFF00B3B0);

  /// Various shades of grey for UI elements.
  /// These provide a consistent grayscale palette for different UI needs.
  static const Color grey20 = Color(0xFFFAFAFA); // Lightest grey
  static const Color grey50 = Color(0xFFD5D7DA); // Light grey
  static const Color grey60 = Color(0xFFA4A7AE); // Medium light grey
  static const Color grey70 = Color(0xFF717680); // Medium grey
  static const Color grey80 = Color(0xFF535862); // Medium dark grey
  static const Color grey90 = Color(0xFF414651); // Dark grey
  static const Color grey100 = Color(0xFF252B37); // Darkest grey

  /// A blue accent color.
  /// Used for special UI elements and secondary brand colors.
  static const Color themeBlue = Color(0xFF1F2176);

  // Text colors for different content types
  /// The primary text color.
  /// Used for main content and important text.
  static const Color textPrimary = Color(0xFF1E1E1E);

  /// A lighter black for text.
  /// Used for secondary text and less important content.
  static const Color textBlack60 = Color(0xFF717680);

  /// The darkest black for text.
  /// Used for headings and high-contrast text.
  static const Color textBlack100 = Color(0xFF252B37);

  /// White text color.
  /// Used for text on dark backgrounds.
  static const Color textWhite100 = Color(0xFFFFFFFF);

  /// A lighter white for text.
  /// Used for subtle text on light backgrounds.
  static const Color textWhite60 = Color(0xFFE0E0E0);

  // Status colors for different states and feedback
  /// Success color for status indicators.
  /// Used for success messages, confirmations, and positive states.
  static const Color success = Color(0xff039855);

  /// Warning color for status indicators.
  /// Used for warnings, alerts, and caution states.
  static const Color warning80 = Color(0xffDC6803);

  /// Error color for status indicators.
  /// Used for error messages, validation failures, and critical states.
  static const Color error = Color(0xFFD92D20);

  /// A lighter error color.
  /// Used for error backgrounds and subtle error indicators.
  static const Color error20 = Color(0xFFFEF3F2);

  /// A darker error color.
  /// Used for prominent error elements and high-contrast error states.
  static const Color error70 = Color(0xFFF04438);

  // UI element colors for consistent component styling
  /// Border color for UI elements.
  /// Used for input fields, cards, and other bordered elements.
  static const Color border = Color(0xFFE0E0E0);

  /// Disabled state color.
  /// Used for disabled buttons, inputs, and inactive elements.
  static const Color disabled = Color(0xFFBDBDBD);

  /// Divider color for UI separation.
  /// Used for list separators and content dividers.
  static const Color divider = Color(0xFFE0E0E0);

  // Icon colors for consistent icon styling
  /// Icon color for black icons.
  /// Used for icons that need to be visible on light backgrounds.
  static const Color iconBlack80 = Color(0xFF717680);
}
