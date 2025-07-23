import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:get/get.dart';

// if isCurrency and isRegion is false modal will be unit
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.onUnitSelected,
    this.onCurrencySelected,
    super.key,
    this.subtitle,
    this.chipLabel,
    this.chipSvgPath,
    this.onChipTap,
    this.isCurrency = false,
    this.isRegion = false,
    this.isUnit = false,
    this.showChip = true,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String? subtitle;
  final String? chipLabel;
  final String? chipSvgPath;
  final VoidCallback? onChipTap;
  final bool isCurrency;
  final bool isRegion;
  final bool isUnit;
  final bool showChip;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final String? Function(String?)? onUnitSelected;
  final String? Function(String?)? onCurrencySelected;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Expanded(
            child: SizedBox(
              width: 297,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr,
                    style: titleStyle ??
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!.tr,
                      style: subtitleStyle ??
                          const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // const Spacer(),
          if (showChip && chipLabel != null && chipSvgPath != null)
            CustomChip(
              label: chipLabel!,
              svgPath: chipSvgPath!,
              onTap: onChipTap ?? () {},
              isCurrency: isCurrency,
              isRegion: isRegion,
              isUnit: isUnit,
              onUnitSelected: onUnitSelected,
              onCurrencySelected: onCurrencySelected,
            ),
        ],
      );
}
