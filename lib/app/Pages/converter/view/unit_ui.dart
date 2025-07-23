import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/Pages/converter/widgets/conveter_field.dart';
import 'package:flutter_template/app/Pages/converter/widgets/result_container.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:get/get.dart';

class UnitView extends StatelessWidget {
  const UnitView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConverterController>();
    final historyController = Get.find<HistoryController>();

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              ConverterField(
                textFieldController: controller.fromUnitController,
                selectedItem: controller.fromUnit,
                onItemSelected: (val) => controller.fromUnit.value = val,
                dropdownItems: DropdownData.units,
                showUnits: false,
                isUnitConverstion: true,
              ),
              const SizedBox(height: 16),
              ConverterField(
                textFieldController: controller.toUnitController,
                selectedItem: controller.toUnit,
                onItemSelected: (val) => controller.toUnit.value = val,
                dropdownItems: DropdownData.units,
                showUnits: false,
                isUnitConverstion: true,
              ),
              const SizedBox(
                height: 24,
              ),
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
                        'Results'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 14),
                      ),
                      if (historyController.unitHistory.isNotEmpty)
                        GestureDetector(
                          onTap: () => {
                            historyController.clearHistory(
                              isFromUnitConversion: true,
                            ),
                          },
                          child: Text(
                            'Clear All'.tr,
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
                height: 8,
              ),
              Obx(() {
                final historyList = historyController.unitHistory;

                return Column(
                  children: List.generate(
                    historyList.length,
                    (index) => Column(
                      children: [
                        const SizedBox(height: 8),
                        ResultContainer(
                          calculationHistory: historyList[index],
                        ),
                        const SizedBox(height: 8),
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
    );
  }
}
