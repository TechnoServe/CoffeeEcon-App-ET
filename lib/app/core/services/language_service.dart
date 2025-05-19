import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageCodeKey = 'language_code';
  static const String _countryCodeKey = 'country_code';

  Future<void> saveLanguage(String languageCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    await prefs.setString(_countryCodeKey, countryCode);
  }

  Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    final countryCode = prefs.getString(_countryCodeKey) ?? 'US';
    Get.updateLocale(Locale(languageCode, countryCode));
    return Locale(languageCode, countryCode);
  }
}
