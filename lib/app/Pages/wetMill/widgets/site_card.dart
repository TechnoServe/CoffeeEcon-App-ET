import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/tag.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    required this.site,
    this.isForDashobard = false,
    super.key,
  });
  final SiteInfo site;
  final bool isForDashobard;
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage(AppAssets.coffeeBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isForDashobard)
                Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite100.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.factoryIcon,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.siteName,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.textWhite100,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${"Created on".tr}: ${DateFormat('d, MMM, yyyy').format(site.createdAt)}',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.textWhite100.withOpacity(
                                      0.6,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (isForDashobard)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite100.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.factoryIcon,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.siteName,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.textWhite100,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${"Created on".tr}: ${DateFormat('d, MMM, yyyy').format(site.createdAt)}',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.textWhite100.withOpacity(
                                      0.6,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (!isForDashobard) const SizedBox(height: 16),
              if (!isForDashobard)
                Row(
                  children: [
                    Expanded(
                      child: TagCard(
                        label: '📍 ${site.location.tr}',
                      ),
                    ),
                    const SizedBox(width: 4),
                    TagCard(
                      label: '🏭 ${site.businessModel.tr}',
                    ),
                    const SizedBox(width: 4),
                    TagCard(
                      label: '👷🏽‍♂️ ${site.workers} ${'workers'.tr}',
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
}
