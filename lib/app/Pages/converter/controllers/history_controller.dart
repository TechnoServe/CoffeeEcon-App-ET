import 'package:get/get.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/data/models/calculation_history_model.dart';

/// Controller for managing calculation history and conversion records.
///
/// This controller handles the persistence and retrieval of conversion calculations including:
/// - Coffee grade conversion history
/// - Unit conversion history
/// - Saving new calculation results
/// - Loading historical calculations
/// - Clearing history records
///
/// The controller provides separate tracking for coffee conversions and unit conversions,
/// allowing users to review their previous calculations and conversion patterns.
class HistoryController extends GetxController {
  /// List of coffee grade conversion history entries
  final RxList<CalculationHistory> coffeeHistory = <CalculationHistory>[].obs;
  /// List of unit conversion history entries
  final RxList<CalculationHistory> unitHistory = <CalculationHistory>[].obs;

  /// Saves a new calculation to the history.
  ///
  /// Creates a CalculationHistory entry with the conversion details and saves it
  /// to persistent storage. Reloads the appropriate history list after saving.
  ///
  /// [fromUnit] - The source unit or coffee grade
  /// [toUnit] - The target unit or coffee grade
  /// [inputValue] - The input value that was converted
  /// [result] - The result of the conversion
  /// [isFromUnitConversion] - Whether this is a unit conversion (true) or coffee grade conversion (false)
  Future<void> saveCalculation({
    required String fromUnit,
    required String toUnit,
    required String inputValue,
    required String result,
    required bool isFromUnitConversion,
  }) async {
    // Create history entry with current timestamp
    final history = CalculationHistory(
      fromStage: fromUnit,
      toStage: toUnit,
      inputAmount: inputValue,
      resultAmount: result,
      timestamp: DateTime.now(),
      isFromUnitConversion: isFromUnitConversion,
    );

    // Save to persistent storage and reload history
    await Get.find<CalculationService>().saveCalculation(historyEntry: history);
    await loadHistory(isFromUnitConversion: isFromUnitConversion);
  }

  /// Loads calculation history from persistent storage.
  ///
  /// Retrieves historical calculations based on the conversion type and
  /// updates the appropriate observable list.
  ///
  /// [isFromUnitConversion] - Whether to load unit conversion history (true) or coffee grade conversion history (false)
  Future<void> loadHistory({required bool isFromUnitConversion}) async {
    // Get history entries from calculation service
    final entries = Get.find<CalculationService>()
        .getCalculationHistory(isFromUnitConversion: isFromUnitConversion);

    // Update the appropriate history list based on conversion type
    if (isFromUnitConversion) {
      unitHistory.assignAll(entries);
    } else {
      coffeeHistory.assignAll(entries);
    }
  }

  /// Clears all calculation history for the specified conversion type.
  ///
  /// Removes all historical calculations from persistent storage and
  /// updates the appropriate observable list.
  ///
  /// [isFromUnitConversion] - Whether to clear unit conversion history (true) or coffee grade conversion history (false)
  Future<void> clearHistory({required bool isFromUnitConversion}) async {
    // Clear from persistent storage
    await Get.find<CalculationService>()
        .clearCalculationHistory(isFromUnitConversion: isFromUnitConversion);
    
    // Clear the appropriate observable list
    if (isFromUnitConversion) {
      unitHistory.clear();
    } else {
      coffeeHistory.clear();
    }

    // Reload history to ensure UI is updated
    await loadHistory(isFromUnitConversion: isFromUnitConversion);
  }
}
