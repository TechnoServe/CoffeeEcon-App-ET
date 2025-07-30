import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/utils/decimal_input_formater.dart';
import 'package:get/get.dart';

/// A customizable text field widget that follows the app's design system.
/// This widget provides consistent styling and validation across the application
/// with support for different input types, validation, and styling options.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField] with the specified parameters.
  /// 
  /// [controller] - Text editing controller for managing input
  /// [label] - Optional label text above the field (supports i18n)
  /// [subLabel] - Optional sub-label text next to the main label
  /// [backgroundColor] - Background color of the text field
  /// [hintText] - Placeholder text inside the field (supports i18n)
  /// [hintStyle] - Custom style for hint text
  /// [keyboardType] - Type of keyboard to show (text, number, email, etc.)
  /// [obscureText] - Whether to hide the input text (for passwords)
  /// [suffixIcon] - Optional icon to display at the end of the field
  /// [textAlign] - Alignment of the input text
  /// [textStyle] - Custom style for the input text
  /// [borderBottomOnly] - Whether to show only bottom border (underline style)
  /// [useDarkTextField] - Whether to use dark theme colors
  /// [borderColor] - Custom border color
  /// [readOnly] - Whether the field is read-only
  /// [onTap] - Callback when the field is tapped
  /// [validator] - Custom validation function
  /// [errorText] - Custom error message for validation
  /// [autovalidateMode] - When to trigger validation
  /// [isRequired] - Whether the field is required (affects validation)
  const AppTextField({
    required this.controller,
    this.autovalidateMode,
    super.key,
    this.label,
    this.subLabel,
    this.backgroundColor = Colors.transparent,
    this.hintText,
    this.hintStyle,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.borderBottomOnly = false,
    this.useDarkTextField = true,
    this.borderColor,
    this.readOnly = false,
    this.isRequired = true,
    this.onTap,
    this.errorText,
    this.validator,
  });

  /// Text editing controller for managing the input value and selection
  final TextEditingController controller;
  
  /// Optional label text displayed above the text field
  final String? label;
  
  /// Optional sub-label text displayed next to the main label
  final String? subLabel;

  /// Background color of the text field
  final Color backgroundColor;
  
  /// Placeholder text displayed when the field is empty
  final String? hintText;
  
  /// Custom style for the hint text
  final TextStyle? hintStyle;
  
  /// Type of keyboard to display (text, number, email, etc.)
  final TextInputType keyboardType;
  
  /// Whether to hide the input text (used for password fields)
  final bool obscureText;
  
  /// Optional widget to display at the end of the text field
  final Widget? suffixIcon;
  
  /// Alignment of the input text within the field
  final TextAlign textAlign;
  
  /// Custom style for the input text
  final TextStyle? textStyle;
  
  /// Whether to show only the bottom border (underline style)
  final bool borderBottomOnly;
  
  /// Custom border color (overrides default theme colors)
  final Color? borderColor;
  
  /// Whether the field is read-only (user cannot edit)
  final bool readOnly;
  
  /// Callback function when the text field is tapped
  final VoidCallback? onTap;
  
  /// Whether to use dark theme colors for text and borders
  final bool useDarkTextField;
  
  /// Custom validation function that returns error message or null
  final String? Function(String?)? validator;
  
  /// Custom error message to display when validation fails
  final String? errorText;
  
  /// When to trigger validation (on change, on submit, etc.)
  final AutovalidateMode? autovalidateMode;
  
  /// Whether the field is required (affects default validation)
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    // Resolve border color based on theme and custom settings
    final resolvedBorderColor =
        borderColor ?? AppColors.textWhite100.withOpacity(0.4);

    // Define base border style based on borderBottomOnly setting
    final baseBorder = borderBottomOnly
        ? UnderlineInputBorder(
            borderSide: BorderSide(
              color: resolvedBorderColor,
              width: 0.5,
            ),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: resolvedBorderColor,
              width: 0.5,
            ),
          );
    
    // Define error border style for validation states
    final errorBorder = borderBottomOnly
        ? UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 0.5,
            ),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 0.5,
            ),
          );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display label and sub-label if provided
        if (label != null)
          Row(
            children: [
              Text(
                // Apply internationalization to label text
                label!.tr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: useDarkTextField
                          ? AppColors.textBlack100
                          : AppColors.textWhite100,
                    ),
              ),
              if (subLabel != null) SizedBox(width: 2.w),
              if (subLabel != null)
                Text(
                  // Apply internationalization to sub-label text
                  subLabel!.tr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textBlack100,
                        fontSize: 10,
                      ),
                ),
            ],
          ),
        if (label != null) SizedBox(height: 4.h),
        
        // Main text form field with all configurations
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          // Special handling for number input to allow decimals
          keyboardType: keyboardType == TextInputType.number
              ? const TextInputType.numberWithOptions(decimal: true)
              : keyboardType,
          obscureText: obscureText,
          
          // Built-in validation logic
          validator: (value) {
            // Skip validation if field is not required
            if (!isRequired) {
              return null;
            }
            // Check for empty or whitespace-only values
            if (value == null || value.isEmpty || value.trim().isEmpty) {
              return errorText ?? 'This field should not be empty';
            }
            return null;
          },
          
          // Cursor color based on theme
          cursorColor:
              useDarkTextField ? AppColors.textBlack60 : AppColors.primary,
          textAlign: textAlign,
          
          // Text style based on theme
          style: textStyle ??
              TextStyle(
                color: useDarkTextField
                    ? AppColors.textBlack100
                    : AppColors.textWhite100,
              ),
          
          // Apply decimal formatter for number inputs
          inputFormatters: keyboardType == TextInputType.number
              ? [DecimalNumberInputFormatter()]
              : null,
          
          // Input decoration with all styling options
          decoration: InputDecoration(
            filled: !borderBottomOnly, // Only fill background if not border-bottom-only
            fillColor: backgroundColor,
            hintText: hintText?.tr, // Apply internationalization to hint
            hintStyle: hintStyle ??
                Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: useDarkTextField
                          ? AppColors.textBlack60
                          : AppColors.textWhite100.withOpacity(0.4),
                    ),
            suffixIcon: suffixIcon,
            // Responsive padding based on theme
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: useDarkTextField ? 16 : 12,
            ),
            // Border styles for different states
            enabledBorder: baseBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            focusedBorder: baseBorder,
            disabledBorder: baseBorder,
          ),
        ),
      ],
    );
  }
}
