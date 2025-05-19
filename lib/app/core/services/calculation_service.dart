import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/calculation_history_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalculationService {
  static const String _calculationHistoryBoxName = 'calculation_history';
  static const String _savedBreakDownsBoxName = 'saved_break_downs';

  Future<CalculationService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CalculationHistoryAdapter());
    Hive.registerAdapter(SavedBreakdownModelAdapter());
    Hive.registerAdapter(BasicCalculationEntryModelAdapter());
    Hive.registerAdapter(AdvancedCalculationModelAdapter());
    Hive.registerAdapter(ResultsOverviewTypeAdapter());
    await Hive.openBox<CalculationHistory>(_calculationHistoryBoxName);
    await Hive.openBox<SavedBreakdownModel>(_savedBreakDownsBoxName);

    return this;
  }

  Box<CalculationHistory> get calcualationHistoryBox =>
      Hive.box<CalculationHistory>(_calculationHistoryBoxName);

  Box<SavedBreakdownModel> get savedBreakDownBox =>
      Hive.box<SavedBreakdownModel>(_savedBreakDownsBoxName);

  Future<void> saveCalculation({
    required CalculationHistory historyEntry,
  }) async {
    await calcualationHistoryBox.add(historyEntry);

    final filtered = calcualationHistoryBox.values
        .where(
          (e) => e.isFromUnitConversion == historyEntry.isFromUnitConversion,
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (filtered.length > 5) {
      final itemsToRemove = filtered.sublist(5);
      final keys = itemsToRemove.map((e) => e.key).toList();
      await calcualationHistoryBox.deleteAll(keys);
    }
  }

  List<CalculationHistory> getCalculationHistory({
    required bool isFromUnitConversion,
  }) =>
      calcualationHistoryBox.values
          .where((e) => e.isFromUnitConversion == isFromUnitConversion)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  Future<void> clearCalculationHistory({
    required bool isFromUnitConversion,
  }) async {
    final calcualationHistoryBox =
        Hive.box<CalculationHistory>(_calculationHistoryBoxName);
    final keys = calcualationHistoryBox.values
        .where((e) => e.isFromUnitConversion == isFromUnitConversion)
        .map((e) => e.key)
        .toList();
    await calcualationHistoryBox.deleteAll(keys);
  }

  Future<void> saveBreakdown(SavedBreakdownModel data) async {
    await savedBreakDownBox.put(data.id, data);
  }

  List<SavedBreakdownModel> getSavedCalculations() {
    final savedCalculations = savedBreakDownBox.values.toList();
    savedCalculations
        .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    return savedCalculations;
  }

  Future<void> deleteSavedCalculation(String id) async {
    try {
      await savedBreakDownBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllCalculation() async {
    await savedBreakDownBox.clear();
  }

  List<SavedBreakdownModel> getCalculationHistoriesBySiteId({
    required String siteId,
  }) =>
      savedBreakDownBox.values
          .where(
            (model) => model.selectedSites.any(
              (site) => site['siteId'] == siteId,
            ),
          )
          .toList();
}
