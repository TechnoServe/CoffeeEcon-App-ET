import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

/// Controller for managing coffee processing site information and operations.
///
/// This controller handles all aspects of site management including:
/// - Site registration and information storage
/// - Form management for site details (name, location, capacity, etc.)
/// - CRUD operations for site data (create, read, update, delete)
/// - Integration with site service for data persistence
/// - State management for site lists and form validation
///
/// The controller manages comprehensive site information including processing capacity,
/// storage space, equipment details, and workforce information.
class SiteController extends GetxController {
  /// Service for site data persistence and retrieval
  final SiteService _siteService = SiteService();
  /// Form key for validation and submission handling
  late GlobalKey<FormState> formKey;
  /// Whether to auto-validate the main site form
  final RxBool autoValidate = false.obs;
  /// Whether to auto-validate the onboarding form
  final RxBool onBoardingAutoValidator = false.obs;

  // Observable list of sites
  /// List of all registered sites, updated reactively
  final RxList<SiteInfo> sites = <SiteInfo>[].obs;

  // site detail tab
  /// Currently selected tab in the site detail view
  final selectedTab = 0.obs;

  // Form controllers for each property
  /// Text controllers for all site form fields
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
  /// Reactive values for location and business model selections
  final locationValue = Rx<String?>(null);
  final businessValue = Rx<String?>(null);
  
  @override
  void onInit() {
    super.onInit();
    // Initialize form controllers and load existing sites
    loadControllers();
    loadSites();
  }

  /// Loads all sites from the service and updates the observable list
  void loadSites() {
    sites.assignAll(_siteService.getAllSites());
  }

  /// Initializes all text controllers for form input management
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

  /// Adds a new site to the system using form data.
  ///
  /// Creates a SiteInfo object from form inputs and saves it via the site service.
  /// Reloads the sites list after successful addition.
  ///
  /// Returns true if the site was successfully added, false otherwise.
  Future<bool> addSite() async {
    // Create site object from form data
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

  /// Populates form fields with data from an existing site.
  ///
  /// This method is used when editing an existing site to pre-fill the form
  /// with current site information.
  ///
  /// [site] - The site object containing data to populate the form
  Future<void> patchSiteInfo({SiteInfo? site}) async {
    if (site != null) {
      // Populate all form fields with site data
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

  /// Populates form fields with onboarding site data.
  ///
  /// This method is used during the onboarding process to pre-fill the form
  /// with data collected during the initial setup.
  ///
  /// [onBoardingSiteData] - The onboarding data object containing site information
  void patchOnBoardingSiteData(OnboardingSiteData? onBoardingSiteData) {
    if (onBoardingSiteData != null) {
      // Populate form with onboarding data
      siteNameController.text = onBoardingSiteData.siteName;
      locationController.text = onBoardingSiteData.locationValue;
      locationValue.value = onBoardingSiteData.locationValue;
      businessModelController.text = onBoardingSiteData.businessModelValue;
      businessValue.value = onBoardingSiteData.businessModelValue;
    }
  }

  /// Updates an existing site with form data.
  ///
  /// Creates an updated SiteInfo object from form inputs and saves it via the site service.
  /// Reloads the sites list after successful update.
  ///
  /// [site] - The original site object to update
  /// Returns true if the site was successfully updated, false otherwise.
  Future<bool> updateSite(SiteInfo site) async {
    // Create updated site object from form data
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

  /// Deletes a site from the system.
  ///
  /// Removes the site with the specified ID and reloads the sites list.
  ///
  /// [id] - The unique identifier of the site to delete
  Future<void> deleteSite(String id) async {
    await _siteService.deleteSite(id);
    loadSites();
  }

  /// Clears all form fields and resets form state.
  ///
  /// This method is used to reset the form when adding a new site or canceling edits.
  void clearForm() {
    // Clear all text controllers
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
    // Reset reactive values
    businessValue.value = null;
    locationValue.value = null;
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
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

  /// Setter for the selected tab index
  set tab(int index) => selectedTab.value = index;
}
