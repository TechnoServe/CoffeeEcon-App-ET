/// Provides constants and ranges for calculation fields and unit conversions.
class CalcuationConstants {
  /// Field ranges for cost calculations.
  static final fieldRanges = <String, FieldRange>{
    'seasonalPrice':
        const FieldRange(80, 85, 'Cherry purchase should be 80–85%'),
    'cherryTransport':
        const FieldRange(3, 5, 'Transport & commission should be 3–5%'),
    'laborFullTime': const FieldRange(2, 3, 'Full-time labor should be 2–3%'),
    'laborCasual': const FieldRange(3, 5, 'Casual labor should be 3–5%'),
    'fuelAndOils':
        const FieldRange(0, 1, 'Fuels & oils should be less than 1%'),
    'repairsAndMaintenance':
        const FieldRange(1, 2, 'Repairs & maintenance should be 1–2%'),
    'otherExpenses': const FieldRange(4, 6, 'Other expenses should be 4–6%'),
  };

  /// Conversion factors for different coffee types.
  static final Map<String, double> conversionFactors = {
    'Cherries': 1,
    'Parchment': 0.2,
    'Green Coffee': 0.16,
    'Dried pod/Jenfel': 0.2,
  };

  /// Mapping of units to their kilogram equivalents.\
  /// eg. 1 quintal is 100 kg, 1 metric ton is 1000 kg.
  static const Map<String, double> unitToKg = {
    'Grams': 0.001,
    'Kilograms': 1.0,
    'Feresula': 17.0,
    'Quintal': 100.0,
    'Qt': 100.0,
    'Pound': 0.45359237,
    'Metric Ton': 1000.0, // Added metric ton (1 ton = 1000 kg)
    "Mt": 1000.0, // Added metric ton (1 ton = 1000 kg)
  };
}

/// Represents a numeric range and a message for a calculation field.
class FieldRange {
  /// Creates a [FieldRange] with [min], [max], and [message].
  const FieldRange(this.min, this.max, this.message);

  /// The minimum value of the range.
  final double min;

  /// The maximum value of the range.
  final double max;

  /// The message describing the range.
  final String message;

  /// Returns true if [value] is within the range.
  bool isInRange(double value) => value >= min && value <= max;
}
