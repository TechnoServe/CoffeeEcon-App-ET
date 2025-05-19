class CalcuationConstants {
  //intialize the range for the 7 cost list
  static final fieldRanges = <String, FieldRange>{
    'seasonalPrice':
        const FieldRange(80, 85, 'Cherry purchase should be 80–85%'),
    'cherryTransport':
        const FieldRange(3, 5, 'Transport & commission should be 3–5%'),
    'laborFullTime': const FieldRange(2, 3, 'Full-time labor should be 2–3%'),
    'laborCasual': const FieldRange(3, 5, 'Casual labor should be 3–5%'),
    'repairsAndMaintenance':
        const FieldRange(1, 2, 'Repairs & maintenance should be 1–2%'),
    'fuelAndOils':
        const FieldRange(0, 1, 'Fuels & oils should be less than 1%'),
    'otherExpenses': const FieldRange(4, 6, 'Other expenses should be 4–6%'),
  };
  static final Map<String, double> conversionFactors = {
    'Parchment': 0.55,
    'Green Coffee': 0.39,
    'Dried pod/Jenfel': 0.12,
  };
}

class FieldRange {
  const FieldRange(this.min, this.max, this.message);
  final double min;
  final double max;
  final String message;

  bool isInRange(double value) => value >= min && value <= max;
}
