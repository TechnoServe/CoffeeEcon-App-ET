import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for saving and retrieving the app's language and locale settings.
class LanguageService {
  /// The key for storing the language code.
  static const String _languageCodeKey = 'language_code';

  /// The key for storing the country code.
  static const String _countryCodeKey = 'country_code';

  /// Saves the selected language and country code.
  Future<void> saveLanguage(String languageCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    await prefs.setString(_countryCodeKey, countryCode);
  }

  /// Retrieves the saved locale and updates the app's locale.
  Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    final countryCode = prefs.getString(_countryCodeKey) ?? 'US';
    Get.updateLocale(Locale(languageCode, countryCode));
    return Locale(languageCode, countryCode);
  }
}
