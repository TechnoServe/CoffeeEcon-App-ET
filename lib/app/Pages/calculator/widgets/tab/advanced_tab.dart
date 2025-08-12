import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/advanced_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/utils/helpers.dart';

import 'package:get/get.dart';

class AdvancedTab extends StatefulWidget {
  AdvancedTab({
    super.key,
    this.initialStep = 0, // 0-based index
    this.totalSteps = 6,
    this.entry,
  }) {
         controller = Get.find<AdvancedCalculatorController>();

  }

  late final AdvancedCalculatorController controller;
  final AdvancedCalculationModel? entry;

  final int initialStep;
  final int totalSteps;

  @override
  State<AdvancedTab> createState() => _AdvancedTabState();
}

class _AdvancedTabState extends State<AdvancedTab> {
  static const List<String> stepTitles = [
    'Procurement Expenses',
    'Transport and Commission',
    'Labour Cost',
    'Fuel and Oils',
    'Maintenance & Equipment Cost',
    'Other Expenses',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.currentStep.value = widget.initialStep;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.entry != null) {
        widget.controller.patchAdvancedCalcData(data: widget.entry);
      }
    });

    return Obx(() {
      final bool showBackButton = widget.controller.currentStep.value > 0;

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
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: widget.controller.goBack,
                    ),
                  ),
                )
              else
                const SizedBox(width: 16),
              const SizedBox(
                width: 4,
                height: 48,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stepTitles[widget.controller.currentStep.value].tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF23262F),
                      ),
                    ),
                    if (stepTitles[widget.controller.currentStep.value] ==
                        'Procurement Expenses')
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                        ),
                        child: CustomChip(
                          onTap: () {},
                          isCurrency: false,
                          isRegion: false,
                          isUnit: true,
                          label: widget.controller.selectedUnit.value,
                          onUnitSelected: (value) {
                            widget.controller.selectedUnit.value =
                                value ?? 'KG';
                          },
                          svgPath: 'assets/icons/birr.svg',
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: _HorizontalStepper(
              currentStep: widget.controller.currentStep.value,
              totalSteps: widget.totalSteps,
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 16),
          Expanded(
            child: StepperPage(
              controller: widget.controller,
            ),
          ),
        ],
      );
    });
  }
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

class StepperPage extends StatelessWidget {
  const StepperPage({required this.controller, super.key});
  final AdvancedCalculatorController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
        final step = controller.currentStep.value;
        final page = [
          ProcurementExpensesPage(
            controller: controller,
          ),
          TransportAndCommissionPage(
            controller: controller,
          ),
          LabourCostPage(
            controller: controller,
          ),
          FuelsPage(
            controller: controller,
          ),
          MaintenanceEquipmentCostPage(
            controller: controller,
          ),
          OtherExpensesPage(
            controller: controller,
          ),
        ];

        return page.length > step
            ? page[step]
            : const Center(child: Text('Unknown Step'));
      });
}

class ProcurementExpensesPage extends StatefulWidget {
  const ProcurementExpensesPage({required this.controller, super.key});
  final AdvancedCalculatorController controller;

  @override
  State<ProcurementExpensesPage> createState() =>
      _ProcurementExpensesPageState();
}

class _ProcurementExpensesPageState extends State<ProcurementExpensesPage> {
  final procurumentExpenseFormKey = GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
    widget.controller.validateAllLabels();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // widget.controller.procurumentExpenseExtraFields = [];
    // widget.controller.procurumentExpenseLabeledExtras = [];
    // widget.controller.transportAndCommissionExtraFields = [];
    // widget.controller.transportAndCommissionExtras = [];
    // widget.controller.fuelsExtraFields = [];
    // widget.controller.fuelsExtras = [];
    // widget.controller.maintenanceEquipmentCostExtraFields = [];
    // widget.controller.maintenanceEquipmentCostExtras = [];
    // widget.controller.otherExpensesExtraFields = [];
    // widget.controller.otherExpensesExtras = [];

