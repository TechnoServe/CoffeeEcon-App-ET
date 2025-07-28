import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/general_app_bar.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';

import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: GeneralAppBar(
          title: 'Operational Planning',
          showBackButton: false,
          trailing: Row(
            children: [
              const SizedBox(width: 8),
              Obx(() {
                final step = controller.currentStep.value;
                return (step == 0) // example: hide on step 1
                    ? CustomChip(
                        label: controller.selectedUnit.value,
                        svgPath: 'assets/icons/birr.svg',
                        onTap: () {},
                        isCurrency: false,
                        isRegion: false,
                        isUnit: true,
                        onUnitSelected: (unit) {
                          controller.selectedUnit.value = unit ?? 'KG';
                        },
                      )
                    : const SizedBox.shrink();
              }),
              // TrailingIconButton(
              //   type: TrailingButtonType.icon,
              //   actionType: TrailingButtonActionType.action,
              //   svgPath: 'assets/icons/save.svg',
              //   iconColor: Colors.black,
              //   size: 48,
              //   backgroundColor: AppColors.background,
              //   onPressed: () {
              //     showModalBottomSheet<void>(
              //       context: context,
              //       isScrollControlled: true,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.vertical(top: Radius.circular(20)),
              //       ),
              //       builder: (context) => const SaveCostBreakdownSheet(
              //         type: ResultsOverviewType.basic,
              //         totalSellingPrice: 2000,
              //         isBestPractice: true,
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
        body: PlanBody(),
      );
}

class PlanBody extends StatefulWidget {
  PlanBody({super.key, this.initialStep = 0, this.totalSteps = 3}) {
    controller = Get.put(
      PlanController(initialStep: initialStep),
    );
  }

  late final PlanController controller;
  final int initialStep;
  final int totalSteps;
  @override
  State<PlanBody> createState() => PlanBodyState();
}

class PlanBodyState extends State<PlanBody>
    with SingleTickerProviderStateMixin {
  static const List<String> stepTitles = [
    'Coffee Processing Goal',
    'Pulping Machine',
    'Processing Setup',
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (widget.controller.startDate.value ?? DateTime.now())
          : (widget.controller.endDate.value ?? DateTime.now()),
      firstDate: isStartDate
          ? DateTime.now()
          : (widget.controller.startDate.value ?? DateTime.now()),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00B3B0),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF23262F),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          widget.controller.startDate.value = picked;
          widget.controller.startDateController.text =
              DateFormat('MMM dd, yyyy').format(picked);
          // If end date is before start date, update it
          if (widget.controller.endDate != null &&
              widget.controller.endDate.value!.isBefore(picked)) {
            widget.controller.endDate.value = picked;
            widget.controller.endDateController.text =
                DateFormat('MMM dd, yyyy').format(picked);
          }
        } else {
          if (widget.controller.startDate == null ||
              picked.isAfter(widget.controller.startDate.value!)) {
            widget.controller.endDate.value = picked;
            widget.controller.endDateController.text =
                DateFormat('MMM dd, yyyy').format(picked);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End date must be after start date'),
                backgroundColor: Color(0xFF00B3B0),
              ),
            );
          }
        }
      });
    }
  }

  List<int> get visibleSteps => [
        0,
        if (widget.controller.selectedCoffeesellingType.value !=
            'Dried pod/Jenfel')
          1,
        2,
      ];

  @override
  void initState() {
    super.initState();

    // widget.controller.currentStep.value = widget.initialStep;
  }

  void _goNext() {
    final currentIndex =
        visibleSteps.indexOf(widget.controller.currentStep.value);
    if (currentIndex < visibleSteps.length - 1) {
      setState(() {
        widget.controller.currentStep.value = visibleSteps[currentIndex + 1];
      });
    }
  }

  void _goBack() {
    final currentIndex =
        visibleSteps.indexOf(widget.controller.currentStep.value);
    if (currentIndex > 0) {
      setState(() {
        widget.controller.currentStep.value = visibleSteps[currentIndex - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) => Obx(
        () {
          final currentIndex =
              visibleSteps.indexOf(widget.controller.currentStep.value);
          final bool showBackButton = currentIndex > 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  if (showBackButton)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/back_arrow.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.black, BlendMode.srcIn),
                          ),
                          onPressed: _goBack,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 16),
                  const SizedBox(
                    width: 4,
                    height: 48,
                  ),
                  Text(
                    stepTitles[widget.controller.currentStep.value].tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: _HorizontalStepper(
                  currentStep: currentIndex,
                  totalSteps: visibleSteps.length,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              Expanded(
                child: _StepperPage(
                  step: widget.controller.currentStep.value,
                  onNext: _goNext,
                  controller: widget.controller,
                ),
              ),
            ],
          );
        },
      );
}

