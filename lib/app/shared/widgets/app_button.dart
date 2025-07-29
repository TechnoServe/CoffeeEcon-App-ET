import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
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

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor;

  final double verticalPadding;
  final double borderRadius;
  final double? width;
  final double height;
  final Widget? prefix; // Define the optional prefix widget
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width?.w,
        height: height.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefix != null) ...[
                prefix!, // Display the prefix if provided
                const SizedBox(width: 8), // Space between prefix and text
              ],
              Text(
                text.tr,
                style: textStyle ??  Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,    
              ),
            ],
          ),
        ),
      );
}
