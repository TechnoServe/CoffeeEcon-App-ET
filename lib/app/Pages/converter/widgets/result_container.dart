import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/calculation_history_model.dart';
import 'package:get/get.dart';

class ResultContainer extends StatelessWidget {
  const ResultContainer({
    required this.calculationHistory,
    super.key,
  });
  final CalculationHistory calculationHistory;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  calculationHistory.fromStage.tr,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      // First part (before space) - untranslated
                      TextSpan(
                        text: calculationHistory.inputAmount.split(' ').first +
                            ' ',
                      ),
                      // Second part (after space) - translated (.tr)
                      TextSpan(
                        text: calculationHistory.inputAmount
                            .split(' ')
                            .skip(1)
                            .join(' ')
                            .tr,
                      ),
                    ],
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            AppAssets.arrowRightRound,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.iconBlack80,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  calculationHistory.toStage.tr,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      // First part (before space) - not translated
                      TextSpan(
                        text:
                            '${calculationHistory.resultAmount.split(' ').first} ',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              color: AppColors.themeCyan,
                            ),
                      ),
                      // Second part (after space) - translated with .tr
                      TextSpan(
                        text: calculationHistory.resultAmount
                            .split(' ')
                            .skip(1)
                            .join(' ')
                            .tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              color: AppColors.themeCyan,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
