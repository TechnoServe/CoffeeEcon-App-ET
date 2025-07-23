import 'package:hive/hive.dart';

part 'calculation_history_model.g.dart';

/// Model representing a calculation history entry for conversions or calculations.
@HiveType(typeId: 1)
class CalculationHistory extends HiveObject {
  /// Creates a [CalculationHistory] entry.
  CalculationHistory({
    required this.fromStage,
    required this.toStage,
    required this.inputAmount,
    required this.resultAmount,
    required this.timestamp,
    required this.isFromUnitConversion,
  });

  /// The stage from which the calculation started.
  @HiveField(0)
  final String fromStage;

  /// The stage to which the calculation was made.
  @HiveField(1)
  final String toStage;

  /// The input amount for the calculation.
  @HiveField(2)
  final String inputAmount;

  /// The result amount after calculation.
  @HiveField(3)
  final String resultAmount;

  /// The timestamp of the calculation.
  @HiveField(4)
  final DateTime timestamp;

  /// Whether this entry is from a unit conversion.
  @HiveField(5)
  final bool isFromUnitConversion;
}
