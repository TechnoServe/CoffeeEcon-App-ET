import 'package:get/get.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/data/models/calculation_history_model.dart';

class HistoryController extends GetxController {
  final RxList<CalculationHistory> coffeeHistory = <CalculationHistory>[].obs;
  final RxList<CalculationHistory> unitHistory = <CalculationHistory>[].obs;

  Future<void> saveCalculation({
    required String fromUnit,
    required String toUnit,
    required String inputValue,
    required String result,
    required bool isFromUnitConversion,
  }) async {
    final history = CalculationHistory(
      fromStage: fromUnit,
      toStage: toUnit,
      inputAmount: inputValue,
      resultAmount: result,
      timestamp: DateTime.now(),
      isFromUnitConversion: isFromUnitConversion,
    );

    await Get.find<CalculationService>().saveCalculation(historyEntry: history);
    await loadHistory(isFromUnitConversion: isFromUnitConversion);
  }

  Future<void> loadHistory({required bool isFromUnitConversion}) async {
    final entries = Get.find<CalculationService>()
        .getCalculationHistory(isFromUnitConversion: isFromUnitConversion);

    if (isFromUnitConversion) {
      unitHistory.assignAll(entries);
    } else {
      coffeeHistory.assignAll(entries);
    }
  }

  Future<void> clearHistory({required bool isFromUnitConversion}) async {
    await Get.find<CalculationService>()
        .clearCalculationHistory(isFromUnitConversion: isFromUnitConversion);
    if (isFromUnitConversion) {
      unitHistory.clear();
    } else {
      coffeeHistory.clear();
    }

    await loadHistory(isFromUnitConversion: isFromUnitConversion);
  }
}
