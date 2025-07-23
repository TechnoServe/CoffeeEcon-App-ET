import 'package:hive/hive.dart';

part 'basic_calculation_entry_model.g.dart';

/// Model representing a basic calculation entry for coffee processing.
@HiveType(typeId: 11)
class BasicCalculationEntryModel extends HiveObject {
  /// Creates a [BasicCalculationEntryModel] entry.
  BasicCalculationEntryModel({
    required this.totalSellingPrice,
    required this.purchaseVolume,
    required this.seasonalPrice,
    required this.fuelAndOils,
    required this.cherryTransport,
    required this.laborFullTime,
    required this.laborCasual,
    required this.repairsAndMaintenance,
    required this.otherExpenses,
    required this.ratio,
    required this.expectedProfit,
    required this.sellingType,
  });

  /// The purchase volume for the calculation.
  @HiveField(0)
  final String purchaseVolume;

  /// The seasonal price for the calculation.
  @HiveField(1)
  final String seasonalPrice;

  /// The fuel and oils cost for the calculation.
  @HiveField(2)
  final String fuelAndOils;

  /// The cherry transport cost for the calculation.
  @HiveField(3)
  final String cherryTransport;

  /// The full-time labor cost for the calculation.
  @HiveField(4)
  final String laborFullTime;

  /// The casual labor cost for the calculation.
  @HiveField(5)
  final String laborCasual;

  /// The repairs and maintenance cost for the calculation.
  @HiveField(6)
  final String repairsAndMaintenance;

  /// The other expenses for the calculation.
  @HiveField(7)
  final String otherExpenses;

  /// The ratio used in the calculation.
  @HiveField(8)
  final String ratio;

  /// The expected profit from the calculation.
  @HiveField(9)
  final String expectedProfit;

  /// The selling type for the calculation.
  @HiveField(10)
  final String sellingType;

  /// The total selling price from the calculation.
  @HiveField(11)
  final double totalSellingPrice;
}
