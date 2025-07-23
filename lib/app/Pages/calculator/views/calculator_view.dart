import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/general_app_bar.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/tab/advanced_tab.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/tab/basic_tab.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/trailing_icon_button.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/upload_calculation_bottom_sheet.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

class CalculatorView extends GetView<CalculatorController> {
  CalculatorView({
    super.key,
    this.basicCalcData,
    this.advancedCalcData,
    this.type = ResultsOverviewType.basic,
  });
  final BasicCalculationEntryModel? basicCalcData;
  final AdvancedCalculationModel? advancedCalcData;

  ResultsOverviewType type;

  @override
  Widget build(BuildContext context) {
    Get.put(CalculatorController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GeneralAppBar(
        title: 'Calculator'.tr,
        showBackButton: false,
        trailing: Row(
          children: [
            TrailingIconButton(
              type: TrailingButtonType.icon,
              actionType: TrailingButtonActionType.action,
              svgPath: 'assets/icons/upload.svg',
              iconColor: Colors.black,
              size: 48,
              backgroundColor: AppColors.background,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const UploadCalculationBottomSheet(),
                );
              },
            ),
            const SizedBox(width: 8),
            TrailingIconButton(
              type: TrailingButtonType.icon,
              actionType: TrailingButtonActionType.action,
              svgPath: 'assets/icons/save.svg',
              iconColor: Colors.black,
              size: 48,
              backgroundColor: AppColors.background,
              onPressed: () {
                Get.toNamed<void>(
                  AppRoutes.SAVEDVIEW,
                );
              },
            ),
          ],
        ),
      ),
      body: _CalculatorBody(
        basicCalcData: basicCalcData,
        advancedCalcData: advancedCalcData,
        type: type,
      ),
    );
  }
}

// Body Widget
class _CalculatorBody extends StatefulWidget {
  _CalculatorBody({
    this.basicCalcData,
    this.advancedCalcData,
    this.type = ResultsOverviewType.basic,
  });
  final BasicCalculationEntryModel? basicCalcData;
  final AdvancedCalculationModel? advancedCalcData;

  ResultsOverviewType type;

  @override
  State<_CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<_CalculatorBody>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<CalculatorController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: controller.tabs
                  .map(
                    (tab) => Obx(() {
                      final isSelected = controller.selectedTab.value == tab;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          height: 49,
                          width: 114,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              controller.updateTab(tab);
                              controller.tabController
                                  .animateTo(controller.tabs.indexOf(tab));
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              foregroundColor: isSelected
                                  ? AppColors.textWhite100
                                  : AppColors.textBlack100,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            child: Text(
                              tab.isNotEmpty
                                  ? '${tab[0].toUpperCase()}${tab.substring(1)}'
                                      .tr
                                  : '',
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(), // disables swipe
              children: [
                BasicTab(
                  entry: widget.basicCalcData,
                ),
                AdvancedTab(
                  entry: widget.advancedCalcData,
                ),
                // ForecastTab(),
              ],
            ),
          ),
        ],
      );
}
