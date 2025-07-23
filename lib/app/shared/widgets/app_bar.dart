import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

/// A customizable app bar widget that can be shared across screens.
class SharableAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [SharableAppBar] with optional title, back button, and trailing widget.
  const SharableAppBar({
    super.key,
    this.title,
    this.onBack,
    this.hideBackIcon = false,
    this.backText,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.isLandScape = false,
    this.trailing,
  });

  /// The title to display in the app bar.
  final String? title;

  /// Callback when the back button is pressed.
  final VoidCallback? onBack;

  /// Whether to hide the back icon.
  final bool hideBackIcon;

  /// Optional text to display for the back button.
  final String? backText;

  /// The background color of the app bar.
  final Color backgroundColor;

  /// The elevation of the app bar.
  final double elevation;

  /// Optional trailing widget to display on the right.
  final Widget? trailing;

  /// Whether the app bar is in landscape mode.
  final bool isLandScape;

  /// The preferred size of the app bar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: backgroundColor,
        elevation: elevation,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            if (!hideBackIcon)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: IconButton(
                        onPressed:
                            onBack ?? () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          size: 20,
                          Icons.arrow_back_ios_new_rounded,
                        ),
                        color: AppColors.textBlack100,
                      ),
                    ),
                  ),
                ],
              ),
            if (title != null) ...[
              if (!hideBackIcon) const SizedBox(width: 12),
              Text(title!.tr, style: Theme.of(context).textTheme.titleSmall),
            ],
          ],
        ),
        actions: trailing != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: trailing!,
                ),
              ]
            : null,
      );
}
