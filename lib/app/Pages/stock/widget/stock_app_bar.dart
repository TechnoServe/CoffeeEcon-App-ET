import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class StockAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StockAppBar({
    required this.title,
    super.key,
    this.showBackButton = false,
    this.onBack,
    this.showUnitChip = true,
  });
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showUnitChip;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            showBackButton
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
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
                              // ignore: deprecated_member_use
                              color: Colors.black,
                            ),
                            onPressed: onBack ??
                                () => Navigator.of(context).maybePop(),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              width: 8,
            ),
            Text(
              title.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
            ),
            const Spacer(),
            if (showUnitChip)
              CustomChip(
                label: 'Birr'.tr,
                svgPath: 'assets/icons/birr.svg',
                onTap: () {},
                isCurrency: true,
              ),
          ],
        ),
      );
}
