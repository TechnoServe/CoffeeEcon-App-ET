import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Custom translations class that extends GetX Translations.
/// This class manages internationalization for the app by loading
/// translation files and providing access to localized strings.
class AppTranslations extends Translations {
  /// Static map to store all translations.
  /// This map holds translations for different locales (en_US, am_ET).
  static Map<String, Map<String, String>> translations = {};

  /// Loads translation files from assets and populates the translations map.
  /// This method reads JSON files from the assets/lang directory and converts
  /// them into a format that GetX can use for internationalization.
  static Future<void> loadTranslations() async {
    // Load English translation file from assets
    final enJson = await rootBundle.loadString('assets/lang/en.json');
    // Load Amharic translation file from assets
    final amJson = await rootBundle.loadString('assets/lang/am.json');

    // Parse and convert English translations
    // Cast the decoded JSON to Map<String, dynamic> first, then convert values to String
    translations['en_US'] = Map<String, String>.from(
      (json.decode(enJson) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    // Parse and convert Amharic translations
    translations['am_ET'] = Map<String, String>.from(
      (json.decode(amJson) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  /// Returns the translations map for GetX.
  /// This method is required by the Translations class and provides
  /// access to the loaded translations for the GetX internationalization system.
  @override
  Map<String, Map<String, String>> get keys => translations;
}
