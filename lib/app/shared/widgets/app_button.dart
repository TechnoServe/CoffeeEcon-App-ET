import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:get/get.dart';

/// A customizable button widget that follows the app's design system.
/// This widget provides consistent styling and behavior across the application
/// with support for custom colors, sizes, and optional prefix icons.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton] with the specified parameters.
  /// 
  /// [text] - The button text to display (supports internationalization)
  /// [onPressed] - Callback function when the button is pressed
  /// [prefix] - Optional widget to display before the text (e.g., icons)
  /// [backgroundColor] - Background color of the button (defaults to primary)
  /// [textColor] - Color of the button text (defaults to white)
  /// [verticalPadding] - Vertical padding inside the button
  /// [borderRadius] - Border radius for rounded corners
  /// [width] - Width of the button (defaults to full width)
  /// [height] - Height of the button
  /// [textStyle] - Custom text style (overrides default styling)
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.prefix, // Optional prefix widget
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textWhite100,
    this.verticalPadding = AppSizes.verticalButtonPadding,
    this.borderRadius = AppSizes.buttonRadius,
    this.width = double.infinity,
    this.height = AppSizes.buttonHeight,
    this.textStyle

  });

  /// The button text that supports internationalization via GetX
  final String text;
  
  /// Callback function triggered when the button is pressed
  final VoidCallback onPressed;
  
  /// Background color of the button
  final Color backgroundColor;
  
  /// Text color of the button
  final Color? textColor;

  /// Vertical padding inside the button for proper spacing
  final double verticalPadding;
  
  /// Border radius for rounded corners
  final double borderRadius;
  
  /// Width of the button (defaults to full width)
  final double? width;
  
  /// Height of the button
  final double height;
  
  /// Optional widget to display before the text (e.g., icons, images)
  final Widget? prefix;
  
  /// Custom text style that overrides the default button text styling
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => SizedBox(
        // Use responsive sizing for width and height
        width: width?.w,
        height: height.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            // Apply responsive vertical padding
            padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
            shape: RoundedRectangleBorder(
              // Apply responsive border radius
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Conditionally show prefix widget if provided
              if (prefix != null) ...[
                prefix!, // Display the prefix if provided
                const SizedBox(width: 8), // Space between prefix and text
              ],
              Text(
                // Apply internationalization to button text
                text.tr,
                style: textStyle ??  Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                // Handle text overflow gracefully
                overflow: TextOverflow.ellipsis,    
              ),
            ],
          ),
        ),
      );
}