    super.initState();
  }

  bool hasDuplicateError = false;
  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.procurumentExpenseAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            autovalidateMode:
                widget.controller.procurumentExpenseAutoValidate.value
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
            key: procurumentExpenseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledTextField(
                  label: 'Cherry Purchase Volume',
                  hintText: 'Amount',
                  suffixText: '${'In'.tr} ${widget.controller.selectedUnit.value.tr}',
                  controller: widget.controller.cherryPurchaseController,
                  keyboardType: TextInputType.number,
                  minValue: '1',
                  errorText: 'Cherry Purchase Volume is required',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Seasonal Coffee Cherry Price',
                  hintText: 'Amount',
                  controller: widget.controller.seasonalCoffeeController,
                  keyboardType: TextInputType.number,
                  errorText: 'Seasonal Coffee Cherry Price is required',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Second Payment',
                  hintText: 'Amount',
                  controller: widget.controller.secondPaymentController,
                  keyboardType: TextInputType.number,
                  isRequired: false,
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Low Grade Hulling Cost',
                  hintText: 'Amount',
                  controller: widget.controller.lowGradeHullingController,
                  keyboardType: TextInputType.number,
                  isRequired: false,
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Jute Bag Price',
                  hintText: 'Amount',
                  controller: widget.controller.juteBagPriceController,
                  keyboardType: TextInputType.number,
                  errorText: 'Jute Bag price is required',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Jute Bag Volume',
                  hintText: 'Jute Bag Volume',
                  controller: widget.controller.selectedJuteBagVolume,
                  keyboardType: TextInputType.number,
                  errorText: 'Jute bag volume is required',

                  // validator: widget.controller.validateDropdown,
                ),
                const SizedBox(height: 16),
                LabeledDropdown<String>(
                  label: 'Coffee Type',
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
                          ((CalcuationConstants.conversionFactors[val]?? 0) * 100).toString();
                    }
                    widget.controller.selectedCoffeesellingType.value = val;
                  }),
                  errorText: 'Coffee selling type is required',

                  // validator: widget.controller.validateDropdown,
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Conversion Ratio',
                  keyboardType: TextInputType.number,
                  hintText: '18.0%',
                  controller: widget.controller.ratioController,
                  errorText: 'Ratio is required',
                  minValue: '0.1',
                ),
                const SizedBox(height: 16),
                ...widget.controller.procurumentExpenseExtraFields,
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          final controller = TextEditingController();
                          final focusNode = FocusNode();
                          final labelFocusNode = FocusNode();
                          final label =
                              '${'Input'.tr} ${widget.controller.procurumentExpenseExtraFields.length + 1}';
                          final labeledController = LabeledController(
                            label: label,
                            controller: controller,
                            focusNode: focusNode,
                          );
                          widget.controller.procurumentExpenseLabeledExtras
                              .add(labeledController);
                          widget.controller.procurumentExpenseExtraFields.add(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: LabeledTextField(
                                label: labeledController.label,
                                hintText: 'Amount'.tr,
                                isRequired: false,
                                controller: controller,
                                isLabelEditable: true,
                                onLabelChanged: (newLabel) {
                                  labeledController.label =
                                      newLabel['text'].toString();
                                  hasDuplicateError =
                                      newLabel['hasError'] as bool;
                                },
                                labeledControllers: widget
                                    .controller.procurumentExpenseLabeledExtras,
                                currentController: labeledController,
                                focusNode: focusNode,
                                labelFocusNode: labelFocusNode,
                              ),
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add New Field'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.textBlack60,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        // This allows RichText to wrap
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.labelSmall,
                            children: [
                              TextSpan(
                                text: 'Note: '.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'When adding a new field, the value should represent lump sum data rather than a unit price'
                                        .tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.controller.procurumentExpenseAutoValidate.value =
                          true;
                      FocusScope.of(context).unfocus();

                      final isValid =
                          procurumentExpenseFormKey.currentState?.validate() ??
                              false;
                      if (isValid && !hasDuplicateError) {
                        widget.controller.calculateProcurementExpenseTotal();
                        widget.controller.goNext();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
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
          ),
        ),
      ),
    );
}

class TransportAndCommissionPage extends StatefulWidget {
  final AdvancedCalculatorController controller;

  const TransportAndCommissionPage({required this.controller, super.key});

