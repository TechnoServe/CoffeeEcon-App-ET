import 'package:get/get.dart';

/// Provides static data for dropdown menus used throughout the app.
// ignore: avoid_classes_with_only_static_members
class DropdownData {
  /// List of coffee grades for dropdowns.
  static List<String> coffeeGrades = [
    'Cherries'.tr,
    'Pulped Parchment'.tr,
    'Wet Parchment'.tr,
    'Dry Parchment'.tr,
    'Unsorted Green Coffee'.tr,
    'Export Green'.tr,
    'Dried pod/Jenfel'.tr,
  ];

  /// List of units for dropdowns.
  static List<String> units = [
    'Grams'.tr,
    'Kilograms'.tr,
    'Feresula'.tr,
    'Qt'.tr,
    'Mt'.tr
  ];

  /// List of location options.
  static const List<String> locations = [
    'Gedio/yergachefe, Ethiopia',
    'Sidama, Ethiopia',
    'Jimma, Ethiopia',
    'Shakiso, Ethiopia',
    'Guji, Ethiopia',
  ];

  /// Mapping of units to their kilogram equivalents.
  static const Map<String, double> unitToKg = {
    'Grams': 0.001,
    'Kilograms': 1.0,
    'Feresula': 17.0,
    'Qt': 100.0,
    'Pound': 0.45359237,
    'Metric Ton': 1000.0, // Added metric ton (1 ton = 1000 kg)
    "Mt": 1000.0, // Added metric ton (1 ton = 1000 kg)
  };

  /// List of business model options.
  static const List<String> businessModels = [
    'Direct Export',
    'Supplier',
    'Cooperative',
    'Other',
  ];

  /// List of coffee types.
  static const coffeeTypes = [
    'Cherries',
    'Parchment',
    'Green Coffee',
    'Pods',
    'Beans'
  ];

  /// List of jute bag volumes.
  static const jutBagVolumes = [
    '17',
    '60',
    '100',
  ];
}
