import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

/// A customizable app bar widget that can be shared across screens.
/// This widget provides consistent navigation and styling across the application
/// with support for custom titles, back buttons, and trailing widgets.
class SharableAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [SharableAppBar] with optional title, back button, and trailing widget.
  /// 
  /// [title] - Optional title text to display (supports internationalization)
  /// [onBack] - Custom callback for back button press
  /// [hideBackIcon] - Whether to hide the back button
  /// [backText] - Optional text for the back button
  /// [backgroundColor] - Background color of the app bar
  /// [elevation] - Elevation/shadow of the app bar
  /// [isLandScape] - Whether the app bar is in landscape mode
  /// [trailing] - Optional widget to display on the right side
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

  /// The title to display in the app bar (supports internationalization)
  final String? title;

  /// Callback when the back button is pressed.
  /// If not provided, uses default navigation pop behavior
  final VoidCallback? onBack;

  /// Whether to hide the back icon.
  /// Useful for root screens or when custom navigation is needed
  final bool hideBackIcon;

  /// Optional text to display for the back button.
  /// Currently not implemented but available for future use
  final String? backText;

  /// The background color of the app bar.
  /// Defaults to white for clean appearance
  final Color backgroundColor;

  /// The elevation of the app bar.
  /// Defaults to 0 for flat design
  final double elevation;

  /// Optional trailing widget to display on the right side.
  /// Can be used for action buttons, menu icons, etc.
  final Widget? trailing;

  /// Whether the app bar is in landscape mode.
  /// Currently not used but available for responsive design
  final bool isLandScape;

  /// The preferred size of the app bar.
  /// Uses standard toolbar height for consistency
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: backgroundColor,
        elevation: elevation,
        // Disable automatic leading widget to use custom back button
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            // Custom back button with rounded background
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
            // Title text with proper spacing
            if (title != null) ...[
              if (!hideBackIcon) const SizedBox(width: 12),
              // Apply internationalization to title text
              Text(title!.tr, style: Theme.of(context).textTheme.titleSmall),
            ],
          ],
        ),
        // Trailing widget with proper padding
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
