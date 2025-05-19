import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/utils/decimal_input_formater.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
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

  final TextEditingController controller;
  final String? label;
  final String? subLabel;

  final Color backgroundColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final bool borderBottomOnly;
  final Color? borderColor;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool useDarkTextField;
  final String? Function(String?)? validator;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderColor =
        borderColor ?? AppColors.textWhite100.withOpacity(0.4);

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
        if (label != null)
          Row(
            children: [
              Text(
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
                  subLabel!.tr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textBlack100,
                        fontSize: 10,
                      ),
                ),
            ],
          ),
        if (label != null) SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType == TextInputType.number
              ? const TextInputType.numberWithOptions(decimal: true)
              : keyboardType,
          obscureText: obscureText,
          validator: (value) {
            if (!isRequired) {
              return null;
            }
            if (value == null || value.isEmpty || value.trim().isEmpty) {
              return errorText ?? 'This field should not be empty';
            }
            return null;
          },
          cursorColor:
              useDarkTextField ? AppColors.textBlack60 : AppColors.primary,
          textAlign: textAlign,
          style: textStyle ??
              TextStyle(
                color: useDarkTextField
                    ? AppColors.textBlack100
                    : AppColors.textWhite100,
              ),
          inputFormatters: keyboardType == TextInputType.number
              ? [DecimalNumberInputFormatter()]
              : null,
          decoration: InputDecoration(
            filled: !borderBottomOnly,
            fillColor: backgroundColor,
            hintText: hintText?.tr,
            hintStyle: hintStyle ??
                Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: useDarkTextField
                          ? AppColors.textBlack60
                          : AppColors.textWhite100.withOpacity(0.4),
                    ),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: useDarkTextField ? 16 : 12,
            ),
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
