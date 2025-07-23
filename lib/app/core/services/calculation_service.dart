import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/calculation_history_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing calculation history and saved breakdowns using Hive.
class CalculationService {
  /// The Hive box name for calculation history.
  static const String _calculationHistoryBoxName = 'calculation_history';

  /// The Hive box name for saved breakdowns.
  static const String _savedBreakDownsBoxName = 'saved_break_downs';

  /// Initializes the calculation service and opens Hive boxes.
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

  /// The Hive box for calculation history.
  Box<CalculationHistory> get calcualationHistoryBox =>
      Hive.box<CalculationHistory>(_calculationHistoryBoxName);

  /// The Hive box for saved breakdowns.
  Box<SavedBreakdownModel> get savedBreakDownBox =>
      Hive.box<SavedBreakdownModel>(_savedBreakDownsBoxName);

  /// Saves a calculation history entry.
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

  /// Returns calculation history entries filtered by [isFromUnitConversion].
  List<CalculationHistory> getCalculationHistory({
    required bool isFromUnitConversion,
  }) =>
      calcualationHistoryBox.values
          .where((e) => e.isFromUnitConversion == isFromUnitConversion)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  /// Clears calculation history entries filtered by [isFromUnitConversion].
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

  /// Saves a breakdown model.
  Future<void> saveBreakdown(SavedBreakdownModel data) async {
    await savedBreakDownBox.put(data.id, data);
  }

  /// Returns all saved calculations, sorted by creation date.
  List<SavedBreakdownModel> getSavedCalculations() {
    final savedCalculations = savedBreakDownBox.values.toList();
    savedCalculations
        .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    return savedCalculations;
  }

  /// Deletes a saved calculation by [id].
  Future<void> deleteSavedCalculation(String id) async {
    try {
      await savedBreakDownBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes all saved calculations.
  Future<void> deleteAllCalculation() async {
    await savedBreakDownBox.clear();
  }

  /// Returns calculation histories filtered by [siteId].
  List<SavedBreakdownModel> getCalculationHistoriesBySiteId({
    required String siteId,
  }) {
    final calcHistory = savedBreakDownBox.values
        .where(
          (model) => model.selectedSites.any(
            (site) => site['siteId'] == siteId,
          ),
        )
        .toList();
    calcHistory
        .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    return calcHistory;
  }
}
