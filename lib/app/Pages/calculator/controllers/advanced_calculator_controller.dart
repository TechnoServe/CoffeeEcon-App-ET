import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/best_practice_modal.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/utils/helpers.dart';
import 'package:get/get.dart';

class AdvancedCalculatorController extends GetxController {
  // Procurement expenses data controllers for user input fields
  final TextEditingController cherryPurchaseController =
      TextEditingController();
  final TextEditingController seasonalCoffeeController =
      TextEditingController();
  final TextEditingController secondPaymentController = TextEditingController();
  final TextEditingController lowGradeHullingController =
      TextEditingController();
  final TextEditingController juteBagPriceController = TextEditingController();
  final TextEditingController ratioController = TextEditingController();
  final TextEditingController selectedJuteBagVolume = TextEditingController();

  // Selected coffee selling type (e.g., Parchment, Green Coffee, etc.)
  final selectedCoffeesellingType = RxnString();
  // List of extra procurement expense fields (dynamic)
  List<LabeledController> procurumentExpenseLabeledExtras = [];
  List<Widget> procurumentExpenseExtraFields = [];

  // Validation and total for procurement expenses
  final RxBool procurumentExpenseAutoValidate = false.obs;
  final RxDouble procurumentExpenseTotal = 0.0.obs;

  /////////////////////////////////////////////////////////////////

  // Transportation and commission data controllers
  final TextEditingController transportCostController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  List<Widget> transportAndCommissionExtraFields = [];
  List<LabeledController> transportAndCommissionExtras = [];
  final RxBool transportAndCommissionAutoValidate = false.obs;
  final RxDouble transportAndCommissionTotal = 0.0.obs;

  ///////////////////////////////

  // Labour cost controllers
  final TextEditingController casualController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController permanentController = TextEditingController();
  final TextEditingController overheadController = TextEditingController();

  final RxBool labourCostAutoValidate = false.obs;
  final RxDouble labourFullTimeTotal = 0.0.obs;
  final RxDouble labourCasualTotal = 0.0.obs;
  /////////////////////////////////////////////////////////////////

  // Fuels and oils controllers
  final TextEditingController fuelCostController = TextEditingController();
  List<Widget> fuelsExtraFields = [];
  List<LabeledController> fuelsExtras = [];
  final RxBool fuelsAutoValidate = false.obs;
  final RxDouble fuelsTotal = 0.0.obs;

  ///////////////////////////////

  // Maintenance Equipment controllers
  final TextEditingController utilitiesController = TextEditingController();
  final TextEditingController annualMaintenanceController =
      TextEditingController();
  final TextEditingController dryingBedController = TextEditingController();
  final TextEditingController sparePartController = TextEditingController();
  List<Widget> maintenanceEquipmentCostExtraFields = [];
  List<LabeledController> maintenanceEquipmentCostExtras = [];
  final RxBool maintenanceEquipmentCostAutoValidate = false.obs;
  final RxDouble maintenanceEquipmentCostTotal = 0.0.obs;

  // Other expenses controllers
  final TextEditingController otherExpensesController = TextEditingController();
  List<Widget> otherExpensesExtraFields = [];
  List<LabeledController> otherExpensesExtras = [];
  final RxBool otherExpensesAutoValidate = false.obs;
  final RxDouble otherExpensesTotal = 0.0.obs;

  ///////////////////////////////
  // Used for continue anyway: tracks which fields have been overridden by the user
  final Map<String, bool> overriddenFieldAlerts = {
    'seasonalPrice': false,
    'cherryTransport': false,
    'laborFullTime': false,
    'laborCasual': false,
    'fuelAndOils': false,
    'repairsAndMaintenance': false,
    'otherExpenses': false,
  };

