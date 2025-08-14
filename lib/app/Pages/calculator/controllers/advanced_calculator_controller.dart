import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/best_practice_modal.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/utils/helpers.dart';
import 'package:get/get.dart';

/// Controller for managing the advanced calculator functionality.
/// This controller handles complex multi-step form validation, cost calculations,
/// dynamic field management, and best practice checks for advanced calculations.
class AdvancedCalculatorController extends GetxController {
  // Procurement expenses data controllers for user input fields
  /// Text controller for cherry purchase amount input.
  final TextEditingController cherryPurchaseController = TextEditingController();
  /// Text controller for seasonal coffee price input.
  final TextEditingController seasonalCoffeeController = TextEditingController();
  /// Text controller for second payment amount input.
  final TextEditingController secondPaymentController = TextEditingController();
  /// Text controller for low grade hulling cost input.
  final TextEditingController lowGradeHullingController = TextEditingController();
  /// Text controller for jute bag price input.
  final TextEditingController juteBagPriceController = TextEditingController();
  /// Text controller for ratio calculation input.
  final TextEditingController ratioController = TextEditingController();
  /// Text controller for selected jute bag volume input.
  final TextEditingController selectedJuteBagVolume = TextEditingController();

  /// Observable selected coffee selling type (e.g., Parchment, Green Coffee, etc.).
  final selectedCoffeesellingType = RxnString();
  
  /// List of extra procurement expense fields (dynamic) with labeled controllers.
  List<LabeledController> procurumentExpenseLabeledExtras = [];
  /// List of extra procurement expense UI widgets.
  List<Widget> procurumentExpenseExtraFields = [];

  // Validation and total for procurement expenses
  /// Observable flag for procurement expense form auto-validation.
  final RxBool procurumentExpenseAutoValidate = false.obs;
  /// Observable total cost for procurement expenses.
  final RxDouble procurumentExpenseTotal = 0.0.obs;

  /////////////////////////////////////////////////////////////////

  // Transportation and commission data controllers
  /// Text controller for transport cost input.
  final TextEditingController transportCostController = TextEditingController();
  /// Text controller for commission amount input.
  final TextEditingController commissionController = TextEditingController();
  /// List of extra transportation and commission UI widgets.
  List<Widget> transportAndCommissionExtraFields = [];
  /// List of extra transportation and commission labeled controllers.
  List<LabeledController> transportAndCommissionExtras = [];
  /// Observable flag for transport and commission form auto-validation.
  final RxBool transportAndCommissionAutoValidate = false.obs;
  /// Observable total cost for transportation and commission.
  final RxDouble transportAndCommissionTotal = 0.0.obs;

  ///////////////////////////////

  // Labour cost controllers
  /// Text controller for casual labor cost input.
  final TextEditingController casualController = TextEditingController();
  /// Text controller for other labor cost input.
  final TextEditingController otherController = TextEditingController();
  /// Text controller for permanent labor cost input.
  final TextEditingController permanentController = TextEditingController();
  /// Text controller for overhead cost input.
  final TextEditingController overheadController = TextEditingController();

  /// Observable flag for labor cost form auto-validation.
  final RxBool labourCostAutoValidate = false.obs;
  /// Observable total cost for full-time labor.
  final RxDouble labourFullTimeTotal = 0.0.obs;
  /// Observable total cost for casual labor.
  final RxDouble labourCasualTotal = 0.0.obs;
  /////////////////////////////////////////////////////////////////

  // Fuels and oils controllers
  /// Text controller for fuel cost input.
  final TextEditingController fuelCostController = TextEditingController();
  /// List of extra fuel and oils UI widgets.
  List<Widget> fuelsExtraFields = [];
  /// List of extra fuel and oils labeled controllers.
  List<LabeledController> fuelsExtras = [];
  /// Observable flag for fuels form auto-validation.
  final RxBool fuelsAutoValidate = false.obs;
  /// Observable total cost for fuels and oils.
  final RxDouble fuelsTotal = 0.0.obs;

  ///////////////////////////////

