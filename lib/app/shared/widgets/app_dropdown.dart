import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

/// A customizable dropdown widget that follows the app's design system.
/// This widget provides consistent styling and behavior for selection inputs
/// with support for validation, custom styling, and internationalization.
class AppDropdown<T> extends StatefulWidget {
  /// Creates an [AppDropdown] with the specified parameters.
  /// 
  /// [items] - List of items to display in the dropdown
  /// [value] - Currently selected value
  /// [onChanged] - Callback when selection changes
  /// [label] - Optional label text above the dropdown
  /// [hintText] - Placeholder text when no item is selected
  /// [useTextFieldStyle] - Whether to use text field styling
  /// [borderColor] - Custom border color
  /// [dropDownIcon] - Custom dropdown arrow icon
  /// [hintTextColor] - Color for hint text
  /// [useDarkDropDown] - Whether to use dark theme colors
  /// [isForOnboarding] - Special styling for onboarding screens
  /// [backgroundColor] - Background color of the dropdown
  /// [height] - Custom height for the dropdown
  /// [errorText] - Custom error message for validation
  /// [bottomBorderOnly] - Whether to show only bottom border
  const AppDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
    this.hintText = 'Select option',
    this.useTextFieldStyle = false,
    this.borderColor,
    this.dropDownIcon,
    this.hintTextColor,
    this.useDarkDropDown = false,
    this.isForOnboarding = false,
    this.backgroundColor = Colors.transparent,
    this.height,
    this.errorText,
    this.bottomBorderOnly = false,
  });

  /// List of items to display in the dropdown
  final List<T> items;
  
  /// Optional label text displayed above the dropdown
  final String? label;
  
  /// Currently selected value
  final T? value;
  
  /// Callback function when selection changes
  final ValueChanged<T?> onChanged;
  
  /// Placeholder text displayed when no item is selected
  final String hintText;
  
  /// Whether to use text field styling (filled background)
  final bool useTextFieldStyle;
  
  /// Custom border color (overrides default theme colors)
  final Color? borderColor;
  
  /// Custom dropdown arrow icon
  final Icon? dropDownIcon;
  
  /// Color for hint text
  final Color? hintTextColor;
  
  /// Whether to use dark theme colors for text and borders
  final bool useDarkDropDown;
  
  /// Custom height for the dropdown
  final double? height;
  
  /// Special styling flag for onboarding screens
  final bool isForOnboarding;
  
  /// Background color of the dropdown
  final Color backgroundColor;
  
  /// Custom error message for validation
  final String? errorText;
  
  /// Whether to show only bottom border (underline style)
  final bool bottomBorderOnly;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

/// State class for the [AppDropdown] widget.
/// Manages the open/close state and validation display.
class _AppDropdownState<T> extends State<AppDropdown<T>> {
  /// Whether the dropdown menu is currently open
  bool _isOpen = false;
  
  /// Whether to show validation error
  bool _showError = false;

  /// Updates the open state of the dropdown
  void _setOpen(bool open) {
    setState(() {
      _isOpen = open;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Resolve border color based on theme and custom settings
    final baseBorderColor =
        widget.borderColor ?? AppColors.textWhite100.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display label if provided
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              // Apply internationalization to label text
              widget.label!.tr,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: widget.useDarkDropDown
                        ? AppColors.textBlack100
                        : AppColors.textWhite100,
                  ),
            ),
          ),
        
        // Main dropdown button with all configurations
        DropdownButtonFormField2<T>(
          value: widget.value,
          isExpanded: true,
          onMenuStateChange: _setOpen,
          
          // Built-in validation logic
          validator: (value) {
            if (value == null) {
              setState(() {
                _showError = true;
              });
              return '';
            } else {
              setState(() {
                _showError = false;
              });
              return null;
            }
          },
          onChanged: widget.onChanged,
          
          // Text style based on theme
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: widget.useDarkDropDown
                    ? AppColors.textBlack100
                    : AppColors.textWhite100,
              ),
          
          // Input decoration with all styling options
          decoration: InputDecoration(
            isDense: true,
            filled: widget.useTextFieldStyle,
            fillColor: widget.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintText: widget.hintText.tr, // Apply internationalization
            hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.hintTextColor ??
                      (widget.useDarkDropDown
                          ? AppColors.textBlack60
                          : AppColors.textWhite100),
                ),
            // Border styles for different states
            enabledBorder: widget.bottomBorderOnly
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: baseBorderColor, width: 0.5),
                  ),
            focusedBorder: widget.bottomBorderOnly
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 0.5),
                  ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 0.5,
              ),
            ),
            focusedErrorBorder: widget.bottomBorderOnly
                ? null
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 0.5,
                    ),
                  ),
            errorStyle: const TextStyle(height: 0, fontSize: 0), // Hide default error
          ),
          
          // Custom button layout with selected value and arrow
          customButton: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  widget.useDarkDropDown || widget.height != null ? 0 : 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    // Apply internationalization to selected value
                    widget.value?.toString().tr ?? '',
                    style: widget.value != null
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.hintTextColor != null &&
                                      !widget.isForOnboarding
                                  ? widget.hintTextColor
                                  : widget.isForOnboarding
                                      ? AppColors.textWhite100
                                      : AppColors.textBlack100,
                            )
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.hintTextColor ??
                                  AppColors.textBlack100,
                              fontSize: 12,
                            ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
                // Custom dropdown arrow or default arrow
                widget.dropDownIcon ??
                    Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textBlack100,
                      size: 18,
                    ),
              ],
            ),
          ),
          
          // Dropdown menu styling
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: widget.useDarkDropDown
                  ? AppColors.background60
                  : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            elevation: 4,
          ),
          
          // Dropdown items with internationalization
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      // Apply internationalization to item text
                      item.toString().tr,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textBlack100,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        
        // Error message display
        if (_showError)
          Padding(
            padding: EdgeInsets.only(
              left: 8.w,
              top: 0,
            ),
            child: Text(
              // Apply internationalization to error text
              widget.errorText?.tr ?? 'This field should not be empty',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
            ),
          ),
      ],
    );
  }
}
