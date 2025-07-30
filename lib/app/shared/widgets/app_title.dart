import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A simple title widget that displays text with consistent styling.
/// This widget applies internationalization to the title text and uses
/// the app's theme for consistent typography across the application.
class AppTitle extends StatelessWidget {
  /// Creates an [AppTitle] with the specified title text.
  /// 
  /// [titleName] - The title text to display (supports internationalization)
  const AppTitle({required this.titleName, super.key});
  
  /// The title text that supports internationalization via GetX
  final String titleName;

  @override
  Widget build(BuildContext context) => Text(
        // Apply internationalization to the title text
        titleName.tr,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
      );
}