  // Maintenance Equipment controllers
  /// Text controller for utilities cost input.
  final TextEditingController utilitiesController = TextEditingController();
  /// Text controller for annual maintenance cost input.
  final TextEditingController annualMaintenanceController = TextEditingController();
  /// Text controller for drying bed cost input.
  final TextEditingController dryingBedController = TextEditingController();
  /// Text controller for spare parts cost input.
  final TextEditingController sparePartController = TextEditingController();
  /// List of extra maintenance equipment UI widgets.
  List<Widget> maintenanceEquipmentCostExtraFields = [];
  /// List of extra maintenance equipment labeled controllers.
  List<LabeledController> maintenanceEquipmentCostExtras = [];
  /// Observable flag for maintenance equipment form auto-validation.
  final RxBool maintenanceEquipmentCostAutoValidate = false.obs;
  /// Observable total cost for maintenance equipment.
  final RxDouble maintenanceEquipmentCostTotal = 0.0.obs;

  // Other expenses controllers
  /// Text controller for other expenses input.
  final TextEditingController otherExpensesController = TextEditingController();
  /// List of extra other expenses UI widgets.
  List<Widget> otherExpensesExtraFields = [];
  /// List of extra other expenses labeled controllers.
  List<LabeledController> otherExpensesExtras = [];
  /// Observable flag for other expenses form auto-validation.
  final RxBool otherExpensesAutoValidate = false.obs;
  /// Observable total cost for other expenses.
  final RxDouble otherExpensesTotal = 0.0.obs;

  ///////////////////////////////
  /// Map to track fields where user has chosen to continue despite warnings.
  /// Used for "continue anyway" functionality when values are outside best practices.
  final Map<String, bool> overriddenFieldAlerts = {
    'seasonalPrice': false,
    'cherryTransport': false,
    'laborFullTime': false,
    'laborCasual': false,
    'fuelAndOils': false,
    'repairsAndMaintenance': false,
    'otherExpenses': false,
  };