class _HorizontalStepper extends StatelessWidget {
  const _HorizontalStepper({
    required this.currentStep,
    required this.totalSteps,
  });
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < totalSteps - 1 ? 8 : 0,
                left: index > 0 ? 8 : 0,
              ),
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF10B4B1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      );
}

// ...existing imports...

class _StepperPage extends StatelessWidget {
  const _StepperPage({
    required this.step,
    required this.controller,
    required this.onNext,
  });
  final int step;
  final VoidCallback onNext;
  final PlanController controller;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return CoffeeProcessingGoalPage(
          onNext: onNext,
          controller: controller,
        );
      case 1:
        return ProcessingMethodPage(
          onNext: onNext,
          controller: controller,
        );
      case 2:
        return ProcessingSetupPage(
          controller: controller,
        );
      default:
        return const Center(child: Text('Unknown Step'));
    }
  }
}

class CoffeeProcessingGoalPage extends StatefulWidget {
  const CoffeeProcessingGoalPage({
    required this.onNext,
    required this.controller,
    super.key,
  });
  final VoidCallback onNext;
  final PlanController controller;

  @override
  State<CoffeeProcessingGoalPage> createState() =>
      _CoffeeProcessingGoalPageState();
}

class _CoffeeProcessingGoalPageState extends State<CoffeeProcessingGoalPage> {
  final coffeeProcessingGoalFormKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (widget.controller.startDate.value ?? DateTime.now())
          : (widget.controller.endDate.value ?? DateTime.now()),
      firstDate: isStartDate
          ? DateTime.now()
          : (widget.controller.startDate.value ?? DateTime.now()),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00B3B0),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF23262F),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          widget.controller.startDate.value = picked;
          widget.controller.startDateController.text =
              DateFormat('MMM dd, yyyy').format(picked);
          // If end date is before start date, update it
          if (widget.controller.endDate != null &&
              widget.controller.endDate.value!.isBefore(picked)) {
            widget.controller.endDate.value = picked;
            widget.controller.endDateController.text =
                DateFormat('MMM dd, yyyy').format(picked);
          }
        } else {
          if (widget.controller.startDate == null ||
              picked.isAfter(widget.controller.startDate.value!)) {
            widget.controller.endDate.value = picked;
            widget.controller.endDateController.text =
                DateFormat('MMM dd, yyyy').format(picked);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End date must be after start date'),
                backgroundColor: Color(0xFF00B3B0),
              ),
            );
          }
        }
      });
    }
  }

  String? selectedType;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            autovalidateMode:
                widget.controller.coffeeProcessingAutoValidate.value
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
            key: coffeeProcessingGoalFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledDropdown<String>(
                  label: 'Planned Coffee Type',
                  hintText: 'Select type',
                  value: widget.controller.selectedCoffeesellingType.value,
                  items: widget.controller.coffeeTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type.tr)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() {
                    if (val != null) {
                      widget.controller.ratioController.text =
                          CalcuationConstants.conversionFactors[val].toString();
                    }
                    widget.controller.selectedCoffeesellingType.value = val;
                  }),
                  errorText: 'Desired Coffee type should not be empty',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Total Planned Volume',
                  hintText: 'Amount in KG',
                  controller: widget.controller.seasonalCoffeeController,
                  keyboardType: TextInputType.number,
                  errorText: 'Total planned volume should not be empty',
                  minValue: '1',
                ),
                const SizedBox(height: 16),
                if (widget.controller.selectedCoffeesellingType.value ==
                        'Green Coffee' ||
                    widget.controller.selectedCoffeesellingType.value ==
                        'Cherries')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Planned Volume Details'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF23262F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Planned Volume of Fully Washed Coffee'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.textBlack100,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: widget.controller.fullyWashedPercent,
                              onChanged: (value) {
                                setState(() {
                                  widget.controller.fullyWashedPercent = value;
                                  widget.controller.sunDriedPercent = 1 - value;
                                });
                              },
                              min: 0,
                              max: 1,
                              divisions: 100,
                              activeColor: const Color(0xFF00B3B0),
                              inactiveColor: const Color(0xFFF3F4F6),
                            ),
                          ),
                          Text(
                            '${(widget.controller.fullyWashedPercent * 100).round()}%${' Coffee'.tr}',
                            style: const TextStyle(
                              color: Color(0xFF8C9199),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Planned Volume of Sun Dried Coffee'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.textBlack100,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: widget.controller.sunDriedPercent,
                              onChanged: (value) {
                                setState(() {
                                  widget.controller.sunDriedPercent = value;
                                  widget.controller.fullyWashedPercent =
                                      1 - value;
                                });
                              },
                              min: 0,
                              max: 1,
                              divisions: 100,
                              activeColor: const Color(0xFF00B3B0),
                              inactiveColor: const Color(0xFFF3F4F6),
                            ),
                          ),
                          Text(
                            '${(widget.controller.sunDriedPercent * 100).round()}${'% Coffee'.tr}',
                            style: const TextStyle(
                              color: Color(0xFF8C9199),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                Text(
                  'Processing Day'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF23262F),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing Start Date'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.controller.startDateController,
                            readOnly: true,
                            onTap: () => _selectDate(context, true),
                            decoration: InputDecoration(
                              hintText: 'Select day'.tr,
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/calendar.svg',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Start date is required'.tr;
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing End Date'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: widget.controller.endDateController,
                            readOnly: true,
                            onTap: () => _selectDate(context, false),
                            decoration: InputDecoration(
                              hintText: 'Select day'.tr,
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/calendar.svg',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E8E8),
                                  width: 0.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'End date is required'.tr;
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Add extra space at the bottom to prevent the button from overlapping content
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        // Positioned button at the bottom
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              widget.controller.coffeeProcessingAutoValidate.value = true;
              FocusScope.of(context).unfocus();

              final isValid =
                  coffeeProcessingGoalFormKey.currentState?.validate() ?? false;
              if (isValid) {
                widget.onNext();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                  'Next'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset(
                  'assets/icons/arrow-next.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProcessingMethodPage extends StatefulWidget {
  const ProcessingMethodPage({
    required this.onNext,
    required this.controller,
    super.key,
  });
  final PlanController controller;

  final VoidCallback onNext;
  @override
  State<ProcessingMethodPage> createState() => _ProcessingMethodPageState();
}

class _ProcessingMethodPageState extends State<ProcessingMethodPage> {
  final pulpingMachineFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    return Obx(
      () => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              autovalidateMode:
                  widget.controller.pulpingMachineAutoValidate.value
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
              key: pulpingMachineFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pulping Machine Type'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF23262F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: widget.controller.machineTypeController,
                    readOnly: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF23262F),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Disk Pulper',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB0B7C3),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFFE8E8E8), width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFFE8E8E8), width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFFE8E8E8), width: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Number of pulping machine',
                    hintText: '12',
                    controller: widget.controller.numMachinesController,
                    keyboardType: TextInputType.number,
                    errorText: 'Number of pulping machine should not be empty',
                    minValue: '1',
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Number of disks',
                    hintText: '12',
                    controller: widget.controller.numDisksController,
                    keyboardType: TextInputType.number,
                    errorText: 'Number of disks machine should not be empty',
                    minValue: '1',
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Operating Hours',
                    hintText: '12',
                    controller: widget.controller.operatingHoursController,
                    keyboardType: TextInputType.number,
                    errorText: 'Operating hours should not be empty',
                    minValue: '1',
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFF8C9199)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'A single disc can process approximately 1,000 KG of cherries per hour'
                                .tr,
                            style: const TextStyle(
                              color: Color(0xFF8C9199),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add extra space at the bottom to prevent content from being hidden behind the button
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Positioned button at the bottom
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                widget.controller.pulpingMachineAutoValidate.value = true;
                widget.controller.calculatePulpingCapacity();
                FocusScope.of(context).unfocus();

                final isValid =
                    pulpingMachineFormKey.currentState?.validate() ?? false;
                if (isValid) {
                  widget.onNext();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
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
                    'Next'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset(
                    'assets/icons/arrow-next.svg',
                    width: 16,
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessingSetupPage extends StatefulWidget {
  const ProcessingSetupPage({
    required this.controller,
    super.key,
  });
  final PlanController controller;
  @override
  State<ProcessingSetupPage> createState() => _ProcessingSetupPageState();
}

class _ProcessingSetupPageState extends State<ProcessingSetupPage> {
  final planFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PlanController>()) {
      Get.put(PlanController(), tag: UniqueKey().toString());
    }
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: planFormKey,
          autovalidateMode: widget.controller.processingSetupAutoValidate.value
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fermentation Tank Section
              if (widget.controller.selectedCoffeesellingType.value !=
                  'Dried pod/Jenfel')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/poly.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Fermentation Tank'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF23262F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Length',
                      hintText: 'Input value in meters',
                      controller:
                          widget.controller.fermentationLengthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Width',
                      hintText: 'Input value in meters',
                      controller: widget.controller.fermentationWidthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Depth',
                      hintText: 'Input value in meters',
                      controller: widget.controller.fermentationDepthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Fermentation Hours',
                      hintText: '12',
                      controller: widget.controller.fermentationHoursController,
                      minValue: '1',
                      suffixIcon: Image.asset(
                        AppAssets.clockIcon,
                        width: 12,
                        height: 12,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Soaking Section
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/submerge.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Soaking'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xFF23262F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Length',
                      hintText: 'Input value in meters',
                      controller: widget.controller.soakingLengthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Width',
                      hintText: 'Input value in meters',
                      controller: widget.controller.soakingWidthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Depth',
                      hintText: 'Input value in meters',
                      controller: widget.controller.soakingDepthController,
                      minValue: '1',
                    ),
                    const SizedBox(height: 20),
                    // Soaking Duration with calendar icon
                    LabeledTextField(
                      label: 'Soaking Duration',
                      hintText: 'Soaking Duration',
                      controller: widget.controller.soakingDurationController,
                      keyboardType: TextInputType.number,
                      minValue: '1',
                      suffixIcon: Image.asset(
                        AppAssets.clockIcon,
                        width: 12,
                        height: 12,
                      ),

                      // You can add a suffixIcon here if your widget supports it
                    ),

                    const SizedBox(height: 32),
                  ],
                ),

              // Drying Table Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/cells.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Drying Table'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Length',
                hintText: 'Input value in meters',
                controller: widget.controller.dryingLengthController,
                minValue: '1',
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Width',
                hintText: 'Input value in meters',
                controller: widget.controller.dryingWidthController,
                minValue: '1',
              ),
              if (widget.controller.selectedCoffeesellingType.value !=
                  'Dried pod/Jenfel')
                const SizedBox(height: 20),
              if (widget.controller.selectedCoffeesellingType.value !=
                  'Dried pod/Jenfel')
                LabeledTextField(
                  label: 'Average Estimated Drying Time For Washed',
                  hintText: 'Number of days',
                  controller: widget.controller.dryingTimeWashedController,
                  minValue: '1',
                ),
              const SizedBox(height: 20),
              if (widget.controller.selectedCoffeesellingType.value !=
                  'Parchment')
                LabeledTextField(
                  label: 'Average Estimated Drying Time For Natural Sun Dried',
                  hintText: 'Number of days',
                  controller: widget.controller.dryingTimeSunDriedController,
                  minValue: '1',
                ),

              const SizedBox(height: 32),

              // Bagging Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/shopping-bag.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Bagging'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              LabeledTextField(
                label: 'Bag Size',
                hintText: 'Enter Size',
                controller: widget.controller.selectedBagSize,
                minValue: '1',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF8C9199)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Assume that 1,500 kgs of cherries produces 1 m3 of wet parchment (parchment coffee with mucilage intact)'
                            .tr,
                        style: const TextStyle(
                          color: Color(0xFF8C9199),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.processingSetupAutoValidate.value = true;

                    FocusScope.of(context).unfocus();

                    final isValid =
                        planFormKey.currentState?.validate() ?? false;
                    if (isValid) {
                      widget.controller.calculateFermentation();
                      widget.controller.calculateSoaking();
                      widget.controller.calculateDrying();
                      widget.controller.calculateBagging();
                      widget.controller.calculateWashedOutput();
                      widget.controller.calculateNaturalOutput();
                      widget.controller.onDataSubmit();
                    }
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
                        'Generate Plan'.tr,
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
        ),
      ),
    );
  }
}
