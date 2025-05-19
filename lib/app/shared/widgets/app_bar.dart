import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class SharableAppBar extends StatelessWidget implements PreferredSizeWidget {
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

  final String? title;
  final VoidCallback? onBack;
  final bool hideBackIcon;
  final String? backText;
  final Color backgroundColor;
  final double elevation;
  final Widget? trailing;
  final bool isLandScape;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: backgroundColor,
        elevation: elevation,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
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
            if (title != null) ...[
              if (!hideBackIcon) const SizedBox(width: 12),
              Text(title!.tr, style: Theme.of(context).textTheme.titleSmall),
            ],
          ],
        ),
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
