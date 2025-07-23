import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:get/get.dart';

class SaveCostBreakdownSheet extends StatefulWidget {
  const SaveCostBreakdownSheet({
    required this.type,
    this.totalSellingPrice,
    this.isBestPractice,
    this.basicCalcData,
    this.advancedCalcData,
    this.breakEvenPrice,
    this.cherryPrice,
    super.key,
  });
  final ResultsOverviewType type;
  final BasicCalculationEntryModel? basicCalcData;
  final AdvancedCalculationModel? advancedCalcData;

  final double? breakEvenPrice;
  final double? cherryPrice;
  final double? totalSellingPrice;
  final bool? isBestPractice;

  @override
  State<SaveCostBreakdownSheet> createState() => _SaveCostBreakdownSheetState();
}

class _SaveCostBreakdownSheetState extends State<SaveCostBreakdownSheet> {
  final controller = Get.find<CalculatorController>();
  final planController = Get.find<PlanController>();

  @override
  void initState() {
    super.initState();
    if (controller.sites.isEmpty) controller.loadSites();
  }

  final TextEditingController titleController = TextEditingController();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  final GlobalKey _dropdownKey = GlobalKey();
  bool showTitleError = false;
  void _showDropdown() {
    // Use the key to get the correct RenderBox and position
    final RenderBox box =
        _dropdownKey.currentContext!.findRenderObject()! as RenderBox;
    // final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final Offset offset = box.localToGlobal(Offset.zero);
    setState(() {
      _dropdownOverlay = OverlayEntry(
        builder: (context) => Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _hideDropdown,
                behavior: HitTestBehavior.translucent,
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 56),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background60,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: controller.sites.map((site) {
                          final isSelected = controller.selectedSite
                              .any((s) => s['siteId'] == site.id);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                final exists = controller.selectedSite
                                    .any((s) => s['siteId'] == site.id);
                                if (exists) {
                                  controller.selectedSite.removeWhere(
                                    (s) => s['siteId'] == site.id,
                                  );
                                } else {
                                  controller.selectedSite.add({
                                    'siteId': site.id,
                                    'siteName': site.siteName,
                                  });
                                }
                              });
                              _dropdownOverlay?.markNeedsBuild();
                            },
                            child: Container(
                              width: 88.w,
                              height: 34.h,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                // border: Border.all(
                                //   color: isSelected
                                //       ? const Color(0xFF11696D)
                                //       : const Color(0xFFE6E8EC),
                                //   width: 1.5,
                                // ),
                              ),
                              child: Text(
                                site.siteName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.textWhite100
                                      : AppColors.textBlack100,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_dropdownOverlay!);
    });
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  void dispose() {
    titleController.dispose();
    _hideDropdown();
    controller.sites = <SiteInfo>[].obs;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Save Cost Breakdown'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Custom Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Assign to'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
                key: _dropdownKey,
                onTap: () {
                  if (_dropdownOverlay == null) {
                    _showDropdown();
                  } else {
                    _hideDropdown();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: controller.selectedSite.isEmpty ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE6E8EC)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (controller.selectedSite.isEmpty)
                        Text(
                          'Select Site'.tr,
                          style: TextStyle(
                            color: Color(0xFFB0B7C3),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        )
                      else ...[
                        ...controller.selectedSite.take(2).map(
                              (e) => Container(
                                width: 88.w,
                                height: 34.h,
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    e['siteName'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        if (controller.selectedSite.length > 2)
                          Text(
                            '+${controller.selectedSite.length - 2} more',
                            style: const TextStyle(
                              color: AppColors.textBlack60,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                      ],
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/arrow-down.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFB0B7C3),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            LabeledTextField(
                label: 'Save as',
                hintText: 'Enter title',
                controller: titleController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (titleController.text.isEmpty) {
                    setState(() => showTitleError = true);
                  } else {
                    setState(() => showTitleError = false);
                  }
                }),
            const SizedBox(
              height: 8,
            ),
            if (showTitleError)
              Text(
                "Title shouln't be empty".tr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.error70,
                    ),
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        _hideDropdown();
                        // Handle save logic here
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FB),
                        side: const BorderSide(color: Color(0xFFF8F9FB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.isBlank) {
                          setState(() => showTitleError = true);
                        } else {
                          if (widget.type == ResultsOverviewType.plan) {
                            planController.savePlan(
                              selectedSites: controller.selectedSite,
                              planName: titleController.text,
                            );
                          } else {
                            print({
                              '********************************* save called *****************************',
                              widget.breakEvenPrice,
                            });
                            controller.saveCalculation(
                              basicCalcData: widget.basicCalcData,
                              advancedCalcData: widget.advancedCalcData,
                              breakEvenPrice: widget.breakEvenPrice,
                              totalSellingPrice: widget.totalSellingPrice!,
                              title: titleController.text,
                              selectedSites: controller.selectedSite,
                              type: widget.type,
                              isBestPractice: widget.isBestPractice!,
                            );
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF11696D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(
                        'Save'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension TextEditingControllerExtensions on TextEditingController {
  bool get isBlank => text.trim().isEmpty;
  bool get isNotBlank => !isBlank;
}
