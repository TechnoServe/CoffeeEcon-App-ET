import 'dart:ui';

import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_constant.dart';
import 'package:flutter_template/app/core/services/language_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Controller for managing home page functionality and language settings.
/// This controller handles site data loading, language switching,
/// and provides reactive state management for the home page.
class HomeControllers extends GetxController {
  /// Service for managing wet mill site data.
  final SiteService _siteService = SiteService();
  
  /// Observable list of site information for the home page.
  /// This list is automatically updated when site data changes.
  final RxList<SiteInfo> sites = <SiteInfo>[].obs;
  
  /// Service for managing language preferences and locale settings.
  final LanguageService _languageService = LanguageService();

  /// Observable boolean indicating if Amharic language is currently selected.
  /// Used for language switching and UI updates.
  final isAmharic = true.obs;

 
  final List<String> imageUrls = [
    AppAssets.cherryAppLogo,
    AppAssets.farmControlImage,
    AppAssets.yirgaCheffeBackgroundImage,
  ];

  final List<String> linkUrls = [
    AppConstants.cherryAppUrl,
    AppConstants.farmControllerAppUrl,
    AppConstants.yirgaChefeWebUrl,
  ];

  @override
  void onInit() {
    super.onInit();
    // Load site data when controller initializes
    loadSites();
    // Load saved language preference
    _loadSavedLanguage();
  }

  /// Loads site data from the service.
  /// This method fetches site information and updates the observable list
  /// with a limit of 4 sites for the home page display.
  void loadSites() {
    sites.assignAll(
      _siteService.getAllSites(
        limit: 4,
      ),
    );
  }

  /// Toggles between Amharic and English languages.
  /// This method switches the app language and persists the choice
  /// to local storage for future app launches.
  void toggleLanguage() async {
    // Toggle the language state
    isAmharic.value = !isAmharic.value;
    // Determine language and country codes based on current state
    final languageCode = isAmharic.value ? 'am' : 'en';
    final countryCode = isAmharic.value ? 'ET' : 'US';
    // Save the language preference to local storage
    await _languageService.saveLanguage(languageCode, countryCode);
    // Update the app's locale
    _changeLanguage(languageCode, countryCode);
  }

  /// Changes the app's locale to the specified language and country.
  /// This method updates the GetX locale which triggers UI updates.
  /// 
  /// [languageCode] - The language code (e.g., 'am', 'en')
  /// [countryCode] - The country code (e.g., 'ET', 'US')
  void _changeLanguage(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  /// Loads the saved language preference from local storage.
  /// This method is called during initialization to restore the user's
  /// language choice from previous app sessions.
  void _loadSavedLanguage() async {
    // Get the saved locale from local storage
    final savedLocale = await _languageService.getSavedLocale();
    // Update the language state based on saved preference
    isAmharic.value = savedLocale.languageCode == 'am';
    // Update the app's locale to match saved preference
    Get.updateLocale(savedLocale);
  }

  /// Returns the appropriate flag asset based on current language.
  /// Shows Ethiopian flag for English and UK flag for Amharic.
  String get flagAsset =>
      !isAmharic.value ? AppAssets.etFlag : AppAssets.ukFlag;

  /// Returns the language text for the toggle button.
  /// Shows "አማርኛ" for English and "English" for Amharic.
  String get languageText => !isAmharic.value ? 'አማርኛ' : 'English';



Future<void> launchURL(String externalUrl) async {
  final Uri uri = Uri.parse(externalUrl);

  // Try external application first
  bool launched = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  // Fallback if that fails
  if (!launched) {
    launched = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
  }

  if (!launched) {
    throw 'Could not launch $externalUrl';
  }
}

}
