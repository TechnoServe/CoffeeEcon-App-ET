import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.textStyle,
    super.key,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.expand = false,
    this.borderRadius,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool expand;
  final TextStyle? textStyle;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          constraints:
              expand ? const BoxConstraints(minWidth: double.infinity) : null,
          padding: padding,
          height: height ?? 49.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.secondary,
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
          alignment: Alignment.center,
          child: Text(label.tr, textAlign: TextAlign.center, style: textStyle),
        ),
      );
}
