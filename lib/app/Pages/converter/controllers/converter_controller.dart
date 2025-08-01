import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:get/get.dart';

class ConverterController extends GetxController {
  final historyCalculator = Get.find<HistoryController>();
  final selectedTab = 0.obs;
  final selectedGrade = RxnString();

  late TextEditingController fromUnitController;
  late TextEditingController fromRatioController;
  late TextEditingController toUnitController;
  late TextEditingController toRatioController;
  late Rx<TextEditingController?> activeController;

  final RxInt selectedFromUnitIndex = 0.obs; // 0=Kg, 1=Quintal, 2=Feresula
  final RxInt selectedToUnitIndex = 0.obs; // 0=Kg, 1=Quintal, 2=Feresula

  final fromCoffeeGrade = Rx<String?>(DropdownData.coffeeGrades[0]);
  final toCoffeeGrade = Rx<String?>(DropdownData.coffeeGrades[1]);

  final fromUnit = Rx<String?>(DropdownData.units[0]);
  final toUnit = Rx<String?>(DropdownData.units[1]);

  Timer? _debounceTimer;

  final RxBool isKeyboardOpen = false.obs;
  bool isUnitFromActive = true;
  bool isRatioFromActive = true;

  /*
  
Ratio to 1 kg cherry    Ratio
Cherry                             1 : 1                          1
Pulped Parchment                   1.8 : 1                     0.55
Wet Parchment                      2.6 : 1                     0.39
Dry Parchment                      5.0 : 1                     0.20
Unsorted Green Coffee              6.3 : 1                     0.16
Export Green                       6.9 : 1                     0.14
           Source: Adapted from TechnoServe (n.d.)       
Additional Conversions
Fresh cherry → Dried pod          4 : 1– 5 : 1
Dried pod → Green coffee          1.25 : 1                       

////////////////////////////////////////////////////////
   'Cherries': 1,
    'Parchment': 0.2,
    'Green Coffee': 0.16,
    'Dried pod/Jenfel': 0.2,

   */
  // Conversion factors relative to cherry
  final Map<String, double> conversionFactors = {
    'Cherries': 1.0,
    'Pulped Parchment': 0.55,
    'Wet Parchment': 0.39,
    'Dry Parchment': 0.20,
    'Unsorted Green Coffee': 0.16,
    'Export Green': 0.14,
    'Dried pod/Jenfel': 0.2,
  };

  String? _fromUnitValue;
  String? _toUnitValue;
  String? _lastInputValue;
  double? _lastResult;
  bool? _lastIsFromUnitConversion;

  @override
  void onInit() {
    super.onInit();
    loadControllers();
    historyCalculator.loadHistory(
      isFromUnitConversion: false,
    );
    //unit
    fromUnitController.addListener(() {
      if (isUnitFromActive) {}
    });

    toUnitController.addListener(() {
      if (!isUnitFromActive) {
        _onUnitInputChanged(toUnitController.text);
      }
    });

    // ratio
    fromRatioController.addListener(() {
      if (isRatioFromActive) {}
    });

    toRatioController.addListener(() {
      if (!isRatioFromActive) {
        _onRatioInputChanged(toRatioController.text);
      }
    });

    //unit
    ever(fromUnit, (_) => _convertUnit(fromTo: isUnitFromActive));
    ever(toUnit, (_) => _convertUnit(fromTo: isUnitFromActive));

    //ratio
    ever(fromCoffeeGrade, (_) => _convertRatio(fromTo: isRatioFromActive));
    ever(toCoffeeGrade, (_) => _convertRatio(fromTo: isRatioFromActive));
  }

