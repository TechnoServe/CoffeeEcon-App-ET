import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/widgets/shared_bottom_sheet.dart';
import 'package:get/get.dart';

/// Helper utilities for showing custom bottom sheets.
/// This class provides a convenient way to display consistent bottom sheets
/// across the application with customizable content and behavior.
class Helpers {
  /// Shows a custom bottom sheet with the given parameters.
  /// This method creates a modal bottom sheet with consistent styling and
  /// supports auto-dismiss functionality for temporary notifications.
  /// 
  /// [context] - The build context for showing the bottom sheet
  /// [title] - The main title text (supports internationalization)
  /// [subTitle] - The subtitle text (supports internationalization)
  /// [imagePath] - Path to the image asset to display
  /// [buttonText] - Optional text for the action button
  /// [onButtonPressed] - Callback when the button is pressed
  /// [isCenteredSubtitle] - Whether to center the subtitle text
  /// [autoDismiss] - Whether to automatically dismiss after a delay
  /// [dismissDuration] - Duration before auto-dismiss (if enabled)
  /// [key] - Optional key for the bottom sheet widget
  Future<void> showBottomSheet(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String imagePath,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool isCenteredSubtitle = false,
    bool autoDismiss = false,
    Duration dismissDuration = const Duration(seconds: 2),
    Key? key,
  }) async {
    // Create and show the modal bottom sheet with custom styling
    final controller = showModalBottomSheet<void>(
      context: context,
      isDismissible: true, // Allow dismissal by tapping outside
      // Custom animation controller for smooth transitions
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
        vsync: Navigator.of(context),
      ),
      // Rounded top corners for modern appearance
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      isScrollControlled: true, // Allow content to determine height
      builder: (_) => SharedBottomSheet(
        showDivider: buttonText != null, // Show divider if button is present
        key: key,
        title: title.tr, // Apply internationalization to title
        subTitle: subTitle.tr, // Apply internationalization to subtitle
        cancelText: buttonText?.tr ?? '', // Apply internationalization to button text
        onCancel: onButtonPressed,
        isCenteredSubtitle: isCenteredSubtitle,
        // Display the provided image with fixed dimensions
        image: SizedBox(
          width: 64,
          height: 64,
          child: Image.asset(imagePath),
        ),
      ),
    );

    // Auto-dismiss functionality for temporary notifications
    if (autoDismiss) {
      Future.delayed(dismissDuration, () {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true); // auto close after delay
      });
    }

    return await controller;
  }
}
