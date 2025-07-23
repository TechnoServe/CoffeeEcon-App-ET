import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/converter/widgets/shared_bottom_sheet.dart';
import 'package:flutter_template/app/Pages/converter/widgets/tab_button.dart';
import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/icon_holder.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/operational_card.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/plan_table.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/site_card.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_bar.dart';
import 'package:flutter_template/app/shared/widgets/app_title.dart';
import 'package:get/get.dart';

import '../widgets/calc_history_table.dart';

class SiteDetailView extends StatelessWidget {
  const SiteDetailView({required this.site, super.key});

  final SiteInfo site;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SiteController>();
    final calcController = Get.find<CalculatorController>();
    final planController = Get.find<PlanController>();

    return Scaffold(
      appBar: SharableAppBar(
        title: 'Site Detail',
        trailing: Obx(
          () => controller.selectedTab.value == 0
              ? Row(
                  children: [
                    IconHolder(
                      svgAsset: AppAssets.calculatorIcon,
                      iconColor: AppColors.themeBlue,
                      onTap: () => {
                        calcController.sites.value = [site],
                        calcController.selectedSite = [
                          {
                            'siteId': site.id,
                            'siteName': site.siteName,
                          }
                        ],
                        Get.to<void>(
                          () => MainView(
                            initialIndex: 1,
                          ),
                        ),
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    IconHolder(
                      svgAsset: AppAssets.editIcon,
                      onTap: () => {
                        Get.toNamed<void>(
                          AppRoutes.SITEREGISTRATION,
                          arguments: {'site': site},
                        ),
                      },
                      iconColor: AppColors.themeBlue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    IconHolder(
                      svgAsset: AppAssets.deleteSvgIcon,
                      backgroundColor: AppColors.error20,
                      iconColor: AppColors.error70,
                      onTap: () async {
                        showModalBottomSheet<void>(
                          context: context,
                          isDismissible: true,
                          transitionAnimationController: AnimationController(
                            duration: const Duration(milliseconds: 500),
                            reverseDuration: const Duration(milliseconds: 500),
                            vsync: Navigator.of(context),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          isScrollControlled: true,
                          builder: (_) => SharedBottomSheet(
                            title: 'Delete Site'.tr,
                            isTitleCenterd: false,
                            subTitle:
                                'Are you sure you want to delete this site'.tr,
                            onCancel: () => {
                              Navigator.pop(context),
                            },
                            onConfirm: () async {
                              await controller.deleteSite(site.id);
                              Get.toNamed<void>(
                                AppRoutes.SITELIST,
                              );
                            },
                            confirmText: 'Delete'.tr,
                            image: SizedBox(
                              width: 64,
                              height: 64,
                              child: Image.asset(AppAssets.deleteIcon),
                            ),
                          ),
                        );
                        await Future<void>.delayed(
                          const Duration(milliseconds: 600),
                        );

                        // Get.toNamed<void>(AppRoutes.SITELIST);
                      },
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.pageHorizontalPadding,
          vertical: 24,
        ),
        child: Column(
          children: [
            Obx(() {
              final selected = controller.selectedTab.value;
              return Row(
                children: [
                  Expanded(
                    child: TabButton(
                      label: 'Site Detail',
                      isSelected: selected == 0,
                      onTap: () async {
                        controller.tab = 0;
                      },
                      expand: true,
                      textStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: selected == 0
                                    ? AppColors.textWhite100
                                    : AppColors.textBlack100,
                              ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TabButton(
                      label: 'Calculation History',
                      padding: EdgeInsets.all(0),
                      isSelected: selected == 1,
                      onTap: () async {
                        controller.tab = 1;
                      },
                      expand: true,
                      textStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: selected == 1
                                    ? AppColors.textWhite100
                                    : AppColors.textBlack100,
                              ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TabButton(
                      label: 'Plans',
                      isSelected: selected == 2,
                      onTap: () async {
                        controller.tab = 2;
                      },
                      expand: true,
                      textStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: selected == 2
                                    ? AppColors.textWhite100
                                    : AppColors.textBlack100,
                              ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  final selected = controller.selectedTab.value;
                  return IndexedStack(
                    index: selected,
                    children: [
                      // CoffeeView(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SiteCard(site: site),
                          const SizedBox(
                            height: 24,
                          ),
                          const AppTitle(titleName: 'Operational Details'),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.processIcon,
                                    backgroundColor: Color(0xff7A5310),
                                  ),
                                  unit: 'Daily Capacity',
                                  value:
                                      '${site.processingCapacity}  ${"kg".tr}',
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.storageIcon,
                                    backgroundColor: Color(0xff009688),
                                  ),
                                  unit: 'Storage Count',
                                  value: '${site.storageSpace} m\u00B2',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.dryingBedIcon,
                                    backgroundColor: Color(0xffD32F2F),
                                  ),
                                  unit: 'Drying beds',
                                  value: '${site.dryingBeds}  ${"units".tr}',
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.fermentationIcon,
                                    backgroundColor: Color(0xffFF9800),
                                  ),
                                  unit: 'Fermentation',
                                  value:
                                      '${site.fermentationTanks} ${"Tanks".tr}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.pulpingIcon,
                                    backgroundColor: Color(0xff673AB7),
                                  ),
                                  unit: 'Pulping Capacity',
                                  value: '${site.pulpingCapacity} ${"kg".tr}',
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.managerIcon,
                                    backgroundColor: Color(0xff4B5563),
                                  ),
                                  unit: 'Managers',
                                  value: '${site.workers}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.farmerIcon,
                                    backgroundColor: Color(0xff4CAF50),
                                  ),
                                  unit: 'Farmers',
                                  value: '${site.farmers}',
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: OperationCard(
                                  iconData: const IconHolder(
                                    svgAsset: AppAssets.farmerIcon,
                                    backgroundColor: Color(0xff03A9F4),
                                  ),
                                  unit: 'Total Workers',
                                  value: '${site.workers} / ${"Annually".tr}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CalculationHistoryTable(
                        siteCalculationHistory:
                            calcController.siteCalculationHistory,
                      ),
                      PlanTable(
                        planData: planController.sitePlans,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