  void _onUnitInputChanged(String input) {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();

    // Start a new timer
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      // Perform the conversion and save to history
      _convertUnit(fromTo: isUnitFromActive);
    });
  }

  void _onRatioInputChanged(String input) {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();

    // Start a new timer
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      // Perform the conversion and save to history
      _convertRatio(fromTo: isRatioFromActive);
    });
  }

  void unitConverterOnUnitChange({
    required int oldUnitIndex,
    required int newUnitIndex,
    required TextEditingController controller,
  }) {
    final oldUnit = _getUnitName(oldUnitIndex);
    final newUnit = _getUnitName(newUnitIndex);

    final input = double.tryParse(controller.text);
    if (input == null) return;

    final inKg = input * (DropdownData.unitToKg[oldUnit] ?? 1);
    final result = inKg / (DropdownData.unitToKg[newUnit] ?? 1);
    final resultText = result.toStringAsFixed(2);

    controller.text = resultText;

    isRatioFromActive = controller == fromRatioController;
    // _convertRatio(fromTo: isRatioFromActive);
  }

  void loadControllers() {
    fromUnitController = TextEditingController();
    fromRatioController = TextEditingController();
    toUnitController = TextEditingController();
    toRatioController = TextEditingController();
    activeController = Rx<TextEditingController?>(null);
  }

  // used to convert units e.g from kg to qunital
  void _convertUnit({required bool fromTo}) {
    final source = fromTo ? fromUnitController : toUnitController;
    final target = fromTo ? toUnitController : fromUnitController;
    final sourceUnit = fromTo ? fromUnit.value : toUnit.value;
    final targetUnit = fromTo ? toUnit.value : fromUnit.value;

    if (source.text.isEmpty || sourceUnit == null || targetUnit == null) {
      target.text = '';
      return;
    }

    final input = double.tryParse(source.text);
    if (input == null) {
      target.text = '';
      return;
    }

    final inKg = input * (DropdownData.unitToKg[sourceUnit] ?? 1);
    final result = inKg / (DropdownData.unitToKg[targetUnit] ?? 1);
    final resultText = result.toStringAsFixed(2);
    target.text = resultText;
    // Store the last conversion details
    _fromUnitValue = sourceUnit;
    _toUnitValue = targetUnit;
    _lastInputValue = source.text;
    _lastResult = result;
    _lastIsFromUnitConversion = true;
  }

  // used to convert ratios e.g from cherries to parchement
  void _convertRatio({required bool fromTo}) {
    final source = fromTo ? fromRatioController : toRatioController;
    final target = fromTo ? toRatioController : fromRatioController;
    final sourceCoffeGrade =
        fromTo ? fromCoffeeGrade.value : toCoffeeGrade.value;
    final targetCoffeGrade =
        fromTo ? toCoffeeGrade.value : fromCoffeeGrade.value;

    if (source.text.isEmpty ||
        sourceCoffeGrade == null ||
        targetCoffeGrade == null) {
      target.text = '';
      return;
    }

    final input = double.tryParse(source.text);
    if (input == null) {
      target.text = '';
      return;
    }

    final fromFactor = conversionFactors[fromCoffeeGrade.value] ?? 1.0;
    final toFactor = conversionFactors[toCoffeeGrade.value] ?? 1.0;

    final conversionRate = toFactor / fromFactor;
    final result = input * conversionRate;
    final resultText = result.toStringAsFixed(2);
    // target.text = resultText;
    if (fromTo) {
      if (toRatioController.text != resultText) {
        toRatioController.text = resultText;
        _fromUnitValue = sourceCoffeGrade;
        _toUnitValue = targetCoffeGrade;
        _lastInputValue = source.text;
        _lastResult = result;
        _lastIsFromUnitConversion = false;
      }
    } else {
      if (fromRatioController.text != resultText) {
        fromRatioController.text = resultText;
        _fromUnitValue = sourceCoffeGrade;
        _toUnitValue = targetCoffeGrade;
        _lastInputValue = source.text;
        _lastResult = result;
        _lastIsFromUnitConversion = false;
      }
    }
  }

  // Specific method for fromUnitController
  void onFromInput({required String val, required bool isUnitConverstion}) {
    onNumberInput(
      val,
      controller: isUnitConverstion ? fromUnitController : fromRatioController,
      isUnitConverstion: isUnitConverstion,
    );
  }

  // Specific method for toUnitController
  void onToInput({required String val, required bool isUnitConverstion}) {
    onNumberInput(
      val,
      controller: isUnitConverstion ? toUnitController : toRatioController,
      isUnitConverstion: isUnitConverstion,
    );
  }

  void onNumberInput(
    String input, {
    required TextEditingController controller,
    required bool isUnitConverstion,
  }) {
    if (isUnitConverstion) {
      isUnitFromActive = controller == fromUnitController;
      controller.text += input;
      Future.microtask(() => _convertUnit(fromTo: isUnitFromActive));
    } else {
      isRatioFromActive = controller == fromRatioController;
      controller.text += input;
      Future.microtask(() => _convertRatio(fromTo: isRatioFromActive));
    }
  }

  void clearAmount({
    required TextEditingController controller,
    required bool isUnitConverstion,
  }) {
    if (isUnitConverstion) {
      isUnitFromActive = controller == fromUnitController;
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        Future.microtask(() => _convertUnit(fromTo: isUnitFromActive));
      }
    } else {
      isRatioFromActive = controller == fromRatioController;
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        Future.microtask(() => _convertRatio(fromTo: isRatioFromActive));
      }
    }
  }

  // Specific clear method for fromController
  void clearFromAmount({required bool isUnitConverstion}) {
    clearAmount(
      controller: fromUnitController,
      isUnitConverstion: isUnitConverstion,
    );
  }

  // Specific clear method for toUnitController
  void clearToAmount({required bool isUnitConverstion}) {
    clearAmount(
      controller: toUnitController,
      isUnitConverstion: isUnitConverstion,
    );
  }

  set tab(int index) => selectedTab.value = index;

  set fromUnitIndex(int index) => selectedFromUnitIndex.value = index;

  set toUnitIndex(int index) => selectedToUnitIndex.value = index;

  bool _disposed = false;

  @override
  void onClose() {
    if (!_disposed) {
      _disposeControllers();
      _disposed = true;
    }
    super.onClose();
  }

  void _disposeControllers() {
    fromUnitController.dispose();
    fromRatioController.dispose();
    toUnitController.dispose();
    toRatioController.dispose();

    fromUnitController = TextEditingController();
    fromRatioController = TextEditingController();
    toUnitController = TextEditingController();
    toRatioController = TextEditingController();

    saveLastHistory(isFromUnitConversion: _lastIsFromUnitConversion ?? false);
  }

  // Helper method to clear controllers without disposing
  void clearControllers() {
    fromUnitController.clear();
    fromRatioController.clear();
    toUnitController.clear();
    toRatioController.clear();
    _fromUnitValue = null;
    _toUnitValue = null;
    _lastInputValue = null;
    _lastResult = null;
  }

  void saveLastHistory({required bool isFromUnitConversion}) {
    if (_lastInputValue != null &&
        _lastResult != null &&
        _lastIsFromUnitConversion != null) {
      historyCalculator.saveCalculation(
        fromUnit: _fromUnitValue ?? '',
        toUnit: _toUnitValue ?? '',
        inputValue:
            "${_lastInputValue!} ${selectedFromUnitIndex.value == 0 ? 'kg'.tr : selectedFromUnitIndex.value == 1 ? 'Quintal'.tr : 'Feresula'.tr}",
        result:
            '${_lastResult!.toStringAsFixed(2)} ${selectedToUnitIndex.value == 0 ? 'kg'.tr : selectedToUnitIndex.value == 1 ? 'Quintal'.tr : 'Feresula'.tr}',
        isFromUnitConversion: isFromUnitConversion,
      );
    }
  }

  String _getUnitName(int index) {
    switch (index) {
      case 0:
        return 'Kg';
      case 1:
        return 'Quintal';
      case 2:
        return 'Feresula';
      default:
        return 'Kg';
    }
  }
}
