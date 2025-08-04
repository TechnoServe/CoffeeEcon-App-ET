import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/best_practice_modal.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/utils/helpers.dart';
import 'package:get/get.dart';

/// Controller for managing the basic calculator functionality.
/// This controller handles form validation, cost calculations, best practice checks,
/// and navigation to results for the basic calculation mode.
class BasicCalculatorController extends GetxController {
  /// Global form key for form validation.

  // Text editing controllers for form fields
  final purchaseVolumeController = TextEditingController();
  final seasonalCoffeePriceController = TextEditingController();
  final cherryTransportController = TextEditingController();
  final laborFullTimeController = TextEditingController();
  final laborCasualController = TextEditingController();
  final fuelAndOilController = TextEditingController();
  final repairsAndMaintenance = TextEditingController();
  final otherExpensesController = TextEditingController();
  final ratioController = TextEditingController();
  final expectedProfitMarginController = TextEditingController();
  

  /// Observable map to track field validation alerts.
  /// Keys are field names, values indicate if the field has validation issues.
  final fieldAlerts = <String, bool>{}.obs;
  
  /// Observable total cost calculated from all expense fields.
  final totalCost = 0.0.obs;
  
  /// Break-even price calculated from total cost and ratio.
  double breakEvenPrice = 0.0;
  
  /// Observable flag for form auto-validation.
  final RxBool autoValidate = false.obs;
  
  /// Flag indicating if the calculation follows best practices.
  bool isBestPractice = true;
  
  /// Observable selected coffee selling type.
  final selectedTCoffeesellingType = RxnString();
  
  /// Observable selected unit for calculations (default: KG).
  final selectedUnit = 'KG'.obs;

 final Map<String, double> referenceTotalPerField = {};

  bool skipBestPracticeWarning = false;

  /// Map to store overridden percentage values for custom calculations.
  final Map<String, double> overriddenPercentages = {};

  /// Map to track fields where user has chosen to continue despite warnings.
  /// Used for "continue anyway" functionality when values are outside best practices.
  final Map<String, bool> overriddenFieldAlerts = {
    'seasonalPrice': false,
    'cherryTransport': false,
    'laborFullTime': false,
    'laborCasual': false,
    'fuelAndOils': false,
    'repairsAndMaintenance': false,
    'otherExpenses': false,
  };
  