  @override
  State<TransportAndCommissionPage> createState() =>
      _TransportAndCommissionPageState();
}

class _TransportAndCommissionPageState
    extends State<TransportAndCommissionPage> {
  bool hasDuplicateError = false;

  void _addNewField() {
    setState(() {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final labelFocusNode = FocusNode();
      final label =
          '${'Input'.tr} ${widget.controller.transportAndCommissionExtraFields.length + 1}';
      final labeledController = LabeledController(
        label: label,
        controller: controller,
        focusNode: focusNode,
      );

      widget.controller.transportAndCommissionExtras.add(labeledController);
      widget.controller.transportAndCommissionExtraFields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LabeledTextField(
            label: labeledController.label,
            hintText: 'Value',
            controller: controller,
            isLabelEditable: true,
            isRequired: false,
            onLabelChanged: (newLabel) {
              labeledController.label = newLabel['text'].toString();
              hasDuplicateError = newLabel['hasError'] as bool;
            },
            labeledControllers: widget.controller.transportAndCommissionExtras,
            currentController: labeledController,
            focusNode: focusNode,
            labelFocusNode: labelFocusNode,
          ),
        ),
      );
    });
  }

  final transportAndCommissionFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.transportAndCommissionAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: widget
                            .controller.transportAndCommissionAutoValidate.value
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    key: transportAndCommissionFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Transport Cost',
                          hintText: 'Amount',
                          controller: widget.controller.transportCostController,
                          keyboardType: TextInputType.number,
                          errorText: 'Transport Cost is required',
                        ),
                        const SizedBox(height: 16),
                        LabeledTextField(
                          label: 'Commission',
                          hintText: 'Amount',
                          controller: widget.controller.commissionController,
                          keyboardType: TextInputType.number,
                          errorText: 'Commission is required',
                        ),
                        const SizedBox(height: 16),
                        ...widget.controller.transportAndCommissionExtraFields,
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addNewField,
                              icon: const Icon(Icons.add),
                              label: Text(
                                'Add New Field'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.transportAndCommissionAutoValidate.value =
                        true;
                    FocusScope.of(context).unfocus();

                    final isValid = transportAndCommissionFormKey.currentState
                            ?.validate() ??
                        false;
                    if (isValid && !hasDuplicateError) {
                      widget.controller
                          .calculateTransportationAndCommisionTotal();
                      widget.controller.goNext();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
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
        ),
      ),
    );
}

class LabourCostPage extends StatefulWidget {
  final AdvancedCalculatorController controller;

  const LabourCostPage({required this.controller, super.key});
  @override
  State<LabourCostPage> createState() => _LabourCostPageState();
}

class _LabourCostPageState extends State<LabourCostPage> {
  final labourCostFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.labourCostAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode:
                        widget.controller.labourCostAutoValidate.value
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                    key: labourCostFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Casual',
                          hintText: 'Amount',
                          controller: widget.controller.casualController,
                          keyboardType: TextInputType.number,
                          errorText: 'Casual is required',
                        ),
                        const SizedBox(height: 16),
                        LabeledTextField(
                          label: 'Permanent',
                          hintText: 'Amount',
                          controller: widget.controller.permanentController,
                          keyboardType: TextInputType.number,
                          errorText: 'Permanent is required',
                        ),
                        const SizedBox(height: 16),
                        LabeledTextField(
                          label: 'Overhead',
                          hintText: 'Amount',
                          controller: widget.controller.overheadController,
                          keyboardType: TextInputType.number,
                          errorText: 'Overhead is required',
                        ),
                        const SizedBox(height: 16),
                        LabeledTextField(
                          label: 'Other',
                          hintText: 'Amount',
                          controller: widget.controller.otherController,
                          keyboardType: TextInputType.number,
                          isRequired: false,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.labourCostAutoValidate.value = true;

                    final isValid =
                        labourCostFormKey.currentState?.validate() ?? false;
                    if (isValid) {
                      widget.controller.calculateLabourCost();
                      widget.controller.goNext();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
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
        ),
      ),
    );
}

class FuelsPage extends StatefulWidget {
  final AdvancedCalculatorController controller;