  /// Available coffee types for selection.
  final coffeeTypes = [
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  /// Observable selected unit for calculations (default: KG).
  final selectedUnit = 'KG'.obs;

  /// Observable total cost result (sum of all cost categories).
  final totalCost = 0.0.obs;

  // Stepper logic for multi-step form
  /// Observable current step in the multi-step form.
  RxInt currentStep = 0.obs;
  /// Observable map to track field validation alerts.
  final fieldAlerts = <String, bool>{}.obs;
  /// Flag indicating if the calculation follows best practices.
  bool isBestPractice = true;

  /// Total number of steps in the advanced calculator form.
  final int totalSteps = 6; // Or pass this as a parameter
  
   bool skipBestPracticeWarning = false;


  /// Navigation method to go to the next step in the stepper.
  void goNext() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  /// Navigation method to go to the previous step in the stepper.
  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  /// Navigation method to go to a specific step by index.
  /// 
  /// [index] - The step index to navigate to
  void goTo(int index) {
    if (index >= 0 && index < totalSteps) {
      currentStep.value = index;
    }
  }

  /// Patches the controller fields with data from an AdvancedCalculationModel.
  /// This method is used when editing a previously saved advanced calculation.
  /// 
  /// [data] - The previous calculation data to load
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

    // Set calculated totals
    procurumentExpenseTotal.value = data.procurementTotal;
    transportAndCommissionTotal.value = data.transportTotal;
    labourCasualTotal.value = data.casualTotal;
    labourFullTimeTotal.value = data.permanentTotal;
    fuelsTotal.value = data.fuelTotal;
    maintenanceEquipmentCostTotal.value = data.maintenanceTotal;
    otherExpensesTotal.value = data.otherTotal;
    selectedCoffeesellingType.value = data.sellingType;

    // Patch extra fields for each category
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

  /// Helper method to patch additional labeled fields from saved data.
  /// This method creates controllers and widgets for dynamic fields based on saved extras.
  /// 
  /// [extras] - List of extra field data from saved calculation
  /// [controllerList] - List to store the labeled controllers
  /// [fieldList] - List to store the UI widgets
  /// [hintText] - Hint text for the input fields
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
  /// This method iterates through all procurement-related controllers and sums their values.
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
  /// This method sums the transport cost, commission, and any extra fields.
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
  /// This method separates casual labor (casual + other) from permanent labor (permanent + overhead).
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
  /// This method sums the main fuel cost and any extra fuel-related fields.
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
  /// This method sums all maintenance-related costs including utilities, annual maintenance,
  /// drying bed, spare parts, and any extra fields.
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
  /// This method sums the main other expenses field and any extra other expense fields.
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
  /// This method checks if each cost category falls within industry best practice ranges.
  /// 
  /// [context] - The build context for showing modals
  void validateCostPercentages(BuildContext context) {
    // Map of cost categories to their total values
    final Map<String, double> values = {
      'seasonalPrice': procurumentExpenseTotal.value,
      'cherryTransport': transportAndCommissionTotal.value,
      'laborFullTime': labourFullTimeTotal.value,
      'laborCasual': labourCasualTotal.value,
      'fuelAndOils': fuelsTotal.value,
      'repairsAndMaintenance': maintenanceEquipmentCostTotal.value,
      'otherExpenses': otherExpensesTotal.value,
    };
    // Calculate total cost from all categories
    final total = values.values.fold(0.0, (a, b) => a + b);
    totalCost.value = total;
    final entries = values.entries.toList();
    
    // Check each category against recommended ranges
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
        // Determine fieldIndex based on key for stepper navigation
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

  /// Maps field keys to their stepper index for navigation.
  /// This method helps navigate to the correct step when showing validation warnings.
  /// 
  /// [key] - The field key to map
  /// [defaultIndex] - The default index if no specific mapping exists
  /// Returns the appropriate step index for the field
  int _getFieldIndex(String key, int defaultIndex) {
    switch (key) {
      case 'laborFullTime':
      case 'laborCasual':
        return 2; // Labor step
      case 'fuelAndOils':
        return 3; // Fuels step
      case 'repairsAndMaintenance':
        return 4; // Maintenance step
      case 'otherExpenses':
        return 5; // Other expenses step
      default:
        return defaultIndex;
    }
  }

  /// Shows a modal dialog for best practice warnings.
  /// This method displays a bottom sheet when field values are outside
  /// recommended ranges, allowing users to continue or edit.
  /// 
  /// [context] - The build context for showing the modal
  /// [field] - The field name that triggered the warning
  /// [fieldIndex] - The step index to navigate to when editing
  /// [minValue] - The minimum recommended value
  /// [maxValue] - The maximum recommended value
  /// Returns a Future with the modal result
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
           if(!skipBestPracticeWarning)  validateCostPercentages(context);

            // Wait a frame if needed for GetX reactivity to settle
            Future.delayed(const Duration(milliseconds: 50), () {
              final remaining =
                  fieldAlerts.entries.where((e) => e.value).length;

              if (skipBestPracticeWarning || remaining == 0) {
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
          },
          onEdit: () {
            // Navigate to the specific step for editing
            currentStep.value = fieldIndex;
            goTo(currentStep.value);

            update();
            Navigator.pop(context);
          },
        ),
      );

  /// Shows field range warning modal for a specific field.
  /// This method calculates the recommended range based on total cost
  /// and displays the best practice modal.
  /// 
  /// [context] - The build context for showing the modal
  /// [fieldKey] - The field key to show warning for
  /// [fieldIndex] - The step index to navigate to when editing
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

  /// Initiates the calculation process and navigates to results if validation passes.
  /// This method validates all cost percentages and proceeds to results only if
  /// all validation issues are resolved.
  /// 
  /// [context] - The build context for showing modals
  void onCalculate(BuildContext context) {
     if(!skipBestPracticeWarning) validateCostPercentages(context);
    final remainingIssues = fieldAlerts.entries.where((e) => e.value).length;
    if (skipBestPracticeWarning || remainingIssues == 0) {
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

  /// Maps extra controllers to their labels for data persistence.
  /// This helper method creates a list of maps with label-value pairs.
  /// 
  /// [controllers] - List of text editing controllers
  /// [labels] - List of corresponding labels
  /// Returns a list of maps with label-value pairs
  List<Map<String, String>> mapExtras(
    List<TextEditingController> controllers,
    List<String> labels,
  ) =>
      List.generate(controllers.length, (i) {
        final key = i < labels.length ? labels[i] : 'extra_$i';
        return {key: controllers[i].text};
      });

  /// Returns the current entry as an AdvancedCalculationModel, aggregating all user input and calculated values.
  /// This getter creates a complete model with all form data, calculated totals, and extra fields.
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
        variableCostTotal: getTotalExpenses,
        sellingType: selectedCoffeesellingType.value ?? '',
      );

  /// Calculates the break-even price for the advanced calculation.
  /// Formula: (variableTotal + fixedCostTotal) / variableCostTotal
  /// This represents the price per unit needed to cover all costs.
  double get currentBreakEvenPrice =>
      (variableTotal + fixedCostTotal) / variableCostTotal;

  /// Calculates the total variable cost (used in break-even and other calculations).
  /// This represents the variable cost per unit of output.
  double get variableCostTotal {
    final double value = greenPriceVolume;
    return value;
  }

  /// Calculates the green price volume (cherry price * ratio).
  /// This represents the total volume of green coffee produced.
  double get greenPriceVolume {
    final cherryPrice = _parseDouble(cherryPurchaseController.text);
    final ratio = _parseDouble(ratioController.text)/ 100;
    return cherryPrice * ratio;
  }

  /// Sums all variable cost categories.
  /// Variable costs change with production volume.
  double get variableTotal =>
      procurumentExpenseTotal.value +
      transportAndCommissionTotal.value +
      labourCasualTotal.value +
      fuelsTotal.value +
      otherExpensesTotal.value;

  /// Sums all fixed cost categories.
  /// Fixed costs remain constant regardless of production volume.
  double get fixedCostTotal =>
      labourFullTimeTotal.value + maintenanceEquipmentCostTotal.value;

  double get getTotalExpenses => procurumentExpenseTotal.value + transportAndCommissionTotal.value +  labourFullTimeTotal.value + labourCasualTotal.value + fuelsTotal.value + maintenanceEquipmentCostTotal.value + otherExpensesTotal.value;

  /// Calculates the total jute bag cost.
  /// Formula: (cherryPurchase / selectedJuteBagVolume) * juteBagPrice
  /// This represents the cost of jute bags needed for the cherry volume.
  double get jutBagTotal {
    final value = _parseDouble(cherryPurchaseController.text) /
        _parseDouble(selectedJuteBagVolume.text);
    return value * _parseDouble(juteBagPriceController.text);
  }

  /// Helper method for safe parsing of string values to double.
  /// Returns 0.0 if parsing fails, preventing null pointer exceptions.
  /// 
  /// [input] - The string input to parse
  /// Returns the parsed double value or 0.0 if parsing fails
  double _parseDouble(String input) => double.tryParse(input) ?? 0.0;

  /// Disposes all text controllers to prevent memory leaks.
  /// This method should be called when the controller is no longer needed.
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

    // Dispose transport and commission controllers
    for (final labeled in transportAndCommissionExtras) {
      labeled.controller.dispose();
    }

    transportCostController.dispose();
    commissionController.dispose();

    // Dispose labour controllers
    casualController.dispose();
    permanentController.dispose();
    otherController.dispose();

    // Dispose fuel controllers
    for (final labeled in fuelsExtras) {
      labeled.controller.dispose();
    }
    fuelCostController.dispose();

    // Dispose maintenance controllers
    for (final labeled in maintenanceEquipmentCostExtras) {
      labeled.controller.dispose();
    }
    utilitiesController.dispose();
    annualMaintenanceController.dispose();
    dryingBedController.dispose();
    sparePartController.dispose();

    // Dispose other expense controllers
    for (final labeled in otherExpensesExtras) {
      labeled.controller.dispose();
    }
    otherExpensesController.dispose();
  }

  /// Validates that all dynamic field labels are unique.
  /// This method checks for duplicate labels in the procurement expense extras
  /// and sets error states accordingly.
  void validateAllLabels() {
    final extras = procurumentExpenseLabeledExtras;

    for (final item in extras) {
      final duplicates =
          extras.where((e) => e.label == item.label && e != item).toList();

      item.hasDuplicateError = duplicates.isNotEmpty;
      item.errorText = item.hasDuplicateError ? 'Label must be unique' : null;
    }
  }

}
