import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

// CalculatorController manages the state and logic for the calculator feature, including tab navigation, site management, calculation saving/loading, and unit conversion.
class CalculatorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Service for site-related operations
  final SiteService _siteService = SiteService();
  // Service for calculation-related operations
  final CalculationService _calculationService = CalculationService();
  // List of selected sites (as maps with site info)
  List<Map<String, String>> selectedSite = <Map<String, String>>[].obs;
  // Tab labels for the calculator (e.g., Basic and Advanced)
  final List<String> tabs = ['Basic', 'Advanced'];
  // Currently selected tab (observable)
  RxString selectedTab = 'Basic'.obs;
  // List of all available sites (observable)
  RxList<SiteInfo> sites = <SiteInfo>[].obs;
  // List of all saved calculations (observable)
  final RxList<SavedBreakdownModel> savedCalculations =
      <SavedBreakdownModel>[].obs;
  // List of calculation histories filtered by site (observable)
  final RxList<SavedBreakdownModel> siteCalculationHistory =
      <SavedBreakdownModel>[].obs;
  // TabController for managing tab navigation
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // Initialize TabController and listen for tab changes
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabs[tabController.index];
      }
    });

    // Load initial data for sites and saved calculations
    loadSites();
    loadSavedCalcuations();
  }

  // Update the selected tab by name and animate to it
  Future<void> updateTab(String tab) async {
    final index = tabs.indexOf(tab);
    if (index != -1 && tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  // Go to a specific tab by index
  void goToTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
    }
  }

  // Load all available sites from the site service
  void loadSites() {
    sites.assignAll(_siteService.getAllSites());
  }

  // Load all saved calculations from the calculation service
  void loadSavedCalcuations() {
    savedCalculations.assignAll(_calculationService.getSavedCalculations());
  }

  /// Save a calculation (basic or advanced) with all relevant details.
  /// This method creates a SavedBreakdownModel and persists it using the calculation service.
  /// After saving, it reloads the saved calculations list.
  /// Shows a snackbar if saving fails.
  Future<void> saveCalculation({
    required BasicCalculationEntryModel? basicCalcData,
    required AdvancedCalculationModel? advancedCalcData,
    required double totalSellingPrice,
    required String title,
    required List<Map<String, String>> selectedSites,
    required ResultsOverviewType type,
    required bool isBestPractice,
    double? breakEvenPrice,
    double? cherryPrice,
  }) async {
    final savedModel = SavedBreakdownModel(
      type: type,
      basicCalculation: basicCalcData,
      advancedCalculation: advancedCalcData,
      breakEvenPrice: breakEvenPrice,
      cherryPrice: cherryPrice,
      title: title,
      selectedSites: selectedSites,
      isBestPractice: isBestPractice,
    );

    try {
      // Debug print for break even price
      print({
        '################## break even modl ********************************* save called *****************************',
        savedModel.breakEvenPrice,
      });
      // Persist the calculation
      await _calculationService.saveBreakdown(savedModel);
      // Reload saved calculations
      loadSavedCalcuations();
    } catch (e) {
      // Show error message if saving fails
      Get.snackbar(
        'Error',
        'Unable to store your calculation, please try again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.textWhite100,
      );
    }
  }

  /// Delete a saved calculation by its ID and reload the saved calculations list.
  Future<void> deleteSavedCalculation(String id) async {
    await _calculationService.deleteSavedCalculation(id);
    loadSavedCalcuations();
  }

  /// Delete all saved calculations and reload the list.
  Future<void> deleteAllSavedCalculation() async {
    await _calculationService.deleteAllCalculation();
    loadSavedCalcuations();
  }

  /// Load calculation histories for a specific site by its ID.
  void loadCalculationsBySite({required String siteId}) {
    siteCalculationHistory.assignAll(
      _calculationService.getCalculationHistoriesBySiteId(siteId: siteId),
    );
  }

  /// Convert an input value from kilograms to another unit or vice versa.
  ///
  /// - [to]: The unit to convert to (e.g., 'KG', 'Pounds', etc.).
  /// - [input]: The value in kilograms to convert.
  ///
  /// Returns the converted value based on the unit conversion map in DropdownData.
  double convertUnit({required String to, required double input}) {
    print({'input is sssssssssssssss', input});
    print({'to is sssssssssssssss', to});

    // If the target unit is KG, return the input as is
    if (to == 'KG') {
      return input;
    }
    // Convert input to kilograms using the conversion factor
    final inKg = input * (DropdownData.unitToKg['Kilograms'] ?? 1);

    // Convert from kilograms to the target unit
    final result = inKg / (DropdownData.unitToKg[to] ?? 1);
    return result;
  }

  /// Get the list of selected SiteInfo objects based on selectedSite maps.
  List<SiteInfo> getSites() => selectedSite
      .map((siteMap) => _siteService.getSiteById(siteMap['siteId'] ?? ''))
      .whereType<SiteInfo>()
      .toList();
}

// Extension to parse from String and get the name for ResultsOverviewType enum
extension ResultsOverviewTypeExtension on ResultsOverviewType {
  // Get the enum name as a string
  String get name => toString().split('.').last;

  // Parse a string to ResultsOverviewType enum value
  static ResultsOverviewType fromString(String name) =>
      ResultsOverviewType.values.firstWhere(
        (type) => type.name == name,
        orElse: () => throw ArgumentError('Invalid ResultsOverviewType: $name'),
      );
}
