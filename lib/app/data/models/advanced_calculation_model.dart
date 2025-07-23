import 'package:hive/hive.dart';

part 'advanced_calculation_model.g.dart';

@HiveType(typeId: 6)
class AdvancedCalculationModel extends HiveObject {
  AdvancedCalculationModel({
    required this.cherryPurchase,
    required this.seasonalCoffee,
    required this.secondPayment,
    required this.lowGradeHulling,
    required this.juteBagPrice,
    required this.juteBagVolume,
    required this.ratio,
    required this.procurementExtras,
    required this.transportCost,
    required this.commission,
    required this.transportExtras,
    required this.casualLabour,
    required this.permanentLabour,
    required this.overhead,
    required this.otherLabour,
    required this.fuelCost,
    required this.fuelExtras,
    required this.utilities,
    required this.annualMaintenance,
    required this.dryingBed,
    required this.sparePart,
    required this.maintenanceExtras,
    required this.otherExpenses,
    required this.otherExtras,
    required this.procurementTotal,
    required this.transportTotal,
    required this.casualTotal,
    required this.permanentTotal,
    required this.fuelTotal,
    required this.maintenanceTotal,
    required this.otherTotal,
    required this.jutBagTotal,
    required this.variableCostTotal,
    required this.sellingType,
  });

  @HiveField(1)
  String cherryPurchase;
  @HiveField(2)
  String seasonalCoffee;
  @HiveField(3)
  String secondPayment;
  @HiveField(4)
  String lowGradeHulling;
  @HiveField(5)
  String juteBagPrice;
  @HiveField(6)
  String juteBagVolume;
  @HiveField(7)
  String ratio;
  @HiveField(8)
  List<Map<String, String>> procurementExtras;

  @HiveField(9)
  String transportCost;
  @HiveField(10)
  String commission;
  @HiveField(11)
  List<Map<String, String>> transportExtras;

  @HiveField(12)
  String casualLabour;
  @HiveField(13)
  String permanentLabour;
  @HiveField(14)
  String otherLabour;
  @HiveField(28)
  double casualTotal;
  @HiveField(29)
  double permanentTotal;
  @HiveField(18)
  String overhead;

  @HiveField(15)
  String fuelCost;
  @HiveField(16)
  List<Map<String, String>> fuelExtras;

  @HiveField(17)
  String utilities;

  @HiveField(19)
  String annualMaintenance;
  @HiveField(20)
  String dryingBed;
  @HiveField(21)
  String sparePart;

  @HiveField(23)
  List<Map<String, String>> maintenanceExtras;

  @HiveField(24)
  String otherExpenses;
  @HiveField(25)
  List<Map<String, String>> otherExtras;

  @HiveField(26)
  double procurementTotal;
  @HiveField(27)
  double transportTotal;

  @HiveField(30)
  double fuelTotal;
  @HiveField(31)
  double maintenanceTotal;
  @HiveField(32)
  double otherTotal;

  @HiveField(33)
  double jutBagTotal;

  @HiveField(34)
  double variableCostTotal;
  @HiveField(35)
  final String sellingType;
}
