import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/best_practice_modal.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/utils/helpers.dart';
import 'package:get/get.dart';

class BasicCalculatorController extends GetxController {
  final formKey = GlobalKey<FormState>();

  //intialize the controllers
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
  final fieldAlerts = <String, bool>{}.obs;
  final totalCost = 0.0.obs;
  double breakEvenPrice = 0.0;
  final RxBool autoValidate = false.obs;
  bool isBestPractice = true;
  final selectedTCoffeesellingType = RxnString();
  final selectedUnit = 'KG'.obs;

  final Map<String, double> overriddenPercentages = {};

  //used for continue anyway
  final Map<String, bool> overriddenFieldAlerts = {
    'seasonalPrice': false,
    'cherryTransport': false,
    'laborFullTime': false,
    'laborCasual': false,
    'fuelAndOils': false,
    'repairsAndMaintenance': false,
    'otherExpenses': false,
  };
  final coffeeTypes = [
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  //focus node for edit
  final Map<String, FocusNode> fieldFocusNodes = {
    'seasonalPrice': FocusNode(),
    'cherryTransport': FocusNode(),
    'laborFullTime': FocusNode(),
    'laborCasual': FocusNode(),
    'fuelAndOils': FocusNode(),
    'repairsAndMaintenance': FocusNode(),
    'otherExpenses': FocusNode(),
  };

  String? validateDropdown(String? val) {
    if (val == null || val.isEmpty) return 'Please select a selling type';
    return null;
  }

  void submit() {
    validateFieldPercentages();

    final remainingIssues = fieldAlerts.entries.where((e) => e.value).length;

    if (remainingIssues == 0) {
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

  //to validate the percentage of the 7 cost list

  //to validate the percentage of the 7 cost list

  void validateFieldPercentages() {
    final values = {
      'seasonalPrice': double.tryParse(seasonalCoffeePriceController.text) ?? 0,
      'cherryTransport': double.tryParse(cherryTransportController.text) ?? 0,
      'laborFullTime': double.tryParse(laborFullTimeController.text) ?? 0,
      'laborCasual': double.tryParse(laborCasualController.text) ?? 0,
      'fuelAndOils': double.tryParse(fuelAndOilController.text) ?? 0,
      'repairsAndMaintenance': double.tryParse(repairsAndMaintenance.text) ?? 0,
      'otherExpenses': double.tryParse(otherExpensesController.text) ?? 0,
    };

    final total = values.values.fold(0.0, (a, b) => a + b);
    totalCost.value = total;
    fieldAlerts.clear();

    values.forEach((key, val) {
      if (overriddenFieldAlerts[key] == true) {
        fieldAlerts[key] = false; // Respect user's decision to continue

        return;
      }
      final percent = total > 0 ? ((val / total) * 100).roundToDouble() : 0;
      final range = CalcuationConstants.fieldRanges[key]!;
      fieldAlerts[key] = !range.isInRange(
        percent.toDouble(),
      );
    });
    update();
  }

  @override
  void onClose() {
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
                        ? ' Lumpsum Seasonal Cherry Price: '
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
                  // if (field != 'seasonalPrice')
                  //   TextSpan(
                  //     text: ' per ${selectedUnit.value}',
                  //     style: const TextStyle(
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: 12,
                  //       color: Color(0xFF717680),
                  //     ),
                  //   ),
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
                        // Parse the values
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

                          // Format to 2 decimal places (or use 0 if whole numbers)
                          return 'ETB ${minResult.toStringAsFixed(2)} to ETB ${maxResult.toStringAsFixed(2)}';
                        } else {
                          return 'ETB ? to ETB ?'; // Fallback for invalid input
                        }
                      }(), // <-- Note: this is an immediately executed function
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

            // handle continue
          },
          onEdit: () {
            Navigator.pop(context);
            if (fieldFocusNodes.containsKey(field)) {
              // Delay focus until after the frame has settled
              Future.delayed(const Duration(milliseconds: 100), () {
                fieldFocusNodes[field]?.requestFocus();
              });
            }
          },
        ),
      );

  void showFieldRangeWarning({
    required BuildContext context,
    required String fieldKey,
  }) {
    final range = CalcuationConstants.fieldRanges[fieldKey];
    if (range == null) return;

    final total = totalCost.value;
    final minPrice = (total * (range.min / 100)).toStringAsFixed(2);
    final maxPrice = (total * (range.max / 100)).toStringAsFixed(2);

    showBestPracticeModal<void>(
      context: context,
      field: fieldKey,
      coffeeSellingType: selectedTCoffeesellingType.value ?? '',
      minValue: minPrice,
      maxValue: maxPrice,
    );
  }

  void patchPreviousData({BasicCalculationEntryModel? data}) {
    if (data != null) {
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
    }
  }

  BasicCalculationEntryModel buildCurrentEntryWithPrice() {
    final purchaseVolume = double.tryParse(purchaseVolumeController.text) ?? 0;
    final ratio = double.tryParse(ratioController.text) ?? 0;
    final expectedProfit =
        double.tryParse(expectedProfitMarginController.text) ?? 0;

    final ratioOutput = purchaseVolume * ratio;
    breakEvenPrice = ratioOutput > 0 ? totalCost.value / ratioOutput : 0;
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