  /// Available coffee types for selection.
  final coffeeTypes = [
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  
  /// Focus nodes for form fields to enable programmatic focus.
  /// Used when user chooses to edit a field from the best practice modal.
  final Map<String, FocusNode> fieldFocusNodes = {
    'seasonalPrice': FocusNode(),
    'cherryTransport': FocusNode(),
    'laborFullTime': FocusNode(),
    'laborCasual': FocusNode(),
    'fuelAndOils': FocusNode(),
    'repairsAndMaintenance': FocusNode(),
    'otherExpenses': FocusNode(),
  };

  final Map<String, bool> freezeContextShown = {
  'seasonalPrice': false,
  'cherryTransport': false,
  'laborFullTime': false,
  'laborCasual': false,
  'fuelAndOils': false,
  'repairsAndMaintenance': false,
  'otherExpenses': false,
};


  /// Validates dropdown selection for coffee selling type.
  /// 
  /// [val] - The selected value to validate
  /// Returns error message if validation fails, null if valid
  String? validateDropdown(String? val) {
    if (val == null || val.isEmpty) return 'Please select a selling type';
    return null;
  }

  /// Submits the form and navigates to results if validation passes.
  /// This method validates field percentages and proceeds to results
  /// only if all validation issues are resolved.
  void submit() {
    referenceTotalPerField.clear(); // clear any frozen totals before final check
   if(!skipBestPracticeWarning)  validateFieldPercentages();     // validate all fields with current total
    final remainingIssues = fieldAlerts.entries.where((e) => e.value).length;
    
    if (skipBestPracticeWarning || remainingIssues == 0) {
      final entry = buildCurrentEntryWithPrice();
      Get.toNamed<void>(
        AppRoutes.RESULTSOVERVIEWVIEW,
        arguments: {
          'type': ResultsOverviewType.basic,
          'basicCalcData': entry,
          'breakEvenPrice': breakEvenPrice,
          'isBestPractice': isBestPractice,
        },
      );
    }
  }


  /// Validates the percentage distribution of the 7 cost categories.
  /// This method checks if each expense category falls within recommended
  /// percentage ranges and updates field alerts accordingly.
 void validateFieldPercentages({String? freezeForField}) {
    // Collect all field values with fallback to 0
    final values = {
      'seasonalPrice': double.tryParse(seasonalCoffeePriceController.text) ?? 0,
      'cherryTransport': double.tryParse(cherryTransportController.text) ?? 0,
      'laborFullTime': double.tryParse(laborFullTimeController.text) ?? 0,
      'laborCasual': double.tryParse(laborCasualController.text) ?? 0,
      'fuelAndOils': double.tryParse(fuelAndOilController.text) ?? 0,
      'repairsAndMaintenance': double.tryParse(repairsAndMaintenance.text) ?? 0,
      'otherExpenses': double.tryParse(otherExpensesController.text) ?? 0,
    };

    // Calculate total cost from all fields
    final currentTotal = values.values.fold(0.0, (a, b) => a + b);
  
    totalCost.value = currentTotal;
    fieldAlerts.clear();

    // Validate each field against recommended percentage ranges
    values.forEach((key, val) {
      if (overriddenFieldAlerts[key] == true) {
        fieldAlerts[key] = false; // Respect user's decision to continue
        return;
      }

    // Check if frozen validation context should be used
    final shouldUseFrozen = (freezeForField != null && key == freezeForField) ||
                            overriddenFieldAlerts[key] == true ||
                            freezeContextShown[key] == true;

    double totalToUse = currentTotal;
    if (shouldUseFrozen) {
      final frozenTotalWithoutField = currentTotal - val;
      referenceTotalPerField[key] ??= frozenTotalWithoutField;
      totalToUse = referenceTotalPerField[key]!;
    }

    final percent = totalToUse > 0 ? (val / totalToUse) * 100 : 0;
    final range = CalcuationConstants.fieldRanges[key]!;

    fieldAlerts[key] = !(percent >= range.min && percent <= range.max);

    // Auto-clear overrides and frozen state if value becomes valid
    if (!fieldAlerts[key]!) {
      overriddenFieldAlerts[key] = false;
      referenceTotalPerField.remove(key);
      freezeContextShown[key] = false;
    }
  });

  update();
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
    purchaseVolumeController.dispose();
    seasonalCoffeePriceController.dispose();
    cherryTransportController.dispose();
    laborFullTimeController.dispose();
    laborCasualController.dispose();
    fuelAndOilController.dispose();
    repairsAndMaintenance.dispose();
    otherExpensesController.dispose();
    ratioController.dispose();
    expectedProfitMarginController.dispose();
    super.onClose();
  }

  /// Shows a modal dialog for best practice warnings.
  /// This method displays a bottom sheet when field values are outside
  /// recommended ranges, allowing users to continue or edit.
  /// 
  /// [context] - The build context for showing the modal
  /// [field] - The field name that triggered the warning
  /// [coffeeSellingType] - The selected coffee selling type
  /// [minValue] - The minimum recommended value
  /// [maxValue] - The maximum recommended value
  /// Returns a Future with the modal result
  Future<T?> showBestPracticeModal<T>({
    required BuildContext context,
    required String field,
    required String coffeeSellingType,
    required String minValue,
    required String maxValue,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BestPracticeModal(
          title: 'Value Outside Best Practices'.tr,
          message:
              "${'The'.tr} ${camelCaseToSpacedWords(field).tr}${' you entered is outside the recommended range. This may affect your cost calculations and profit estimates.'.tr}",
          recommendedRanges: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  'Recommended Range'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(Icons.circle, size: 4, color: Colors.black54),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(
                    text: field == 'seasonalPrice'
                        ? ' Lump-sum Seasonal Cherry Price: '
                        : '  ${camelCaseToSpacedWords(field)}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF717680),
                    ),
                  ),
                  TextSpan(
                    text: 'ETB $minValue to ETB $maxValue',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF252B37),
                    ),
                  ),
                ],
              ),
            ),
            if (field == 'seasonalPrice')
              const SizedBox(
                height: 4,
              ),
            if (field == 'seasonalPrice')
              Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(Icons.circle, size: 4, color: Colors.black54),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    const TextSpan(
                      text: ' Seasonal Cherry Price: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF717680),
                      ),
                    ),
                    TextSpan(
                      text: () {
                        // Parse the values for per-unit calculation
                        final minValueNum = double.tryParse(minValue);
                        final maxValueNum = double.tryParse(maxValue);
                        final volumeNum =
                            double.tryParse(purchaseVolumeController.text);

                        // Check if all values are valid and divisor is not zero
                        if (minValueNum != null &&
                            maxValueNum != null &&
                            volumeNum != null &&
                            volumeNum != 0) {
                          final minResult = minValueNum / volumeNum;
                          final maxResult = maxValueNum / volumeNum;

                          // Format to 2 decimal places
                          return 'ETB ${minResult.toStringAsFixed(2)} to ETB ${maxResult.toStringAsFixed(2)}';
                        } else {
                          return 'ETB ? to ETB ?'; // Fallback for invalid input
                        }
                      }(), // Immediately executed function for dynamic calculation
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF252B37),
                      ),
                    ),
                    TextSpan(
                      text: ' per ${selectedUnit.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF717680),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          tip:
              'Double-check your input and ensure it aligns with industry best practices for better results.'
                  .tr,
          onContinue: () {
            final remainingIssues =
                fieldAlerts.entries.where((e) => e.value).length;
            fieldAlerts[field] = false;
            overriddenFieldAlerts[field] = true;
            if (remainingIssues == 1) {
              final entry = buildCurrentEntryWithPrice();

              isBestPractice = false;
              Navigator.pop(context);

              Get.toNamed<void>(
                AppRoutes.RESULTSOVERVIEWVIEW,
                arguments: {
                  'type': ResultsOverviewType.basic,
                  'basicCalcData': entry,
                  'breakEvenPrice': breakEvenPrice,
                  'isBestPractice': isBestPractice,
                },
              );
            } else {
              update();
              Navigator.pop(context);
            }
          },
          onEdit: () {
            Navigator.pop(context);
             referenceTotalPerField.remove(field);
            if (fieldFocusNodes.containsKey(field)) {
              // Delay focus until after the frame has settled
              Future.delayed(const Duration(milliseconds: 100), () {
                fieldFocusNodes[field]?.requestFocus();
              });
            }
          },
        ),
      );

  /// Shows field range warning modal for a specific field.
  /// This method calculates the recommended range based on total cost
  /// and displays the best practice modal.
  /// 
  /// [context] - The build context for showing the modal
  /// [fieldKey] - The field key to show warning for
