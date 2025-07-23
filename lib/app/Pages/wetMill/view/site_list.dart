import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/site_card.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_bar.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:get/get.dart';

class SiteListView extends StatelessWidget {
  SiteListView({super.key});
  final controller = Get.find<SiteController>();
  final calcController = Get.find<CalculatorController>();
  final planController = Get.put(PlanController(), tag: UniqueKey().toString());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: SharableAppBar(
          title: 'Sites',
          onBack: () => {
            Get.toNamed<void>(
              AppRoutes.MAINVIEW,
            ),
          },
          trailing: SizedBox(
            child: AppButton(
              text: 'Add Site',
              prefix: const Icon(
                Icons.add,
                color: AppColors.textWhite100,
              ),
              onPressed: () {
                {
                  Get.toNamed<void>(
                    AppRoutes.SITEREGISTRATION,
                    arguments: {'site': null},
                  );
                }
              },
              width: 116,
              verticalPadding: 8,
              height: 40,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.pageHorizontalPadding,
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Manage your coffee processing sites in one place.',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${controller.sites.length}/10 Sites',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textBlack60,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...controller.sites.map(
                    (site) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => {
                          calcController.loadCalculationsBySite(
                            siteId: site.id,
                          ),
                          planController.loadPlansBySite(
                            siteId: site.id,
                          ),
                          Get.toNamed<void>(
                            AppRoutes.SITEDETAIL,
                            arguments: {'site': site},
                          ),
                        },
                        child: SiteCard(
                          site: site,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
