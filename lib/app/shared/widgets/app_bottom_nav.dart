import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// A custom bottom navigation bar widget that provides navigation between main app sections.
/// This widget displays navigation items with custom styling including selected indicators,
/// icons, and labels with internationalization support.
class AppBottomNav extends StatelessWidget {
  /// Creates an [AppBottomNav] with the specified navigation state and callbacks.
  /// 
  /// [selectedIndex] - The currently selected navigation item index
  /// [onTap] - Callback function when a navigation item is tapped
  const AppBottomNav({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });
  
  /// The currently selected navigation item index
  final int selectedIndex;
  
  /// Callback function triggered when a navigation item is tapped
  /// Receives the tapped item index as parameter
  final void Function(int) onTap;

  /// Builds a custom bottom navigation bar item with custom styling.
  /// Each item includes a selection indicator, icon, and label.
  /// 
  /// [index] - The index of this navigation item
  /// [iconPath] - Path to the SVG icon asset
  /// [label] - The label text for this item (supports internationalization)
  BottomNavigationBarItem _buildItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    // Determine if this item is currently selected
    final bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection indicator dot above the icon
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            // SVG icon with color based on selection state
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
            // Label text with styling based on selection state
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
      label: '', // Empty label since we're using custom layout
    );
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed, // Fixed type for consistent layout
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textBlack60,
        items: [
          // Home navigation item
          _buildItem(
            index: 0,
            iconPath: AppAssets.homeIcon,
            label: 'home'.tr, // Apply internationalization
          ),
          // Calculator navigation item
          _buildItem(
            index: 1,
            iconPath: AppAssets.calculatorIcon,
            label: 'calculator'.tr, // Apply internationalization
          ),
          // Convert navigation item
          _buildItem(
            index: 2,
            iconPath: AppAssets.convertIcon,
            label: 'convert'.tr, // Apply internationalization
          ),
          // Plan navigation item
          _buildItem(
            index: 3,
            iconPath: AppAssets.planIcon,
            label: 'plan'.tr, // Apply internationalization
          ),
          // Forecast navigation item
          _buildItem(
            index: 4,
            iconPath: AppAssets.stokcIcon,
            label: 'Forecast'.tr, // Apply internationalization
          ),
        ],
      );
}
