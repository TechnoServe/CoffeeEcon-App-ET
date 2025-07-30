import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

/// Controller for managing operational planning interface and site selection.
///
/// This controller handles the operational planning workflow including:
/// - Tab navigation between different planning stages
/// - Site selection for planning operations
/// - Integration with site service for site data
/// - Tab controller management for smooth transitions
///
/// The controller provides a structured approach to operational planning
/// with distinct stages for goal setting, machine setup, and processing configuration.
class OperationalPlanningController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Service for accessing site data and operations
  final SiteService _siteService = SiteService();
  /// List of selected sites for operational planning
  List<Map<String, String>> selectedSite = <Map<String, String>>[].obs;
  /// Available planning tabs representing different stages of the process
  final List<String> tabs = [
    'Coffee Processing Goal',
    'Pulping Machine',
    'Processing Setup'
  ];
  /// Currently selected tab for planning workflow
  RxString selectedTab = 'Coffee Processing Goal'.obs;
  /// List of available sites loaded from the service
  RxList<SiteInfo> sites = <SiteInfo>[].obs;

  /// Tab controller for managing tab navigation and animations
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // Initialize tab controller with the number of available tabs
    tabController = TabController(length: tabs.length, vsync: this);
    
    // Listen for tab changes and update selected tab accordingly
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabs[tabController.index];
      }
    });

    // Load available sites for selection
    loadSites();
  }

  /// Updates the selected tab and animates to the new tab.
  ///
  /// Finds the index of the specified tab and animates to it if different
  /// from the current tab position.
  ///
  /// [tab] - The name of the tab to switch to
  Future<void> updateTab(String tab) async {
    final index = tabs.indexOf(tab);
    if (index != -1 && tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  /// Navigates to a specific tab by index.
  ///
  /// Validates the index is within bounds and animates to the specified tab.
  ///
  /// [index] - The index of the tab to navigate to
  void goToTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
    }
  }

  /// Loads all available sites from the site service.
  ///
  /// Updates the sites observable list with all registered sites
  /// for selection in the operational planning process.
  void loadSites() {
    sites.assignAll(_siteService.getAllSites());
  }
}
