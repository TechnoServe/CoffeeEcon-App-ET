import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

/// A custom number keyboard widget that provides a numeric input interface.
/// This widget displays a grid of number buttons (0-9), decimal point, and clear button.
/// It's designed to be used as a bottom sheet or modal for numeric input.
class AppNumberKeyboard extends StatelessWidget {
  /// Creates an [AppNumberKeyboard] with the specified callbacks.
  /// 
  /// [onNumberTap] - Callback function when a number or decimal is tapped
  /// [onClear] - Callback function when the clear button is tapped
  const AppNumberKeyboard({
    required this.onNumberTap,
    required this.onClear,
    super.key,
  });

  /// Callback function triggered when a number or decimal point is tapped
  /// Receives the tapped character as a string parameter
  final void Function(String) onNumberTap;
  
  /// Callback function triggered when the clear button is tapped
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          // Rounded top corners for bottom sheet appearance
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            // Subtle shadow for elevation effect
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.04), // #0000000A
              offset: const Offset(0, -1),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Wrap(
          children: [
            // Divider with handle for bottom sheet drag indicator
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.stroke100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            // Keyboard content with grid layout
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                // Disable scrolling since this is a fixed keyboard
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12, // 9 numbers + decimal + zero + clear
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns for number layout
                  mainAxisSpacing: 12, // Vertical spacing between rows
                  crossAxisSpacing: 12, // Horizontal spacing between columns
                  childAspectRatio: 2, // Width to height ratio for buttons
                ),
                itemBuilder: (_, index) {
                  // Special handling for different button types based on index
                  if (index == 9) {
                    // Decimal point button
                    return _KeyButton(
                      label: '.',
                      onTap: () => onNumberTap('.'),
                    );
                  }
                  if (index == 10) {
                    // Zero button
                    return _KeyButton(
                      label: '0',
                      onTap: () => onNumberTap('0'),
                    );
                  }
                  if (index == 11) {
                    // Clear button with erase icon
                    return _KeyButton(
                      label: 'X',
                      onTap: onClear,
                      isClose: true,
                    );
                  }
                  // Number buttons 1-9
                  return _KeyButton(
                    label: '${index + 1}',
                    onTap: () => onNumberTap('${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

/// Private widget for individual keyboard buttons.
/// Handles the styling and behavior of each key in the number keyboard.
class _KeyButton extends StatelessWidget {
  /// Creates a [_KeyButton] with the specified parameters.
  /// 
  /// [label] - The text or icon to display on the button
  /// [onTap] - Callback function when the button is tapped
  /// [isClose] - Whether this button should show an erase icon instead of text
  const _KeyButton({
    required this.label,
    required this.onTap,
    this.isClose = false,
  });
  
  /// The label to display on the button (text or icon identifier)
  final String label;
  
  /// Whether this button should display an erase icon
  final bool isClose;
  
  /// Callback function triggered when the button is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.background60,
          // Rounded corners for modern button appearance
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isClose
            ? SvgPicture.asset(
                // Display erase icon for clear button
                AppAssets.ersase,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconBlack80,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                // Display text label for number and decimal buttons
                label,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
      );
}
