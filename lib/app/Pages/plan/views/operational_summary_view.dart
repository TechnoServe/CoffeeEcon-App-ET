import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/general_app_bar.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/save_cost_breakdown_sheet.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/trailing_icon_button.dart';
import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:get/get.dart';

class OperationalSummary extends StatefulWidget {
  OperationalSummary({
    required this.data,
    this.isFromTable = false,
    super.key,
  }) {
    controller = Get.put(PlanController());
  }
  final OperationalPlanningModel data;
  final bool isFromTable;
  late final PlanController controller;
  final calculatorController = Get.find<CalculatorController>();

  @override
  State<OperationalSummary> createState() => _OperationalSummaryState();
}

class _OperationalSummaryState extends State<OperationalSummary> {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFromTable) {
        widget.controller.patchOperationalPlanningData(widget.data);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GeneralAppBar(
        title: 'Operational Summary',
        showBackButton: true,
        trailing: Row(
          children: [
            const SizedBox(width: 8),
            TrailingIconButton(
              type: TrailingButtonType.icon,
              actionType: TrailingButtonActionType.action,
              svgPath: 'assets/icons/save.svg',
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
                  builder: (context) => const SaveCostBreakdownSheet(
                    type: ResultsOverviewType.plan,
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            Obx(
              () => CustomChip(
                label: widget.controller.selectedUnit.value,
                svgPath: 'assets/icons/birr.svg',
                onTap: () {},
                isCurrency: false,
                isRegion: false,
                isUnit: true,
                onUnitSelected: (unit) {
                  setState(() {
                    widget.controller.selectedUnit.value = unit ?? 'KG';
                    // widget.calculatorController.convertUnit(
                    //     to: widget.controller.selectedUnit.value,
                    //     input:
                    //         (widget.data.dailyPulpingCapacity ?? 0).toDouble());
                    // widget.calculatorController.convertUnit(
                    //     to: widget.controller.selectedUnit.value,
                    //     input: (double.twidget.controller.washedOutputValue.value ?? 0)
                    //         .toDouble());
                    // widget.calculatorController.convertUnit(
                    //     to: widget.controller.selectedUnit.value,
                    //     input:
                    //         (widget.data.dailyPulpingCapacity ?? 0).toDouble());
                  });
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      body: SummeryBody(
        data: widget.data,
      ),
    );
  }
}

class SummeryBody extends StatefulWidget {
  const SummeryBody({
    required this.data,
    super.key,
    this.initialStep = 0,
    this.totalSteps = 3,
  });

  final int initialStep;
  final int totalSteps;
  final OperationalPlanningModel data;
  @override
  State<SummeryBody> createState() => SummeryBodyState();
}

class SummeryBodyState extends State<SummeryBody>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;

  static const List<String> stepTitles = [
    'Coffee Processing Goal',
    'Pulping Machine',
    'Processing Setup',
  ];
  final controller = Get.find<PlanController>();
  final calculatorController = Get.find<CalculatorController>();

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
  }

  void _goNext() {
    if (currentStep < widget.totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _goBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // --- UI Implementation for Operational Summary ---
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    if (!Get.isRegistered<CalculatorController>()) {
      Get.put(CalculatorController(), tag: UniqueKey().toString());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Overview
          const SizedBox(height: 16),
          Text(
            'Total Overview'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF23262F),
            ),
          ),
          const SizedBox(height: 16),
          // Total Processing Days Card
          SummaryInfoCard(
            iconPath: 'assets/icons/calendar2.svg',
            label: 'Total Processing Days',
            value: '${widget.data.totalOperatingDays.toStringAsFixed(0)} Days',
            iconColor: const Color(0xFF00B3B0),
            rightContent: Text(
              widget.data.dateRangeFormatted,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF8C9199),
              ),
            ),
            iconSize: 20,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF23262F),
            ),
            valueStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF23262F),
            ),
          ),
      

          // Washed Process Summary
          if (controller.selectedCoffeesellingType.value != 'Dried pod/Jenfel' && controller.sunDriedPercent.value != 1.0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Text(
                  'Washed Process Summary'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF23262F),
                  ),
                ),
                const SizedBox(height: 16),
              
                // Pulping Machine Capacity / Day Card
                Obx(
                  () => SummaryInfoCard(
                    iconPath: 'assets/icons/drying.svg',
                    label: 'Pulping Machine Capacity / Day',
                    // showAlert: true,
                    onValidationTap: () {
                      showBestPracticeModal(
                        context,
                        'Ensure that the daily cherry purchase volume does not exceed the daily pulping capacity.',
                      );
                    },
                    value:
                        '${calculatorController.convertUnit(to: controller.selectedUnit.value, input: (widget.data.dailyPulpingCapacity ?? 0).toDouble()).toStringAsFixed(2)} ${controller.selectedUnit.value.tr}',
                    iconSize: 20,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF23262F),
                    ),
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ),

            
        
                    _SummaryGridCard(
                      icon: 'assets/icons/fermentation.svg',
                      label: 'Fermentation Tank Per Batch',
                      value:
                          '${widget.data.ferTanksPerBatch?.toString()}',
                    ),
               const SizedBox(height: 16,),

                     _SummaryGridCard(
                      icon: 'assets/icons/fermentation.svg',
                      label: 'Total Batch Needed For Fermentation',
                      value:
                          '${widget.data.ferCycleTotal?.toString()}',
                    ),
                    
               
               const SizedBox(height: 16,),
                 _SummaryGridCard(
                      icon: 'assets/icons/fermentation.svg',
                      label: 'Fermentation Capacity Per Cycle (kg)',
                      value:
                        '${calculatorController.convertUnit(to: controller.selectedUnit.value, input: (widget.data.totalFerCapacityPerCycle ?? 0).toDouble()).toStringAsFixed(2)} ${controller.selectedUnit.value.tr}',

                    ),
                    const SizedBox(height: 16,),

                       
               _SummaryGridCard(
                      icon: 'assets/icons/soaking.svg',
                      label: 'Soaking Cycle Per Batch',
                      value: '${widget.data.soakCyclesPerBatch?.toString()}',
                      onValidationTap: () {
                        // showBestPracticeModal(context);
                      },
                    ),
               const SizedBox(height: 16,),

                     _SummaryGridCard(
                      icon: 'assets/icons/soaking.svg',
                      label: 'Soaking Cycle Total',
                      value:
                          '${widget.data.soakingCycleTotal?.toString()}',
                    ),
                     
               
               const SizedBox(height: 16,),

                _SummaryGridCard(
                      icon: 'assets/icons/soaking.svg',
                      label: 'Soaking Capacity Per Cycle (kg)',
                      value:
                        '${calculatorController.convertUnit(to: controller.selectedUnit.value, input: (widget.data.soakingPulpCapacity ?? 0).toDouble()).toStringAsFixed(2)} ${controller.selectedUnit.value.tr}',
                
                    ),
                 
                const SizedBox(
                  height: 16,
                ),
       
                _SummaryGridCard(
                  icon: 'assets/icons/drying.svg',
                  label: 'Drying Beds Per Batch',
                  value: '${widget.data.washedDailyDryingCapacity?.toString()}',
                  showAlert: true,
                  onValidationTap: () {
                    showBestPracticeModal(
                      context,
                      'To minimize the number of drying beds required, align your soaking schedule with the availability of empty drying beds.',
                    );
                  },
                ),
                const SizedBox(height: 16),

                                _SummaryGridCard(
                  icon: 'assets/icons/drying.svg',
                  label: 'Drying Beds Total',
                  value: '${widget.data.totalWashedDryingBeds?.toString()}',
                  showAlert: true,
                  onValidationTap: () {
                    showBestPracticeModal(
                      context,
                      'To minimize the number of drying beds required, align your soaking schedule with the availability of empty drying beds.',
                    );
                  },
               ),
       
               const SizedBox(height: 16,),

                Obx(
                  () => _SummaryGridCard(
                    icon: 'assets/icons/coffee-beans.svg',
                    label: 'Green Coffee Output',
                    value:
                        '${calculatorController.convertUnit(to: controller.selectedUnit.value, input: double.tryParse(controller.washedOutputValue.value) ?? 0).toStringAsFixed(2)} ${controller.selectedUnit.value.tr}',
                    valueBold: true,
                    isDropdown: true,
                    dropdownItems: ['Green Coffee', 'Parchment'],
                    onDropdownChanged: (val) {
                      if (val !=
                          controller.selectedOutPutValueForWashed.value) {
                        controller
                            .updateOutPutValueForWashed(val ?? 'Parchment');
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // GridView.count(
                //   crossAxisCount: 2,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   crossAxisSpacing: 12,
                //   mainAxisSpacing: 12,
                //   childAspectRatio: 2.3,
                //   children: [
                    // Green Coffee Output

                    _SummaryGridCard(
                      icon: 'assets/icons/labour.svg',
                      label: 'Labor Per Batch',
                      value:
                          '${widget.data.laborPerBatch?.toString()}',
                    ),
                const SizedBox(height: 16),

                _SummaryGridCard(
                      icon: 'assets/icons/labour.svg',
                      label: 'Total Batches Needed',
                      value:
                          '${widget.data.batches?.toString()}',
                    ),
                //   ],
                // ),
               const SizedBox(height: 16,),

                    Obx(
                      () => _SummaryGridCard(
                        icon: 'assets/icons/bag.svg',
                        label: 'Bags Needed',
                        // value:
                        //     '${widget.data.numberOfBagsForFullyWashed?.toString()}',
                        value: controller.selectedOutPutValueForWashed.value ==
                                'Parchment'
                            ? '${controller.parchmentBags}'
                            : '${widget.data.numberOfBagsForFullyWashed?.toString()}',
                      ),
                    ),
              ],
            ),

          const SizedBox(height: 24),
          if (controller.selectedCoffeesellingType.value != 'Parchment' &&  controller.fullyWashedPercent.value != 1.0)

            // Natural Process Summary
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Natural Process Summary'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF23262F),
                  ),
                ),
                const SizedBox(height: 16),
            
                Obx(
                  () => _SummaryGridCard(
                    icon: 'assets/icons/coffee-beans.svg',
                    label: 'Dried Pod Output',
                    value:
                        '${calculatorController.convertUnit(to: controller.selectedUnit.value, input: double.tryParse(controller.naturalOutputValue.value) ?? 0).toStringAsFixed(2)} ${controller.selectedUnit.value.tr}',
                    valueBold: true,
                    isDropdown: true,
                    dropdownItems: ['Dried Pod', 'Green Bean'],
                    onDropdownChanged: (val) {
                      if (val !=
                          controller.selectedOutPutValueForNatural.value) {
                        controller
                            .updateOutPutValueForNatural(val ?? 'Green Bean');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
            
                _SummaryGridCard(
                  icon: 'assets/icons/drying.svg',
                  label: 'Drying Beds Per Batch',
                  // showAlert: true,
                  onValidationTap: () {
                    showBestPracticeModal(
                      context,
                      'To minimize the number of drying beds required, align your soaking schedule with the availability of empty drying beds.',
                    );
                  },
                  value:
                      '${widget.data.naturalDailyDryingCapacity?.toString()}',
                ),
                const SizedBox(height: 16),

                  _SummaryGridCard(
                  icon: 'assets/icons/drying.svg',
                  label: 'Drying Beds Total',
                  // showAlert: true,
                  onValidationTap: () {
                    showBestPracticeModal(
                      context,
                      'To minimize the number of drying beds required, align your soaking schedule with the availability of empty drying beds.',
                    );
                  },
                  value:
                      '${widget.data.totalNatDryingBeds?.toString()}',
                ),
                  // ]),
               const SizedBox(height: 16,),

  
                    _SummaryGridCard(
                      icon: 'assets/icons/labour.svg',
                      label: 'Labor Per Batch',
                      value:
                          '${widget.data.laborPerBatch?.toString()}',
                    ),
                const SizedBox(height: 16),

                        _SummaryGridCard(
                      icon: 'assets/icons/labour.svg',
                      label: 'Total Batches Needed',
                      value:
                          '${widget.data.batches?.toString()}',
                    ),
                const SizedBox(height: 16),
        

                Obx(
                      () => _SummaryGridCard(
                        icon: 'assets/icons/bag2.svg',
                        label: 'Bags Needed',
                        value: controller.selectedOutPutValueForNatural.value ==
                                'Green Bean'
                            ? '${controller.greenBeanBags}'
                            : '${widget.data.numberOfBagsForNatural?.toString()}',
                      ),
                    ),
              ],
            ),
          const SizedBox(height: 24),
          // New Plan Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Delete existing PlanController
                // Safely delete if exists
                if (Get.isRegistered<PlanController>()) {
                  Get.delete<PlanController>(force: true);
                }

                // Put new instance
                Get.put<PlanController>(
                  PlanController(initialStep: 0),
                  permanent: false,
                );
                // Navigate to MainView
                Get.off<void>(() => MainView(initialIndex: 3));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'New Plan'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset(
                    'assets/icons/calendar2.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SummaryInfoCard extends StatefulWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color? iconColor;
  final Widget? rightContent;
  final double iconSize;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showAlert;
  final VoidCallback? onValidationTap;

  const SummaryInfoCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    this.iconColor,
    this.rightContent,
    this.iconSize = 20,
    this.labelStyle,
    this.valueStyle,
    this.margin,
    this.padding,
    this.showAlert = false,
    this.onValidationTap,
  });

  @override
  State<SummaryInfoCard> createState() => _SummaryInfoCardState();
}

