import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

class TagCard extends StatelessWidget {
  const TagCard({
    required this.label,
    super.key,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.expand = false,
  });

  final String label;

  final double? height;
  final EdgeInsetsGeometry padding;
  final bool expand;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            // Foreground content
            Container(
              // constraints: const BoxConstraints(minWidth: double.infinity),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.textWhite100.withOpacity(0.2),
              ),
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textWhite100,
                    ),
              ),
            ),
          ],
        ),
      );
}
