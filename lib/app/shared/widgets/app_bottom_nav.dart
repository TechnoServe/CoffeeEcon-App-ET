import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });
  final int selectedIndex;
  final void Function(int) onTap;

  BottomNavigationBarItem _buildItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.textBlack60,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isSelected ? 12 : 10,
                color: isSelected ? AppColors.primary : AppColors.textBlack60,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textBlack60,
        items: [
          _buildItem(
            index: 0,
            iconPath: AppAssets.homeIcon,
            label: 'home'.tr,
          ),
          _buildItem(
            index: 1,
            iconPath: AppAssets.calculatorIcon,
            label: 'calculator'.tr,
          ),
          _buildItem(
            index: 2,
            iconPath: AppAssets.convertIcon,
            label: 'convert'.tr,
          ),
          _buildItem(
            index: 3,
            iconPath: AppAssets.planIcon,
            label: 'plan'.tr,
          ),
          _buildItem(
            index: 4,
            iconPath: AppAssets.stokcIcon,
            label: 'Forecast'.tr,
          ),
        ],
      );
}