  // Coffee types and selected unit
  final coffeeTypes = [
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  final selectedUnit = 'KG'.obs;

  // Total cost result (sum of all cost categories)
  final totalCost = 0.0.obs;

  // Stepper logic for multi-step form
  RxInt currentStep = 0.obs;
  final fieldAlerts = <String, bool>{}.obs;
  bool isBestPractice = true;

  final int totalSteps = 6; // Or pass this as a parameter

  // Navigation for stepper UI
  void goNext() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goTo(int index) {
    if (index >= 0 && index < totalSteps) {
      currentStep.value = index;
    }
  }

  // Patch the controller fields with data from an AdvancedCalculationModel
  void patchAdvancedCalcData({AdvancedCalculationModel? data}) {
    if (data == null) return;
    // Set all controllers' text from the model
    cherryPurchaseController.text = data.cherryPurchase;
    seasonalCoffeeController.text = data.seasonalCoffee;
    secondPaymentController.text = data.secondPayment;
    lowGradeHullingController.text = data.lowGradeHulling;
    juteBagPriceController.text = data.juteBagPrice;
    selectedJuteBagVolume.text = data.juteBagVolume;
    ratioController.text = data.ratio;

    transportCostController.text = data.transportCost;
    commissionController.text = data.commission;

    casualController.text = data.casualLabour;
    otherController.text = data.otherLabour;

    overheadController.text = data.overhead;
    permanentController.text = data.permanentLabour;

    fuelCostController.text = data.fuelCost;

    utilitiesController.text = data.utilities;
    annualMaintenanceController.text = data.annualMaintenance;
    dryingBedController.text = data.dryingBed;
    sparePartController.text = data.sparePart;

    otherExpensesController.text = data.otherExpenses;

    procurumentExpenseTotal.value = data.procurementTotal;
    transportAndCommissionTotal.value = data.transportTotal;
    labourCasualTotal.value = data.casualTotal;
    labourFullTimeTotal.value = data.permanentTotal;
    fuelsTotal.value = data.fuelTotal;
    maintenanceEquipmentCostTotal.value = data.maintenanceTotal;
    otherExpensesTotal.value = data.otherTotal;
    selectedCoffeesellingType.value = data.sellingType;

    _patchExtras(
      extras: data.procurementExtras,
      controllerList: procurumentExpenseLabeledExtras,
      fieldList: procurumentExpenseExtraFields,
      hintText: 'Amount',
    );

    _patchExtras(
      extras: data.transportExtras,
      controllerList: transportAndCommissionExtras,
      fieldList: transportAndCommissionExtraFields,
      hintText: 'Value',
    );

    _patchExtras(
      extras: data.fuelExtras,
      controllerList: fuelsExtras,
      fieldList: fuelsExtraFields,
      hintText: 'Value',
    );

    _patchExtras(
      extras: data.otherExtras,
      controllerList: otherExpensesExtras,
      fieldList: otherExpensesExtraFields,
      hintText: 'Amount',
    );

    _patchExtras(
      extras: data.maintenanceExtras,
      controllerList: maintenanceEquipmentCostExtras,
      fieldList: maintenanceEquipmentCostExtraFields,
      hintText: 'Amount',
    );
  }

//it allows to patch additional labels
  void _patchExtras({
    required List<Map<String, String>> extras,
    required List<LabeledController> controllerList,
    required List<Widget> fieldList,
    required String hintText,
  }) {
    controllerList.clear();
    fieldList.clear();
    // For each extra, create a controller and widget for dynamic fields
    for (final item in extras) {
      final label = item.keys.first;
      final value = item.values.first;

      final controller = TextEditingController(text: value);
      final focusNode = FocusNode();
      final labelFocusNode = FocusNode();

      final labeledController = LabeledController(
        label: label,
        controller: controller,
        focusNode: focusNode,
      );

      controllerList.add(labeledController);

      fieldList.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: LabeledTextField(
            label: labeledController.label,
            hintText: hintText,
            controller: controller,
            isLabelEditable: true,
            isRequired: false,
            onLabelChanged: (newLabel) {
              labeledController.label = newLabel['text'].toString();
            },
            labeledControllers: controllerList,
            currentController: labeledController,
            focusNode: focusNode,
            labelFocusNode: labelFocusNode,
          ),
        ),
      );
    }
  }

  /// Calculates the total procurement expense by summing all relevant controllers.
  void calculateProcurementExpenseTotal() {
    double total = 0.0;
    final List<TextEditingController> controllers = [
      seasonalCoffeeController,
      secondPaymentController,
      lowGradeHullingController,
      ...procurumentExpenseLabeledExtras.map((e) => e.controller),
    ];
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    procurumentExpenseTotal.value = total;
  }

  /// Calculates the total transportation and commission cost.
  void calculateTransportationAndCommisionTotal() {
    double total = 0.0;
    final List<TextEditingController> controllers = [
      transportCostController,
      commissionController,
      ...transportAndCommissionExtras.map((e) => e.controller),
    ];
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    transportAndCommissionTotal.value = total;
  }

  /// Calculates the total labour cost, split into casual and permanent.
  void calculateLabourCost() {
    double casualTotal = 0.0;
    double permanentTotal = 0.0;
    final List<TextEditingController> casualControllers = [
      casualController,
      otherController,
    ];
    for (final controller in casualControllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      casualTotal += value;
    }
    labourCasualTotal.value = casualTotal;
    final List<TextEditingController> permanentControllers = [
      permanentController,
      overheadController,
    ];
    for (final controller in permanentControllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      permanentTotal += value;
    }
    labourFullTimeTotal.value = permanentTotal;
  }

  /// Calculates the total fuel and oils cost.
  void calculateFuels() {
    double total = 0.0;
    final List<TextEditingController> controllers = [
      fuelCostController,
      ...fuelsExtras.map((e) => e.controller),
    ];
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    fuelsTotal.value = total;
  }

  /// Calculates the total maintenance equipment cost.
  void calculateFMaintenanceExpenseCost() {
    double total = 0.0;
    final List<TextEditingController> controllers = [
      utilitiesController,
      annualMaintenanceController,
      dryingBedController,
      sparePartController,
      ...maintenanceEquipmentCostExtras.map((e) => e.controller),
    ];
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    maintenanceEquipmentCostTotal.value = total;
  }

  /// Calculates the total for other expenses.
  void calculateOtherExpenses() {
    double total = 0.0;
    final List<TextEditingController> controllers = [
      otherExpensesController,
      ...otherExpensesExtras.map((e) => e.controller),
    ];
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0.0;
      total += value;
    }
    otherExpensesTotal.value = total;
  }

  /// Validates the cost percentages for each category against recommended ranges.
  /// Shows a warning modal if any field is out of range.
  void validateCostPercentages(BuildContext context) {
    final Map<String, double> values = {
      'seasonalPrice': procurumentExpenseTotal.value,
      'cherryTransport': transportAndCommissionTotal.value,
      'laborFullTime': labourFullTimeTotal.value,
      'laborCasual': labourCasualTotal.value,
      'fuelAndOils': fuelsTotal.value,
      'repairsAndMaintenance': maintenanceEquipmentCostTotal.value,
      'otherExpenses': otherExpensesTotal.value,
    };
    final total = values.values.fold(0.0, (a, b) => a + b);
    totalCost.value = total;
    final entries = values.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final key = entries[i].key;
      final value = entries[i].value;
      final percent = total > 0 ? ((value / total) * 100).roundToDouble() : 0;
      final range = CalcuationConstants.fieldRanges[key]!;
      // If overridden, skip this check entirely
      if (overriddenFieldAlerts[key] == true) {
        fieldAlerts[key] = false;
        continue;
      }
      final isOutOfRange = !range.isInRange(percent.toDouble());
      fieldAlerts[key] = isOutOfRange;
      if (isOutOfRange) {
        // Determine fieldIndex based on key
        final fieldIndex = _getFieldIndex(key, i);
        showFieldRangeWarning(
          context: context,
          fieldKey: key,
          fieldIndex: fieldIndex,
        );
        break; // Only show one modal at a time
      }
    }
    update();
  }

  /// Maps field keys to their stepper index for navigation
  int _getFieldIndex(String key, int defaultIndex) {
    switch (key) {
      case 'laborFullTime':
      case 'laborCasual':
        return 2;
      case 'fuelAndOils':
        return 3;
      case 'repairsAndMaintenance':
        return 4;
      case 'otherExpenses':
        return 5;
      default:
        return defaultIndex;
    }
  }

  Future<T?> showBestPracticeModal<T>({
    required BuildContext context,
    required String field,
    required int fieldIndex,
    required String minValue,
    required String maxValue,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BestPracticeModal(
          title: 'Value Outside Best Practices'.tr,
          message: 'The'.tr +
              camelCaseToSpacedWords(field).tr +
              'you entered is outside the recommended range. This may affect your cost calculations and profit estimates.'
                  .tr,
          recommendedRanges: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  'Recommended Range:'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(Icons.circle, size: 4, color: Colors.black54),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(
                    text: '  ${camelCaseToSpacedWords(field).tr}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF717680),
                    ),
                  ),
                  TextSpan(
                    text: 'ETB $minValue to ETB $maxValue',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF252B37),
                    ),
                  ),
                  // TextSpan(
                  //   text: ' per ${selectedUnit.value}',
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 12,
                  //     color: Color(0xFF717680),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
          tip:
              'Double-check your input and ensure it aligns with industry best practices for better results.'
                  .tr,
          onContinue: () {
            // Mark field as overridden and clear alert
            fieldAlerts[field] = false;
            overriddenFieldAlerts[field] = true;

            // Pop the modal first
            Navigator.pop(context);

            // Re-validate to update fieldAlerts state
            validateCostPercentages(context);

            // Wait a frame if needed for GetX reactivity to settle
            Future.delayed(const Duration(milliseconds: 50), () {
              final remaining =
                  fieldAlerts.entries.where((e) => e.value).length;

              if (remaining == 0) {
                isBestPractice = false;

                Get.offNamed<void>(
                  AppRoutes.RESULTSOVERVIEWVIEW,
                  arguments: {
                    'type': ResultsOverviewType.advanced,
                    'advancedCalcData': currentEntry,
                    'breakEvenPrice': currentBreakEvenPrice,
                    'isBestPractice': isBestPractice,
                    'jutBagTotal': jutBagTotal,
                    'variableCostTotal': variableCostTotal,
                  },
                );
              } else {
                update();
              }
            });

            // handle continue
          },
          onEdit: () {
            currentStep.value = fieldIndex;
            goTo(currentStep.value);

            update();
            Navigator.pop(context);
          },
        ),
      );

  void showFieldRangeWarning({
    required BuildContext context,
    required String fieldKey,
    required int fieldIndex,
  }) {
    final range = CalcuationConstants.fieldRanges[fieldKey];
    if (range == null) return;

    final total = totalCost.value;
    final minPrice = (total * (range.min / 100)).toStringAsFixed(2);
    final maxPrice = (total * (range.max / 100)).toStringAsFixed(2);

    showBestPracticeModal<void>(
      context: context,
      field: fieldKey,
      fieldIndex: fieldIndex,
      minValue: minPrice,
      maxValue: maxPrice,
    );
  }

  void onCalculate(BuildContext context) {
    validateCostPercentages(context);
    final remainingIssues = fieldAlerts.entries.where((e) => e.value).length;
    if (remainingIssues == 0) {
      Get.offNamed<void>(
        AppRoutes.RESULTSOVERVIEWVIEW,
        arguments: {
          'type': ResultsOverviewType.advanced,
          'advancedCalcData': currentEntry,
          'breakEvenPrice': currentBreakEvenPrice,
          'isBestPractice': isBestPractice,
          'jutBagTotal': jutBagTotal,
          'variableCostTotal': variableCostTotal,
        },
      );
    }
  }

  List<Map<String, String>> mapExtras(
    List<TextEditingController> controllers,
    List<String> labels,
  ) =>
      List.generate(controllers.length, (i) {
        final key = i < labels.length ? labels[i] : 'extra_$i';
        return {key: controllers[i].text};
      });

  /// Returns the current entry as an AdvancedCalculationModel, aggregating all user input and calculated values.
  AdvancedCalculationModel get currentEntry => AdvancedCalculationModel(
        cherryPurchase: cherryPurchaseController.text,
        seasonalCoffee: seasonalCoffeeController.text,
        secondPayment: secondPaymentController.text,
        lowGradeHulling: lowGradeHullingController.text,
        juteBagPrice: juteBagPriceController.text,
        juteBagVolume: selectedJuteBagVolume.text,
        ratio: ratioController.text,
        procurementExtras: procurumentExpenseLabeledExtras
            .map((e) => {e.label: e.controller.text})
            .toList(),
        transportCost: transportCostController.text,
        commission: commissionController.text,
        transportExtras: transportAndCommissionExtras
            .map((e) => {e.label: e.controller.text})
            .toList(),
        casualLabour: casualController.text,
        permanentLabour: permanentController.text,
        overhead: overheadController.text,
        otherLabour: otherController.text,
        fuelCost: fuelCostController.text,
        fuelExtras:
            fuelsExtras.map((e) => {e.label: e.controller.text}).toList(),
        utilities: utilitiesController.text,
        annualMaintenance: annualMaintenanceController.text,
        dryingBed: dryingBedController.text,
        sparePart: sparePartController.text,
        maintenanceExtras: maintenanceEquipmentCostExtras
            .map((e) => {e.label: e.controller.text})
            .toList(),
        otherExpenses: otherExpensesController.text,
        otherExtras: otherExpensesExtras
            .map((e) => {e.label: e.controller.text})
            .toList(),
        procurementTotal: procurumentExpenseTotal.value,
        transportTotal: transportAndCommissionTotal.value,
        casualTotal: labourCasualTotal.value,
        permanentTotal: labourFullTimeTotal.value,
        fuelTotal: fuelsTotal.value,
        maintenanceTotal: maintenanceEquipmentCostTotal.value,
        otherTotal: otherExpensesTotal.value,
        jutBagTotal: jutBagTotal,
        variableCostTotal: variableTotal / variableCostTotal,
        sellingType: selectedCoffeesellingType.value ?? '',
      );

  /// Calculates the break-even price for the advanced calculation.
  /// Formula: (variableTotal + fixedCostTotal) / variableCostTotal
  double get currentBreakEvenPrice =>
      (variableTotal + fixedCostTotal) / variableCostTotal;

  /// Calculates the total variable cost (used in break-even and other calculations).
  /// Formula: greenPriceVolume / 17
  double get variableCostTotal {
    final double value = greenPriceVolume / 17;
    return value;
  }

  /// Calculates the green price volume (cherry price * ratio)
  double get greenPriceVolume {
    final cherryPrice = _parseDouble(cherryPurchaseController.text);
    final ratio = _parseDouble(ratioController.text);
    return cherryPrice * ratio;
  }

  /// Sums all variable cost categories
  double get variableTotal =>
      procurumentExpenseTotal.value +
      transportAndCommissionTotal.value +
      labourCasualTotal.value +
      fuelsTotal.value +
      otherExpensesTotal.value;

  /// Sums all fixed cost categories
  double get fixedCostTotal =>
      labourFullTimeTotal.value + maintenanceEquipmentCostTotal.value;

  /// Calculates the total jute bag cost
  /// Formula: (cherryPurchase / selectedJuteBagVolume) * juteBagPrice
  double get jutBagTotal {
    final value = _parseDouble(cherryPurchaseController.text) /
        _parseDouble(selectedJuteBagVolume.text);
    return value * _parseDouble(juteBagPriceController.text);
  }

