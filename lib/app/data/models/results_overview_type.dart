import 'package:hive/hive.dart';

part 'results_overview_type.g.dart';

/// Enum representing the type of results overview for calculations.
@HiveType(typeId: 99)
enum ResultsOverviewType {
  /// Basic calculation overview.
  @HiveField(0)
  basic,

  /// Advanced calculation overview.
  @HiveField(1)
  advanced,

  /// Forecast overview.
  @HiveField(2)
  forecast,

  /// Plan overview.
  @HiveField(3)
  plan,
}