class _SummaryInfoCardState extends State<SummaryInfoCard> {
  @override
  Widget build(BuildContext context) => Container(
        padding: widget.padding ?? const EdgeInsets.all(16),
        margin: widget.margin ?? const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.iconPath,
                  width: widget.iconSize,
                  height: widget.iconSize,
                  colorFilter: widget.iconColor != null
                      ? ColorFilter.mode(widget.iconColor!, BlendMode.srcIn)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label.tr,
                        style: widget.labelStyle ??
                            const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF717680),
                            ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                if (widget.showAlert && widget.onValidationTap != null) ...[
                  const SizedBox(width: 12),
                  Center(
                    child: GestureDetector(
                      onTap: widget.onValidationTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6E0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFEDF89)),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/alert.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFDB022),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (widget.rightContent != null) widget.rightContent!,
              ],
            ),
            Text(
              widget.value,
              style: widget.valueStyle ??
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ],
        ),
      );
}

// Helper widget for grid cards
class _SummaryGridCard extends StatefulWidget {
  final String? icon;
  final String label;
  final String value;
  final bool valueBold;
  final VoidCallback? onValidationTap;
  final bool showAlert;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onDropdownChanged;
  const _SummaryGridCard({
     this.icon,
    required this.label,
    required this.value,
    this.valueBold = false,
    this.onValidationTap,
    this.showAlert = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.onDropdownChanged,
  });