// Helper method for safe parsing
  double _parseDouble(String input) => double.tryParse(input) ?? 0.0;

  void disposeControllers() {
    // Dispose procurement controllers
    for (final labeled in procurumentExpenseLabeledExtras) {
      labeled.controller.dispose();
    }

    cherryPurchaseController.dispose();
    seasonalCoffeeController.dispose();
    secondPaymentController.dispose();
    lowGradeHullingController.dispose();
    juteBagPriceController.dispose();
    ratioController.dispose();

    //dispose transport and commission controlles

    for (final labeled in transportAndCommissionExtras) {
      labeled.controller.dispose();
    }

    transportCostController.dispose();
    commissionController.dispose();

    //dispose labour controllers
    casualController.dispose();
    permanentController.dispose();
    otherController.dispose();

    //dispose fuel controllers
    for (final labeled in fuelsExtras) {
      labeled.controller.dispose();
    }
    fuelCostController.dispose();

    //dispose maintenance controllers
    for (final labeled in maintenanceEquipmentCostExtras) {
      labeled.controller.dispose();
    }
    utilitiesController.dispose();
    annualMaintenanceController.dispose();
    dryingBedController.dispose();
    sparePartController.dispose();

    //dispose other expense
    for (final labeled in otherExpensesExtras) {
      labeled.controller.dispose();
    }
    otherExpensesController.dispose();
  }

  void validateAllLabels() {
    final extras = procurumentExpenseLabeledExtras;

    for (final item in extras) {
      final duplicates =
          extras.where((e) => e.label == item.label && e != item).toList();

      item.hasDuplicateError = duplicates.isNotEmpty;
      item.errorText = item.hasDuplicateError ? 'Label must be unique' : null;
    }
  }

  @override
  void onClose() {
    disposeControllers();
    super.dispose();
  }
}
