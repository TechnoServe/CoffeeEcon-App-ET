import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';

class SharedBottomSheet extends StatelessWidget {
  const SharedBottomSheet({
    required this.title,
    required this.subTitle,
    this.isCenteredSubtitle = false,
    super.key,
    this.onCancel,
    this.onConfirm,
    this.image,
    this.showDivider = true,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isTitleCenterd = true,
  });

  final String title;
  final String subTitle;
  final bool isCenteredSubtitle;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? image;
  final bool showDivider;
  final String confirmText;
  final String cancelText;
  final bool isTitleCenterd;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: showDivider ? 16 : 32,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDivider)
              // Divider
              Center(
                child: Container(
                  width: 60,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.stroke100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

            if (image != null) ...[
              Center(child: image!),
              const SizedBox(height: 24),
            ],

            Text(
              title,
              textAlign: isTitleCenterd ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 16,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              subTitle,
              textAlign:
                  isCenteredSubtitle ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textBlack60,
                    fontWeight: FontWeight.w400,
                  ),
            ),

            if (onCancel != null || onConfirm != null) SizedBox(height: 24.h),

            // Action buttons
            Row(
              children: [
                if (onCancel != null)
                  Expanded(
                    child: AppButton(
                      text: cancelText,
                      width: 0,
                      backgroundColor: AppColors.secondary,
                      textColor: AppColors.grey100,
                      onPressed: onCancel!,
                    ),
                  ),
                if (onCancel != null && onConfirm != null)
                  SizedBox(width: 16.w),
                if (onConfirm != null)
                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      width: 0,
                      backgroundColor: AppColors.error,
                      textColor: AppColors.textWhite100,
                      onPressed: onConfirm!,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
}
