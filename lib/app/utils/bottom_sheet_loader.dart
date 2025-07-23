import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/widgets/shared_bottom_sheet.dart';
import 'package:get/get.dart';

/// Helper utilities for showing custom bottom sheets.
class Helpers {
  /// Shows a custom bottom sheet with the given parameters.
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
    final controller = showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
        vsync: Navigator.of(context),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => SharedBottomSheet(
        showDivider: buttonText != null,
        key: key,
        title: title.tr,
        subTitle: subTitle.tr,
        cancelText: buttonText?.tr ?? '',
        onCancel: onButtonPressed,
        isCenteredSubtitle: isCenteredSubtitle,
        image: SizedBox(
          width: 64,
          height: 64,
          child: Image.asset(imagePath),
        ),
      ),
    );

    if (autoDismiss) {
      Future.delayed(dismissDuration, () {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true); // auto close after delay
      });
    }

    return await controller;
  }
}
