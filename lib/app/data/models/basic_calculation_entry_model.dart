import 'package:hive/hive.dart';

part 'basic_calculation_entry_model.g.dart';

@HiveType(typeId: 11)
class BasicCalculationEntryModel extends HiveObject {
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

  @HiveField(0)
  final String purchaseVolume;

  @HiveField(1)
  final String seasonalPrice;

  @HiveField(2)
  final String fuelAndOils;

  @HiveField(3)
  final String cherryTransport;

  @HiveField(4)
  final String laborFullTime;

  @HiveField(5)
  final String laborCasual;

  @HiveField(6)
  final String repairsAndMaintenance;

  @HiveField(7)
  final String otherExpenses;

  @HiveField(8)
  final String ratio;

  @HiveField(9)
  final String expectedProfit;

  @HiveField(10)
  final String sellingType;

  @HiveField(11)
  final double totalSellingPrice;
}