  const FuelsPage({required this.controller, super.key});
  @override
  State<FuelsPage> createState() => _FuelsPageState();
}

class _FuelsPageState extends State<FuelsPage> {
  final fuelsFormKey = GlobalKey<FormState>();
  bool hasDuplicateError = false;

  void _addNewField() {
    setState(() {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final labelFocusNode = FocusNode();
      final label = '${'Input'.tr}  ${widget.controller.fuelsExtraFields.length + 1}';
      final labeledController = LabeledController(
        label: label,
        controller: controller,
        focusNode: focusNode,
      );

      widget.controller.fuelsExtras.add(labeledController);

      widget.controller.fuelsExtraFields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LabeledTextField(
            label: labeledController.label,
            hintText: 'Value',
            controller: controller,
            isLabelEditable: true,
            isRequired: false,
            onLabelChanged: (newLabel) {
              labeledController.label = newLabel['text'].toString();
              hasDuplicateError = newLabel['hasError'] as bool;
            },
            labeledControllers: widget.controller.fuelsExtras,
            currentController: labeledController,
            focusNode: focusNode,
            labelFocusNode: labelFocusNode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.fuelsAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: widget.controller.fuelsAutoValidate.value
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    key: fuelsFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Fuel Cost',
                          hintText: 'Amount',
                          controller: widget.controller.fuelCostController,
                          keyboardType: TextInputType.number,
                          errorText: 'Fuel Cost is required',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Machinery Fuel Consumption'.tr,
                          style: const TextStyle(
                              color: AppColors.textBlack60, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        ...widget.controller.fuelsExtraFields,
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addNewField,
                              icon: const Icon(Icons.add),
                              label: Text(
                                'Add New Field'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.fuelsAutoValidate.value = true;
                    FocusScope.of(context).unfocus();

                    final isValid =
                        fuelsFormKey.currentState?.validate() ?? false;
                    if (isValid && !hasDuplicateError) {
                      widget.controller.calculateFuels();
                      widget.controller.goNext();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
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
        ),
      ),
    );
}

class MaintenanceEquipmentCostPage extends StatefulWidget {
  final AdvancedCalculatorController controller;

  const MaintenanceEquipmentCostPage({required this.controller, super.key});
  @override
  State<MaintenanceEquipmentCostPage> createState() =>
      _MaintenanceEquipmentCostPageState();
}

class _MaintenanceEquipmentCostPageState
    extends State<MaintenanceEquipmentCostPage> {
  final maintenanceEquipmentCostFormKey = GlobalKey<FormState>();
  bool hasDuplicateError = false;

  void _addNewField() {
    setState(() {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final labelFocusNode = FocusNode();
      final label =
          '${'Input'.tr}  ${widget.controller.maintenanceEquipmentCostExtraFields.length + 1}';
      final labeledController = LabeledController(
        label: label,
        controller: controller,
        focusNode: focusNode,
      );

      widget.controller.maintenanceEquipmentCostExtras.add(labeledController);

      widget.controller.maintenanceEquipmentCostExtraFields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LabeledTextField(
            label: labeledController.label,
            hintText: 'Amount',
            controller: controller,
            isLabelEditable: true,
            isRequired: false,
            onLabelChanged: (newLabel) {
              labeledController.label = newLabel['text'].toString();
              hasDuplicateError = newLabel['hasError'] as bool;
            },
            labeledControllers: widget.controller.transportAndCommissionExtras,
            currentController: labeledController,
            focusNode: focusNode,
            labelFocusNode: labelFocusNode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.maintenanceEquipmentCostAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            autovalidateMode:
                widget.controller.maintenanceEquipmentCostAutoValidate.value
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
            key: maintenanceEquipmentCostFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledTextField(
                  label: 'Utilities',
                  hintText: 'Amount',
                  controller: widget.controller.utilitiesController,
                  keyboardType: TextInputType.number,
                  errorText: 'Utilites is required',
                ),
                const SizedBox(height: 16),
                // LabeledTextField(
                //   label: 'Oils',
                //   hintText: 'Amount',
                //   controller: widget.controller.oilsController,
                //   keyboardType: TextInputType.number,
                //   errorText: 'Oils is required',
                // ),
                // const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Annual Maintenance Cost',
                  hintText: 'Amount',
                  controller: widget.controller.annualMaintenanceController,
                  keyboardType: TextInputType.number,
                  errorText: 'Annual Maintenance is required',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Drying Bed Equipment',
                  hintText: 'Amount',
                  controller: widget.controller.dryingBedController,
                  keyboardType: TextInputType.number,
                  errorText: 'Drying Bed is required',
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Spare Part Cost',
                  hintText: 'Amount',
                  controller: widget.controller.sparePartController,
                  keyboardType: TextInputType.number,
                  errorText: 'Spare Part Cost is required',
                ),
                const SizedBox(height: 16),
                // LabeledTextField(
                //   label: 'Mechanic Cost',
                //   hintText: 'Amount',
                //   controller: widget.controller.mechanicController,
                //   keyboardType: TextInputType.number,
                //   errorText: 'Mechanic Cost is required',
                // ),
                // const SizedBox(height: 16),
                ...widget.controller.maintenanceEquipmentCostExtraFields,
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addNewField,
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add New Field'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.controller.maintenanceEquipmentCostAutoValidate
                          .value = true;
                      FocusScope.of(context).unfocus();

                      final isValid = maintenanceEquipmentCostFormKey
                              .currentState
                              ?.validate() ??
                          false;
                      if (isValid && !hasDuplicateError) {
                        widget.controller.calculateFMaintenanceExpenseCost();
                        widget.controller.goNext();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
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
          ),
        ),
      ),
    );
}

class OtherExpensesPage extends StatefulWidget {
  final AdvancedCalculatorController controller;

  const OtherExpensesPage({required this.controller, super.key});
  @override
  State<OtherExpensesPage> createState() => _OtherExpensesPageState();
}

class _OtherExpensesPageState extends State<OtherExpensesPage> {
  final otherExpensesFormKey = GlobalKey<FormState>();
  // dummy node to hide keyboard when last calculate button pressed and pop shows
  final FocusNode blankFocusNode = FocusNode();
  bool hasDuplicateError = false;

  void _addNewField() {
    setState(() {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      final labelFocusNode = FocusNode();
      final label =
          '${'Input'.tr}  ${widget.controller.otherExpensesExtraFields.length + 1}';
      final labeledController = LabeledController(
        label: label,
        controller: controller,
        focusNode: focusNode,
      );

      widget.controller.otherExpensesExtras.add(labeledController);

      widget.controller.otherExpensesExtraFields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LabeledTextField(
            label: labeledController.label,
            hintText: 'Amount',
            controller: controller,
            isLabelEditable: true,
            isRequired: false,
            onLabelChanged: (newLabel) {
              labeledController.label = newLabel['text'].toString();
              hasDuplicateError = newLabel['hasError'] as bool;
            },
            labeledControllers: widget.controller.transportAndCommissionExtras,
            currentController: labeledController,
            focusNode: focusNode,
            labelFocusNode: labelFocusNode,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    blankFocusNode.dispose(); // Important to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        widget.controller.otherExpensesAutoValidate.value = false;
        return true;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode:
                        widget.controller.otherExpensesAutoValidate.value
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                    key: otherExpensesFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Other Expenses',
                          hintText: 'Amount',
                          controller: widget.controller.otherExpensesController,
                          keyboardType: TextInputType.number,
                          errorText: 'Other Expnese is required',
                        ),
                        const SizedBox(height: 16),
                        ...widget.controller.otherExpensesExtraFields,
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addNewField,
                              icon: const Icon(Icons.add),
                              label: Text(
                                'Add New Field'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      FocusScope.of(context).requestFocus(blankFocusNode);
                      widget.controller.otherExpensesAutoValidate.value = true;
                      FocusScope.of(context).unfocus();

                      final isValid =
                          otherExpensesFormKey.currentState?.validate() ??
                              false;

                      if (isValid && !hasDuplicateError) {
                        widget.controller.calculateOtherExpenses();
                        widget.controller.onCalculate(context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
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
        ),
      ),
    );
}
