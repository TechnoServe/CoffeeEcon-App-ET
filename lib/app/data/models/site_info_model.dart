import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'site_info_model.g.dart';

@HiveType(typeId: 2)
class SiteInfo extends HiveObject {
  SiteInfo({
    required this.siteName,
    required this.location,
    required this.businessModel,
    required this.processingCapacity,
    required this.storageSpace,
    required this.dryingBeds,
    required this.fermentationTanks,
    required this.pulpingCapacity,
    required this.workers,
    required this.farmers,
    required this.waterConsumption,
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
  final String siteName;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String businessModel;

  @HiveField(4)
  final int processingCapacity;

  @HiveField(5)
  final int storageSpace;

  @HiveField(6)
  final int dryingBeds;

  @HiveField(7)
  final int fermentationTanks;

  @HiveField(8)
  final int pulpingCapacity;

  @HiveField(9)
  final int workers;

  @HiveField(10)
  final int farmers;

  @HiveField(11)
  final int waterConsumption;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime? deletedAt;

  @HiveField(14)
  final DateTime updatedAt;
}
