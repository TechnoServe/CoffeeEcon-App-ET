import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/bindings.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/Pages/converter/view/coffee_ui.dart';
import 'package:flutter_template/app/Pages/converter/view/unit_ui.dart';
import 'package:flutter_template/app/Pages/converter/widgets/tab_button.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:get/get.dart';

class ConverterView extends GetView<ConverterController> {
  const ConverterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional safety check
    if (!Get.isRegistered<ConverterController>()) {
      ConverterBindings().dependencies();
    }
    if (!Get.isRegistered<HistoryController>()) {
      ConverterBindings().dependencies();
    }

    final controller = Get.find<ConverterController>();

    final historyController = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fixed white background
        elevation: 0, // Remove shadow
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'convert'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.pageHorizontalPadding,
        ),
        child: Column(
          children: [
            Obx(() {
              final selected = controller.selectedTab.value;
              return Row(
                children: [
                  Expanded(
                    child: TabButton(
                      label: 'coffee'.tr,
                      isSelected: selected == 0,
                      onTap: () async {
                        controller.saveLastHistory(isFromUnitConversion: true);

                        controller.clearControllers();

                        await historyController.loadHistory(
                          isFromUnitConversion: false,
                        );
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
                      label: 'units'.tr,
                      isSelected: selected == 1,
                      onTap: () async {
                        controller.saveLastHistory(isFromUnitConversion: false);

                        controller.clearControllers();
                        await historyController.loadHistory(
                          isFromUnitConversion: true,
                        );
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
                ],
              );
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                child: Obx(() {
                  final selected = controller.selectedTab.value;
                  return IndexedStack(
                    index: selected,
                    children: const [
                      CoffeeView(),
                      UnitView(),
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