void showFieldRangeWarning({
  required BuildContext context,
  required String fieldKey,
}) {
  final range = CalcuationConstants.fieldRanges[fieldKey];
  if (range == null) return;

  // Freeze validation total for this field
  validateFieldPercentages(freezeForField: fieldKey);
  freezeContextShown[fieldKey] = true;

final fieldValue = double.tryParse(
    {
      'seasonalPrice': seasonalCoffeePriceController.text,
      'cherryTransport': cherryTransportController.text,
      'laborFullTime': laborFullTimeController.text,
      'laborCasual': laborCasualController.text,
      'fuelAndOils': fuelAndOilController.text,
      'repairsAndMaintenance': repairsAndMaintenance.text,
      'otherExpenses': otherExpensesController.text,
    }[fieldKey] ?? '0',
  ) ?? 0;

  final frozenBaseTotal = referenceTotalPerField[fieldKey] ?? (totalCost.value - fieldValue);
  final effectiveTotal = frozenBaseTotal; // Don't re-add the field value

  final minPrice = (effectiveTotal * (range.min / 100)).toStringAsFixed(2);
  final maxPrice = (effectiveTotal * (range.max / 100)).toStringAsFixed(2);


  showBestPracticeModal<void>(
    context: context,
    field: fieldKey,
    coffeeSellingType: selectedTCoffeesellingType.value ?? '',
    minValue: minPrice,
    maxValue: maxPrice,
  );
}


  /// Patches previous calculation data into the form fields.
  /// This method is used when editing a previously saved calculation.
  /// 
  /// [data] - The previous calculation data to load
  void patchPreviousData({BasicCalculationEntryModel? data}) {
    if (data != null) {
      print({'callllllled here-------------------------',data.purchaseVolume});

      // Populate all form fields with previous data
      purchaseVolumeController.text = data.purchaseVolume;
      seasonalCoffeePriceController.text = data.seasonalPrice;
      fuelAndOilController.text = data.fuelAndOils;
      cherryTransportController.text = data.cherryTransport;
      laborFullTimeController.text = data.laborFullTime;
      laborCasualController.text = data.laborCasual;
      repairsAndMaintenance.text = data.repairsAndMaintenance;
      otherExpensesController.text = data.otherExpenses;
      ratioController.text = data.ratio;
      expectedProfitMarginController.text = data.expectedProfit;
      selectedTCoffeesellingType.value = data.sellingType;
      print({'callllllled here-------------------------',purchaseVolumeController.text});
      update();
    }
  }

  /// Builds the current calculation entry with calculated prices.
  /// This method creates a BasicCalculationEntryModel with all form data
  /// and calculates the break-even price and total selling price.
  /// 
  /// Returns the complete calculation entry model
  BasicCalculationEntryModel buildCurrentEntryWithPrice() {
    final purchaseVolume = double.tryParse(purchaseVolumeController.text) ?? 0;
    final ratio = double.tryParse(ratioController.text) ?? 0;
    final expectedProfit =
        double.tryParse(expectedProfitMarginController.text) ?? 0;

    // Calculate ratio output and break-even price
    final ratioOutput = purchaseVolume * ratio;
    breakEvenPrice = ratioOutput > 0 ? totalCost.value / ratioOutput : 0;
    // Calculate total selling price with profit margin
    final totalSellingPrice =
        breakEvenPrice + (breakEvenPrice * (expectedProfit / 100));

    return BasicCalculationEntryModel(
      purchaseVolume: purchaseVolumeController.text,
      seasonalPrice: seasonalCoffeePriceController.text,
      fuelAndOils: fuelAndOilController.text,
      cherryTransport: cherryTransportController.text,
      laborFullTime: laborFullTimeController.text,
      laborCasual: laborCasualController.text,
      repairsAndMaintenance: repairsAndMaintenance.text,
      otherExpenses: otherExpensesController.text,
      ratio: ratioController.text,
      expectedProfit: expectedProfitMarginController.text,
      sellingType: selectedTCoffeesellingType.value ?? '',
      totalSellingPrice: totalSellingPrice,
    );
  }

}
