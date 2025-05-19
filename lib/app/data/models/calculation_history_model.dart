import 'package:hive/hive.dart';

part 'calculation_history_model.g.dart';

@HiveType(typeId: 1)
class CalculationHistory extends HiveObject {
  CalculationHistory({
    required this.fromStage,
    required this.toStage,
    required this.inputAmount,
    required this.resultAmount,
    required this.timestamp,
    required this.isFromUnitConversion,
  });
  @HiveField(0)
  final String fromStage;

  @HiveField(1)
  final String toStage;

  @HiveField(2)
  final String inputAmount;

  @HiveField(3)
  final double resultAmount;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final bool isFromUnitConversion;
}
