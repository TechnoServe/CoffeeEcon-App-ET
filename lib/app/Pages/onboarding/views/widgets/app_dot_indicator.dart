import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

class AppDotIndicator extends StatelessWidget {
  const AppDotIndicator({
    required this.itemCount,
    required this.currentIndex,
    super.key,
    this.activeColor = AppColors.themeCyan,
    this.inactiveColor = const Color(0xFFBDBDBD),
    this.activeWidth = 16.0,
    this.dotSize = 8.0,
    this.spacing = 4.0,
  });
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double activeWidth;
  final double dotSize;
  final double spacing;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (i) {
          final isActive = i == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: isActive ? activeWidth : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          );
        }),
      );
}
