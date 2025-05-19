import 'dart:ui';

import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/services/language_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class HomeControllers extends GetxController {
  final SiteService _siteService = SiteService();
  final RxList<SiteInfo> sites = <SiteInfo>[].obs;
  final LanguageService _languageService = LanguageService();

  final isAmharic = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSites();
    _loadSavedLanguage();
  }

  void loadSites() {
    sites.assignAll(
      _siteService.getAllSites(
        limit: 4,
      ),
    );
  }

  void toggleLanguage() async {
    isAmharic.value = !isAmharic.value;
    final languageCode = isAmharic.value ? 'am' : 'en';
    final countryCode = isAmharic.value ? 'ET' : 'US';
    await _languageService.saveLanguage(languageCode, countryCode);
    _changeLanguage(languageCode, countryCode);
  }

  void _changeLanguage(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  void _loadSavedLanguage() async {
    final savedLocale = await _languageService.getSavedLocale();
    isAmharic.value = savedLocale.languageCode == 'am';
    Get.updateLocale(savedLocale);
  }

  String get flagAsset =>
      !isAmharic.value ? AppAssets.etFlag : AppAssets.ukFlag;

  String get languageText => !isAmharic.value ? 'አማርኛ' : 'English';
}
