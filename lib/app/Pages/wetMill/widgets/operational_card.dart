import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class OperationCard extends StatelessWidget {
  const OperationCard({
    required this.iconData,
    required this.unit,
    required this.value,
    super.key,
  });
  final Widget iconData;
  final String unit;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.grey20,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            iconData,
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.tr,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.grey80),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.grey90),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
