import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GeneralAppBar({
    required this.title,
    super.key,
    this.showBackButton = false,
    this.onBack,
    this.trailing,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            if (showBackButton)
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
                    icon: SvgPicture.asset(
                      'assets/icons/back_arrow.svg',
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
// ...existing code...
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            if (showBackButton) const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: !showBackButton ? 16 : 0),
                child: Text(
                  title.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
              ),
            ),
            // const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      );
}
