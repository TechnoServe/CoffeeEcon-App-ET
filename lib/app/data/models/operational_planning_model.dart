import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'operational_planning_model.g.dart';

/// Model representing an operational planning entry for a coffee site.
@HiveType(typeId: 12)
class OperationalPlanningModel extends HiveObject {
  /// Creates an [OperationalPlanningModel] entry.
  OperationalPlanningModel({
    required this.startDate,
    required this.endDate,
    required this.selectedCoffeeSellingType,
    required this.totalOperatingDays,
    required this.dateRangeFormatted,
    this.cherryPurchase,
    this.seasonalCoffee,
    this.secondPayment,
    this.lowGradeHulling,
    this.juteBagPrice,
    this.juteBagVolume,
    this.ratio,
    this.machineType,
    this.numMachines,
    this.numDisks,
    this.operatingHours,
    this.fermentationLength,
    this.fermentationWidth,
    this.fermentationDepth,
    this.fermentationHours,
    this.soakingLength,
    this.soakingWidth,
    this.soakingDepth,
    this.soakingDuration,
    this.dryingLength,
    this.dryingWidth,
    this.dryingTimeWashed,
    this.dryingTimeSunDried,
    this.selectedBagSize,
    this.pulperHourlyCapacity,
    this.dailyPulpingCapacity,
    this.pulpingDays,
    this.volumeOfFermentationTank,
    this.soakingTankVolume,
    this.naturalDailyDryingCapacity,
    this.washedDailyDryingCapacity,
    this.numberOfBagsForFullyWashed,
    this.numberOfBagsForNatural,
    this.cherryAmount,
    this.processingDaysForWashed,
    this.greenCoffeeOutput,
    this.dryParchmentVolume,
    this.numberOfWorkersForNatural,
    this.numberOfWorkersForFullyWashed,
    this.dryPodVolume,
    List<Map<String, String>>? selectedSites,
    String? savedTitle,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        selectedSites = selectedSites ?? [],
        savedTitle = savedTitle ?? '',
        updatedAt = updatedAt ?? DateTime.now();

  /// The unique identifier for the planning entry.
  @HiveField(100)
  final String id;

  /// The cherry purchase value.
  @HiveField(0)
  final String? cherryPurchase;

  /// The seasonal coffee value.
  @HiveField(1)
  final String? seasonalCoffee;

  /// The second payment value.
  @HiveField(2)
  final String? secondPayment;

  /// The low grade hulling value.
  @HiveField(3)
  final String? lowGradeHulling;

  /// The jute bag price value.
  @HiveField(4)
  final String? juteBagPrice;

  /// The jute bag volume value.
  @HiveField(5)
  final String? juteBagVolume;

  /// The ratio value.
  @HiveField(6)
  final String? ratio;

  /// The start date of the plan.
  @HiveField(7)
  final DateTime startDate;

  /// The end date of the plan.
  @HiveField(8)
  final DateTime endDate;

  /// The machine type used.
  @HiveField(9)
  final String? machineType;

  /// The number of machines used.
  @HiveField(10)
  final String? numMachines;

  /// The number of disks used.
  @HiveField(11)
  final String? numDisks;

  /// The operating hours.
  @HiveField(12)
  final String? operatingHours;

  /// The fermentation tank length.
  @HiveField(13)
  final String? fermentationLength;

  /// The fermentation tank width.
  @HiveField(14)
  final String? fermentationWidth;

  /// The fermentation tank depth.
  @HiveField(15)
  final String? fermentationDepth;

  /// The fermentation hours.
  @HiveField(16)
  final String? fermentationHours;

  /// The soaking tank length.
  @HiveField(17)
  final String? soakingLength;

  /// The soaking tank width.
  @HiveField(18)
  final String? soakingWidth;

  /// The soaking tank depth.
  @HiveField(19)
  final String? soakingDepth;

  /// The soaking duration.
  @HiveField(20)
  final String? soakingDuration;

  /// The drying bed length.
  @HiveField(22)
  final String? dryingLength;

  /// The drying bed width.
  @HiveField(23)
  final String? dryingWidth;

  /// The drying time for washed coffee.
  @HiveField(24)
  final String? dryingTimeWashed;

  /// The drying time for sun-dried coffee.
  @HiveField(25)
  final String? dryingTimeSunDried;

  /// The selected bag size.
  @HiveField(26)
  final String? selectedBagSize;

  /// The selected coffee selling type.
  @HiveField(27)
  final String selectedCoffeeSellingType;

  /// The pulper hourly capacity.
  @HiveField(28)
  final double? pulperHourlyCapacity;

  /// The daily pulping capacity.
  @HiveField(29)
  final double? dailyPulpingCapacity;

  /// The number of pulping days.
  @HiveField(30)
  final int? pulpingDays;

  /// The volume of the fermentation tank.
  @HiveField(31)
  final int? volumeOfFermentationTank;

  /// The volume of the soaking tank.
  @HiveField(32)
  final int? soakingTankVolume;

  /// The daily drying capacity for natural process.
  @HiveField(33)
  final int? naturalDailyDryingCapacity;

  /// The daily drying capacity for washed process.
  @HiveField(34)
  final int? washedDailyDryingCapacity;

  /// The number of bags for fully washed process.
  @HiveField(35)
  final int? numberOfBagsForFullyWashed;

  /// The number of bags for natural process.
  @HiveField(36)
  final int? numberOfBagsForNatural;

  /// The total number of operating days.
  @HiveField(37)
  final int totalOperatingDays;

  /// The formatted date range for the plan.
  @HiveField(38)
  final String dateRangeFormatted;

  /// The cherry amount for the plan.
  @HiveField(39)
  final double? cherryAmount;

  /// The number of processing days for washed process.
  @HiveField(40)
  final int? processingDaysForWashed;

  /// The green coffee output.
  @HiveField(41)
  final double? greenCoffeeOutput;

  /// The dry parchment volume.
  @HiveField(42)
  final double? dryParchmentVolume;

  /// The number of workers for fully washed process.
  @HiveField(43)
  final int? numberOfWorkersForFullyWashed;

  /// The number of workers for natural process.
  @HiveField(44)
  final int? numberOfWorkersForNatural;

  /// The dry pod volume.
  @HiveField(45)
  final double? dryPodVolume;

  /// The creation date of the plan.
  @HiveField(46)
  final DateTime createdAt;

  /// The last update date of the plan.
  @HiveField(47)
  final DateTime updatedAt;

  /// The list of selected sites for the plan.
  @HiveField(48)
  final List<Map<String, String>> selectedSites;

  /// The saved title for the plan.
  @HiveField(49)
  final String savedTitle;
}
