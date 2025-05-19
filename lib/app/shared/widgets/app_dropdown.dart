import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class AppDropdown<T> extends StatefulWidget {
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

  final List<T> items;
  final String? label;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final bool useTextFieldStyle;
  final Color? borderColor;
  final Icon? dropDownIcon;
  final Color? hintTextColor;
  final bool useDarkDropDown;
  final double? height;
  final bool isForOnboarding;
  final Color backgroundColor;
  final String? errorText;
  final bool bottomBorderOnly;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  bool _isOpen = false;
  bool _showError = false;

  void _setOpen(bool open) {
    setState(() {
      _isOpen = open;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseBorderColor =
        widget.borderColor ?? AppColors.textWhite100.withOpacity(0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              widget.label!.tr,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: widget.useDarkDropDown
                        ? AppColors.textBlack100
                        : AppColors.textWhite100,
                  ),
            ),
          ),
        DropdownButtonFormField2<T>(
          value: widget.value,
          isExpanded: true,
          onMenuStateChange: _setOpen,
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: widget.useDarkDropDown
                    ? AppColors.textBlack100
                    : AppColors.textWhite100,
              ),
          decoration: InputDecoration(
            isDense: true,
            filled: widget.useTextFieldStyle,
            fillColor: widget.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintText: widget.hintText.tr,
            hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.hintTextColor ??
                      (widget.useDarkDropDown
                          ? AppColors.textBlack60
                          : AppColors.textWhite100),
                ),
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
            errorStyle: const TextStyle(height: 0, fontSize: 0),
          ),
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
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
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
        if (_showError)
          Padding(
            padding: EdgeInsets.only(
              left: 8.w,
              top: 0,
            ),
            child: Text(
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
