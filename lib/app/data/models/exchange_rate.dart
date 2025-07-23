/// Model representing a currency exchange rate.
class ExchangeRate {
  /// Creates an [ExchangeRate] with the given [code], [buying], and [selling] rates.
  ExchangeRate({
    required this.code,
    required this.buying,
    required this.selling,
  });

  /// The currency code (e.g., 'USD', 'ETB').
  final String code;

  /// The buying rate for the currency.
  final double buying;

  /// The selling rate for the currency.
  final double selling;

  /// Creates an [ExchangeRate] from a JSON map.
  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> currency =
        (json['currency'] ?? {}) as Map<String, dynamic>;
    return ExchangeRate(
      code: currency['code']?.toString() ?? '',
      buying: double.tryParse(json['buying']?.toString() ?? '') ?? 0.0,
      selling: double.tryParse(json['selling']?.toString() ?? '') ?? 0.0,
    );
  }
}
