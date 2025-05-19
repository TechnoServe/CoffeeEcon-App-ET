import 'package:hive/hive.dart';

part 'results_overview_type.g.dart';

@HiveType(typeId: 99)
enum ResultsOverviewType {
  @HiveField(0)
  basic,

  @HiveField(1)
  advanced,

  @HiveField(2)
  forecast,
}
