import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/Pages/converter/widgets/conveter_field.dart';
import 'package:flutter_template/app/Pages/converter/widgets/result_container.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:get/get.dart';

/// Coffee conversion interface view.
/// This widget provides the UI for converting between different coffee grades
/// and units, with real-time conversion and history tracking.
class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the required controllers for coffee conversion
    final controller = Get.find<ConverterController>();
    final historyController = Get.find<HistoryController>();

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            // FROM field for input coffee grade and unit
            ConverterField(
              textFieldController: controller.fromRatioController,
              label: 'FROM'.tr, // Apply internationalization
              selectedUnitIndex: controller.selectedFromUnitIndex,
              onUnitSelected: (index) {
                controller.updateSelectedOutputUnit(index);
                final oldIndex = controller.selectedFromUnitIndex.value;

                // Only update if the unit actually changed
                if (oldIndex != index) {
                  // Convert the value when unit changes
                  controller.unitConverterOnUnitChange(
                    oldUnitIndex: oldIndex,
                    newUnitIndex: index,
                    controller: controller.fromRatioController,
                  );
                  // Update the selected unit index
                  controller.selectedFromUnitIndex.value = index;
                }
              },
              selectedItem: controller.fromCoffeeGrade,
              onItemSelected: (value) =>
                  controller.fromCoffeeGrade.value = value,
              dropdownItems: DropdownData.coffeeGrades,
              isUnitConverstion: false, // This is coffee conversion, not unit conversion
            ),
            const SizedBox(
              height: 16, // Spacing between FROM and TO fields
            ),
            // TO field for output coffee grade and unit
            ConverterField(
              textFieldController: controller.toRatioController,
              label: 'TO'.tr, // Apply internationalization
              selectedUnitIndex: controller.selectedToUnitIndex,
              onUnitSelected: (index) {
                controller.updateSelectedOutputUnit(index);

                final oldIndex = controller.selectedToUnitIndex.value;

                // Only update if the unit actually changed
                if (oldIndex != index) {
                  // Convert the value when unit changes
                  controller.unitConverterOnUnitChange(
                    oldUnitIndex: oldIndex,
                    newUnitIndex: index,
                    controller: controller.toRatioController,
                  );
                  // Update the selected unit index
                  controller.selectedToUnitIndex.value = index;
                }
              },
              selectedItem: controller.toCoffeeGrade,
              onItemSelected: (value) => controller.toCoffeeGrade.value = value,
              dropdownItems: DropdownData.coffeeGrades,
              isUnitConverstion: false, // This is coffee conversion, not unit conversion
            ),
            // Results section with scrollable history
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24, // Top spacing for results section
                    ),
                    // Results header with clear all functionality
                    Container(
                      padding: const EdgeInsets.only(
                        right: 8,
                        top: 8,
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Results'.tr, // Apply internationalization
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 14),
                            ),
                            // Show clear all button only if there's history
                            if (historyController.coffeeHistory.isNotEmpty)
                              GestureDetector(
                                onTap: () => {
                                  historyController.clearHistory(
                                    isFromUnitConversion: false,
                                  ),
                                },
                                child: Text(
                                  'Clear All'.tr, // Apply internationalization
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.error,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8, // Spacing after header
                    ),
                    // Scrollable list of conversion history
                    Obx(() {
                      final historyList = historyController.coffeeHistory;

                      return Column(
                        children: List.generate(
                          historyList.length,
                          (index) => Column(
                            children: [
                              const SizedBox(height: 8),
                              // Display each conversion result
                              ResultContainer(
                                calculationHistory: historyList[index],
                              ),
                              const SizedBox(height: 8),
                              // Add divider between results (except for last item)
                              if (index < historyList.length - 1)
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
