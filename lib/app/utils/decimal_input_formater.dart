import 'package:flutter/services.dart';

/// A [TextInputFormatter] that allows only valid decimal numbers as input.
/// This formatter ensures that users can only enter valid decimal numbers
/// by filtering out invalid characters and enforcing decimal number rules.
class DecimalNumberInputFormatter extends TextInputFormatter {
  /// Formats the input to allow only valid decimal numbers.
  /// This method is called whenever the text input changes and validates
  /// the input according to decimal number rules.
  /// 
  /// [oldValue] - The previous text input value
  /// [newValue] - The new text input value to validate
  /// Returns the validated text value or the old value if invalid
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;

    // Disallow ',' or any character that is not a digit or '.'
    // This prevents users from entering letters, special characters, or commas
    if (text.contains(',') || RegExp(r'[^0-9.]').hasMatch(text)) {
      return oldValue; // Return old value to prevent invalid input
    }

    // Prevent '.' as the first character
    // Decimal numbers should not start with a decimal point
    if (text.startsWith('.')) {
      return oldValue; // Return old value to prevent invalid input
    }

    // Allow only one '.' (decimal point)
    // This ensures only one decimal point is allowed in the number
    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue; // Return old value to prevent multiple decimal points
    }

    // If all validations pass, return the new value
    return newValue;
  }
}
