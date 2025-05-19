import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:get/get.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});
  static final List<String> _timeRanges = [
    'Daily'.tr,
    'Weekly'.tr,
    'Monthly'.tr,
    'Yearly'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _timeRanges
          .map(
            (range) => Obx(() {
              final isSelected = controller.selectedTimeRange.value == range;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => controller.updateTimeRange(range),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 8,
                    ),
                    foregroundColor: isSelected ? Colors.white : Colors.teal,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                  child: Text(range),
                ),
              );
            }),
          )
          .toList(),
    );
  }
}
