import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SiteService _siteService = SiteService();
  final CalculationService _calculationService = CalculationService();
  List<Map<String, String>> selectedSite = <Map<String, String>>[].obs;
  final List<String> tabs = ['Basic', 'Advanced', 'Forecast'];
  // Initialize with a default tab, e.g., 'Basic'
  RxString selectedTab = 'Basic'.obs;
  RxList<SiteInfo> sites = <SiteInfo>[].obs;
  final RxList<SavedBreakdownModel> savedCalculations =
      <SavedBreakdownModel>[].obs;
  final RxList<SavedBreakdownModel> siteCalculationHistory =
      <SavedBreakdownModel>[].obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabs[tabController.index];
      }
    });

    loadSites();
    loadSavedCalcuations();
  }

  Future<void> updateTab(String tab) async {
    final index = tabs.indexOf(tab);
    if (index != -1 && tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  void goToTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
    }
  }

  void loadSites() {
    sites.assignAll(_siteService.getAllSites());
  }

  void loadSavedCalcuations() {
    savedCalculations.assignAll(_calculationService.getSavedCalculations());
  }

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
      await _calculationService.saveBreakdown(savedModel);
      loadSavedCalcuations();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to store your calculation, please try again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.textWhite100,
      );
    }
  }

  Future<void> deleteSavedCalculation(String id) async {
    await _calculationService.deleteSavedCalculation(id);
    loadSavedCalcuations();
  }

  Future<void> deleteAllSavedCalculation() async {
    await _calculationService.deleteAllCalculation();
    loadSavedCalcuations();
  }

  void loadCalculationsBySite({required String siteId}) {
    siteCalculationHistory.assignAll(
      _calculationService.getCalculationHistoriesBySiteId(siteId: siteId),
    );
  }

  List<SiteInfo> getSites() => selectedSite
      .map((siteMap) => _siteService.getSiteById(siteMap['siteId'] ?? ''))
      .whereType<SiteInfo>()
      .toList();
}

// Extension to parse from String
extension ResultsOverviewTypeExtension on ResultsOverviewType {
  String get name => toString().split('.').last;

  static ResultsOverviewType fromString(String name) =>
      ResultsOverviewType.values.firstWhere(
        (type) => type.name == name,
        orElse: () => throw ArgumentError('Invalid ResultsOverviewType: $name'),
      );
}
