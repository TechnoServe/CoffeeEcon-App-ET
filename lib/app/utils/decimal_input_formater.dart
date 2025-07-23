import 'package:flutter/services.dart';

/// A [TextInputFormatter] that allows only valid decimal numbers as input.
class DecimalNumberInputFormatter extends TextInputFormatter {
  /// Formats the input to allow only valid decimal numbers.
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;

    // Disallow ',' or any character that is not a digit or '.'
    if (text.contains(',') || RegExp(r'[^0-9.]').hasMatch(text)) {
      return oldValue;
    }

    // Prevent '.' as the first character
    if (text.startsWith('.')) {
      return oldValue;
    }

    // Allow only one '.'
    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }

    return newValue;
  }
}
