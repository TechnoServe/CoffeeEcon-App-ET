import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for saving and retrieving the app's language and locale settings.
/// This service manages internationalization preferences and provides
/// methods to persist and restore user language choices.
class LanguageService {
  /// The key for storing the language code.
  /// Used in SharedPreferences to persist the selected language.
  static const String _languageCodeKey = 'language_code';

  /// The key for storing the country code.
  /// Used in SharedPreferences to persist the selected country/region.
  static const String _countryCodeKey = 'country_code';

  /// Saves the selected language and country code.
  /// This method persists the user's language preference to local storage
  /// so it can be restored when the app is reopened.
  /// 
  /// [languageCode] - The language code (e.g., 'en', 'am')
  /// [countryCode] - The country code (e.g., 'US', 'ET')
  Future<void> saveLanguage(String languageCode, String countryCode) async {
    // Get SharedPreferences instance for local storage
    final prefs = await SharedPreferences.getInstance();
    // Save language code to persistent storage
    await prefs.setString(_languageCodeKey, languageCode);
    // Save country code to persistent storage
    await prefs.setString(_countryCodeKey, countryCode);
  }

  /// Retrieves the saved locale and updates the app's locale.
  /// This method loads the previously saved language preference and
  /// updates the app's locale to match the user's choice.
  /// 
  /// Returns the restored Locale object
  Future<Locale> getSavedLocale() async {
    // Get SharedPreferences instance for local storage
    final prefs = await SharedPreferences.getInstance();
    // Retrieve saved language code with fallback to English
    final languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    // Retrieve saved country code with fallback to US
    final countryCode = prefs.getString(_countryCodeKey) ?? 'US';
    // Update the app's locale using GetX
    Get.updateLocale(Locale(languageCode, countryCode));
    // Return the restored locale
    return Locale(languageCode, countryCode);
  }
}
