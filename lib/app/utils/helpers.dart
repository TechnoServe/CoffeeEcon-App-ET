import 'package:flutter/material.dart';

/// A controller that associates a label, text controller, and focus node.
/// This class is used to group related input field components together
/// for easier management and validation in forms.
class LabeledController {
  /// Creates a [LabeledController] with the given label, controller, and focus node.
  /// 
  /// [label] - The label text for the input field
  /// [controller] - The text editing controller for managing input
  /// [focusNode] - The focus node for managing input focus
  LabeledController({
    required this.label,
    required this.controller,
    required this.focusNode,
  });

  /// The label for the controller.
  /// This can be updated dynamically if needed.
  String label;

  /// The text editing controller for managing the input value and selection.
  final TextEditingController controller;

  /// The focus node for managing input field focus and keyboard behavior.
  final FocusNode focusNode;

  /// Whether there is a duplicate error for this field.
  /// Used for validation in forms where duplicate values are not allowed.
  bool hasDuplicateError = false;

  /// The error text to display for this field.
  /// Set to null when there are no errors.
  String? errorText;
}

/// Converts a camelCase string to spaced words with the first letter capitalized.
/// This utility function is useful for displaying camelCase identifiers
/// in a user-friendly format (e.g., "userName" becomes "User Name").
/// 
/// [camelCaseStr] - The camelCase string to convert
/// Returns a formatted string with spaces and proper capitalization
String camelCaseToSpacedWords(String camelCaseStr) {
  // Insert a space before all capital letters and trim whitespace
  // This regex matches any capital letter that follows a lowercase letter
  final spacedStr = camelCaseStr.replaceAllMapped(
    RegExp(r'(?<=[a-z])[A-Z]'),
    (match) => ' ${match.group(0)}',
  );

  // Capitalize the first letter to ensure proper title case
  return spacedStr.isNotEmpty
      ? spacedStr[0].toUpperCase() + spacedStr.substring(1)
      : spacedStr;
}
