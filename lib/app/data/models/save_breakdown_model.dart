import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'save_breakdown_model.g.dart';

@HiveType(typeId: 10)
class SavedBreakdownModel extends HiveObject {
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

  @HiveField(0)
  final String id;

  @HiveField(1)
  final ResultsOverviewType type;

  @HiveField(2)
  final BasicCalculationEntryModel? basicCalculation;

  @HiveField(3)
  final AdvancedCalculationModel? advancedCalculation;

  @HiveField(4)
  final double? breakEvenPrice;

  @HiveField(5)
  final double? cherryPrice;

  @HiveField(7)
  final String title;

  @HiveField(8)
  final List<Map<String, String>> selectedSites;
  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? deletedAt;

  @HiveField(11)
  final DateTime updatedAt;

  @HiveField(12)
  final bool isBestPractice;
}
