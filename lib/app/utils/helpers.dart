import 'package:flutter/material.dart';

/// A controller that associates a label, text controller, and focus node.
class LabeledController {
  /// Creates a [LabeledController] with the given label, controller, and focus node.
  LabeledController({
    required this.label,
    required this.controller,
    required this.focusNode,
  });

  /// The label for the controller.
  String label;

  /// The text editing controller.
  final TextEditingController controller;

  /// The focus node for the input field.
  final FocusNode focusNode;

  /// Whether there is a duplicate error.
  bool hasDuplicateError = false;

  /// The error text, if any.
  String? errorText;
}

/// Converts a camelCase string to spaced words with the first letter capitalized.
String camelCaseToSpacedWords(String camelCaseStr) {
  // Insert a space before all capital letters and trim whitespace
  final spacedStr = camelCaseStr.replaceAllMapped(
    RegExp(r'(?<=[a-z])[A-Z]'),
    (match) => ' ${match.group(0)}',
  );

  // Capitalize the first letter
  return spacedStr.isNotEmpty
      ? spacedStr[0].toUpperCase() + spacedStr.substring(1)
      : spacedStr;
}
