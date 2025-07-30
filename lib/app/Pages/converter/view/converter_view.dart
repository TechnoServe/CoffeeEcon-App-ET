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

/// Main view for the converter functionality.
/// This view provides a tabbed interface for coffee conversion and unit conversion,
/// with proper controller management and history tracking.
class ConverterView extends GetView<ConverterController> {
  const ConverterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional safety check to ensure controllers are registered
    if (!Get.isRegistered<ConverterController>()) {
      ConverterBindings().dependencies();
    }
    if (!Get.isRegistered<HistoryController>()) {
      ConverterBindings().dependencies();
    }

    // Get the required controllers
    final controller = Get.find<ConverterController>();
    final historyController = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fixed white background
        elevation: 0, // Remove shadow for flat design
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'convert'.tr, // Apply internationalization
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.pageHorizontalPadding,
        ),
        child: Column(
          children: [
            // Tab selection buttons for coffee and unit conversion
            Obx(() {
              final selected = controller.selectedTab.value;
              return Row(
                children: [
                  // Coffee conversion tab
                  Expanded(
                    child: TabButton(
                      label: 'coffee'.tr, // Apply internationalization
                      isSelected: selected == 0,
                      onTap: () async {
                        // Save current history before switching tabs
                        controller.saveLastHistory(isFromUnitConversion: true);
                        // Clear form controllers for fresh input
                        controller.clearControllers();
                        // Load coffee conversion history
                        await historyController.loadHistory(
                          isFromUnitConversion: false,
                        );
                        // Switch to coffee tab
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
                    width: 8, // Spacing between tabs
                  ),
                  // Unit conversion tab
                  Expanded(
                    child: TabButton(
                      label: 'units'.tr, // Apply internationalization
                      isSelected: selected == 1,
                      onTap: () async {
                        // Save current history before switching tabs
                        controller.saveLastHistory(isFromUnitConversion: false);
                        // Clear form controllers for fresh input
                        controller.clearControllers();
                        // Load unit conversion history
                        await historyController.loadHistory(
                          isFromUnitConversion: true,
                        );
                        // Switch to unit tab
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
            // Content area with tabbed views
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24, // Top spacing for content
                ),
                child: Obx(() {
                  final selected = controller.selectedTab.value;
                  // Use IndexedStack for efficient tab switching without rebuilding
                  return IndexedStack(
                    index: selected,
                    children: const [
                      CoffeeView(), // Coffee conversion interface
                      UnitView(),   // Unit conversion interface
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
