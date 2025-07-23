import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'site_info_model.g.dart';

/// Model representing information about a coffee site.
@HiveType(typeId: 2)
class SiteInfo extends HiveObject {
  /// Creates a [SiteInfo] entry.
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
    String? id,
    DateTime? createdAt,
    this.deletedAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// The unique identifier for the site.
  @HiveField(0)
  final String id;

  /// The name of the site.
  @HiveField(1)
  final String siteName;

  /// The location of the site.
  @HiveField(2)
  final String location;

  /// The business model of the site.
  @HiveField(3)
  final String businessModel;

  /// The processing capacity of the site.
  @HiveField(4)
  final int processingCapacity;

  /// The storage space of the site.
  @HiveField(5)
  final int storageSpace;

  /// The number of drying beds at the site.
  @HiveField(6)
  final int dryingBeds;

  /// The number of fermentation tanks at the site.
  @HiveField(7)
  final int fermentationTanks;

  /// The pulping capacity of the site.
  @HiveField(8)
  final int pulpingCapacity;

  /// The number of workers at the site.
  @HiveField(9)
  final int workers;

  /// The number of farmers associated with the site.
  @HiveField(10)
  final int farmers;

  /// The creation date of the site entry.
  @HiveField(12)
  final DateTime createdAt;

  /// The deletion date of the site entry, if deleted.
  @HiveField(13)
  final DateTime? deletedAt;

  /// The last update date of the site entry.
  @HiveField(14)
  final DateTime updatedAt;
}
