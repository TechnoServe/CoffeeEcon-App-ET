import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Map<String, Map<String, String>> translations = {};

  static Future<void> loadTranslations() async {
    final enJson = await rootBundle.loadString('assets/lang/en.json');
    final amJson = await rootBundle.loadString('assets/lang/am.json');

    // Cast the decoded JSON to Map<String, dynamic> first, then convert values to String
    translations['en_US'] = Map<String, String>.from(
      (json.decode(enJson) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    translations['am_ET'] = Map<String, String>.from(
      (json.decode(amJson) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
