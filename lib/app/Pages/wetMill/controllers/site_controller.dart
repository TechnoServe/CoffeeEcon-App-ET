import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class SiteController extends GetxController {
  final SiteService _siteService = SiteService();
  late GlobalKey<FormState> formKey;
  final RxBool autoValidate = false.obs;
  final RxBool onBoardingAutoValidator = false.obs;

  // Observable list of sites
  final RxList<SiteInfo> sites = <SiteInfo>[].obs;

  // site detail tab
  final selectedTab = 0.obs;

  // Form controllers for each property
  late TextEditingController siteNameController;
  late TextEditingController locationController;
  late TextEditingController businessModelController;
  late TextEditingController processingCapacityController;
  late TextEditingController storageSpaceController;
  late TextEditingController dryingBedsController;
  late TextEditingController fermentationTanksController;
  late TextEditingController pulpingCapacityController;
  late TextEditingController workersController;
  late TextEditingController farmersController;
  late TextEditingController waterConsumptionController;
  final locationValue = Rx<String?>(null);
  final businessValue = Rx<String?>(null);
  @override
  void onInit() {
    super.onInit();
    loadControllers();
    loadSites();
  }

  void loadSites() {
    sites.assignAll(_siteService.getAllSites());
  }

  void loadControllers() {
    formKey = GlobalKey<FormState>();
    siteNameController = TextEditingController();
    locationController = TextEditingController();
    businessModelController = TextEditingController();
    processingCapacityController = TextEditingController();
    storageSpaceController = TextEditingController();
    dryingBedsController = TextEditingController();
    fermentationTanksController = TextEditingController();
    pulpingCapacityController = TextEditingController();
    workersController = TextEditingController();
    farmersController = TextEditingController();
    waterConsumptionController = TextEditingController();
  }

  Future<bool> addSite() async {
    final site = SiteInfo(
      siteName: siteNameController.text,
      location: locationController.text,
      businessModel: businessModelController.text,
      processingCapacity: int.tryParse(processingCapacityController.text) ?? 0,
      storageSpace: int.tryParse(storageSpaceController.text) ?? 0,
      dryingBeds: int.tryParse(dryingBedsController.text) ?? 0,
      fermentationTanks: int.tryParse(fermentationTanksController.text) ?? 0,
      pulpingCapacity: int.tryParse(pulpingCapacityController.text) ?? 0,
      workers: int.tryParse(workersController.text) ?? 0,
      farmers: int.tryParse(farmersController.text) ?? 0,
    );

    try {
      final bool success = await _siteService.addSite(site);
      if (success) {
        loadSites();
      }
      return success;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchSiteInfo({SiteInfo? site}) async {
    if (site != null) {
      siteNameController.text = site.siteName;
      locationController.text = site.location;
      locationValue.value = site.location;
      businessModelController.text = site.businessModel;
      businessValue.value = site.businessModel;
      processingCapacityController.text = site.processingCapacity.toString();
      storageSpaceController.text = site.storageSpace.toString();
      dryingBedsController.text = site.dryingBeds.toString();
      fermentationTanksController.text = site.fermentationTanks.toString();
      pulpingCapacityController.text = site.pulpingCapacity.toString();
      workersController.text = site.workers.toString();
      farmersController.text = site.farmers.toString();
    }
  }

  void patchOnBoardingSiteData(OnboardingSiteData? onBoardingSiteData) {
    if (onBoardingSiteData != null) {
      siteNameController.text = onBoardingSiteData.siteName;
      locationController.text = onBoardingSiteData.locationValue;
      locationValue.value = onBoardingSiteData.locationValue;
      businessModelController.text = onBoardingSiteData.businessModelValue;
      businessValue.value = onBoardingSiteData.businessModelValue;
    }
  }

  Future<bool> updateSite(SiteInfo site) async {
    final updatedSite = SiteInfo(
      id: site.id,
      siteName: siteNameController.text,
      location: locationController.text,
      businessModel: businessModelController.text,
      processingCapacity: int.tryParse(processingCapacityController.text) ?? 0,
      storageSpace: int.tryParse(storageSpaceController.text) ?? 0,
      dryingBeds: int.tryParse(dryingBedsController.text) ?? 0,
      fermentationTanks: int.tryParse(fermentationTanksController.text) ?? 0,
      pulpingCapacity: int.tryParse(pulpingCapacityController.text) ?? 0,
      workers: int.tryParse(workersController.text) ?? 0,
      farmers: int.tryParse(farmersController.text) ?? 0,
      createdAt: site.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      final bool success = await _siteService.updateSite(updatedSite);
      if (success) {
        loadSites();
      }
      return success;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSite(String id) async {
    await _siteService.deleteSite(id);
    loadSites();
  }

  void clearForm() {
    siteNameController.clear();
    locationController.clear();
    businessModelController.clear();
    processingCapacityController.clear();
    storageSpaceController.clear();
    dryingBedsController.clear();
    fermentationTanksController.clear();
    pulpingCapacityController.clear();
    workersController.clear();
    farmersController.clear();
    waterConsumptionController.clear();
    businessValue.value = null;
    locationValue.value = null;
  }

  @override
  void onClose() {
    siteNameController.dispose();
    locationController.dispose();
    businessModelController.dispose();
    processingCapacityController.dispose();
    storageSpaceController.dispose();
    dryingBedsController.dispose();
    fermentationTanksController.dispose();
    pulpingCapacityController.dispose();
    workersController.dispose();
    farmersController.dispose();
    waterConsumptionController.dispose();
    super.onClose();
  }

  set tab(int index) => selectedTab.value = index;
}