  @override
  State<_SummaryGridCard> createState() => _SummaryGridCardState();
}

class _SummaryGridCardState extends State<_SummaryGridCard> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.isDropdown &&
        widget.dropdownItems != null &&
        widget.dropdownItems!.isNotEmpty) {
      selectedValue = widget.dropdownItems!.first;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.icon != null) SvgPicture.asset(widget.icon!, width: 24, height: 24),
            if(widget.icon != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isDropdown
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 140),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedValue,
                            isDense: true,
                            items: widget.dropdownItems
                                ?.map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xFF8C9199),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });
                              if (widget.onDropdownChanged != null) {
                                widget.onDropdownChanged!(newValue);
                              }
                            },
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: Color(0xFF8C9199),
                            ),
                          ),
                        )
                      : Text(
                          widget.label.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF8C9199),
                          ),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    widget.value,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight:
                          widget.valueBold ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 14,
                      color: widget.valueBold
                          ? const Color(0xFF23262F)
                          : const Color(0xFF23262F),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showAlert && widget.onValidationTap != null) ...[
              const SizedBox(width: 12),
              Center(
                child: GestureDetector(
                  onTap: widget.onValidationTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFEDF89)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/icons/alert.svg',
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFDB022),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}

Future<T?> showBestPracticeModal<T>(BuildContext context, String message) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Row(
              //   children: [
              //     Container(
              //       width: 32,
              //       height: 32,
              //       decoration: BoxDecoration(
              //         color: const Color(0xFFFFF6E0),
              //         borderRadius: BorderRadius.circular(8),
              //         border: Border.all(color: const Color(0xFFFEDF89)),
              //       ),
              //       padding: const EdgeInsets.all(6),
              //       child: SvgPicture.asset(
              //         'assets/icons/alert.svg',
              //         width: 12,
              //         height: 12,
              //         colorFilter: const ColorFilter.mode(
              //           Color(0xFFFDB022),
              //           BlendMode.srcIn,
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     Text(
              //       title,
              //       style: Theme.of(context)
              //           .textTheme
              //           .titleMedium
              //           ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 24),
              // Text(
              //   message,
              //   textAlign: TextAlign.justify,
              //   style:
              //       const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              // ),
              // const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hint: '.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFF252B37),
                        ),
                      ),
                      TextSpan(
                        text: message.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF717680),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            
            ],
          ),
        ),
      ),
    );
