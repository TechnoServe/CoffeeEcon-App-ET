import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

class OperationalPlanningController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SiteService _siteService = SiteService();
  List<Map<String, String>> selectedSite = <Map<String, String>>[].obs;
  final List<String> tabs = [
    'Coffee Processing Goal',
    'Pulping Machine',
    'Processing Setup'
  ];
  RxString selectedTab = 'Coffee Processing Goal'.obs;
  RxList<SiteInfo> sites = <SiteInfo>[].obs;

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
}
