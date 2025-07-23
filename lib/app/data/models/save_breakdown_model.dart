import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'save_breakdown_model.g.dart';

/// Model representing a saved breakdown of a calculation or plan.
@HiveType(typeId: 10)
class SavedBreakdownModel extends HiveObject {
  /// Creates a [SavedBreakdownModel] entry.
  SavedBreakdownModel({
    required this.title,
    required this.selectedSites,
    required this.isBestPractice,
    required this.type,
    this.basicCalculation,
    this.advancedCalculation,
    this.breakEvenPrice,
    this.cherryPrice,
    String? id,
    DateTime? createdAt,
    this.deletedAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// The unique identifier for the breakdown entry.
  @HiveField(0)
  final String id;

  /// The type of results overview for this breakdown.
  @HiveField(1)
  final ResultsOverviewType type;

  /// The basic calculation data, if applicable.
  @HiveField(2)
  final BasicCalculationEntryModel? basicCalculation;

  /// The advanced calculation data, if applicable.
  @HiveField(3)
  final AdvancedCalculationModel? advancedCalculation;

  /// The break-even price for the calculation.
  @HiveField(4)
  final double? breakEvenPrice;

  /// The cherry price for the calculation.
  @HiveField(5)
  final double? cherryPrice;

  /// The title of the breakdown entry.
  @HiveField(7)
  final String title;

  /// The list of selected sites for the breakdown.
  @HiveField(8)
  final List<Map<String, String>> selectedSites;

  /// The creation date of the breakdown entry.
  @HiveField(9)
  final DateTime createdAt;

  /// The deletion date of the breakdown entry, if deleted.
  @HiveField(10)
  final DateTime? deletedAt;

  /// The last update date of the breakdown entry.
  @HiveField(11)
  final DateTime updatedAt;

  /// Whether this breakdown is marked as best practice.
  @HiveField(12)
  final bool isBestPractice;
}
