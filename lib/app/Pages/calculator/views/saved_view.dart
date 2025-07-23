import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/general_app_bar.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/saved_slidable_tile.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Replace with your actual GeneralAppBar import
// import 'package:your_app/widgets/general_app_bar.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final controller = Get.find<CalculatorController>();

  Future<void> _clearAll() async {
    await controller.deleteAllSavedCalculation();
  }

  Future<void> _deleteItem(String id, int index) async {
    await controller.deleteSavedCalculation(id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: GeneralAppBar(
          title: 'Saved'.tr,
          showBackButton: true,
          trailing: TextButton(
            onPressed: _clearAll,
            child: Text(
              'Clear All'.tr,
              style: const TextStyle(
                color: AppColors.grey60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Review your past price estimates and cost breakdowns. Easily access, edit, or compare previous calculations.'
                    .tr,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Expanded(
                child: ListView.separated(
                  itemCount: controller.savedCalculations.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.savedCalculations[index];
                    return SavedSlidableTile(
                      title: item.title.tr,
                      sites: item.selectedSites,
                      amount: '${item.breakEvenPrice?.toStringAsFixed(2)} Birr',
                      date: DateFormat('MMM d, yyyy').format(item.createdAt),
                      onDelete: () async {
                        await _deleteItem(
                          item.id,
                          index,
                        );
                      },
                      onTap: () {
                        controller.loadSites();
                        controller.selectedSite = item.selectedSites;

                        Get.toNamed<void>(
                          AppRoutes.RESULTSOVERVIEWVIEW,
                          arguments: {
                            'type': ResultsOverviewTypeExtension.fromString(
                              item.type.name,
                            ),
                            'basicCalcData': item.basicCalculation,
                            'advancedCalcData': item.advancedCalculation,
                            'breakEvenPrice': item.breakEvenPrice,
                            'isBestPractice': item.isBestPractice,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
