import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ForecastCalculatorController extends GetxController {
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


   */
  // Conversion factors relative to cherry
  // These represent how many kilograms of cherry are equivalent to 1 kilogram of the given coffee type.
  // For example, 1 kg of Parchment is equivalent to 5 kg of cherry.
  final Map<String, double> conversionFactors = {
    'Parchment': 5,
    'Dried pod/Jenfel': 5,
  };
  final formKey = GlobalKey<FormState>();
  final List<String> coffeeTypes = [
    'Parchment',
    'Dried pod/Jenfel',
  ];
  final selectedUnit = 'Feresula'.obs;

  // Initialize the controllers for form fields
  final TextEditingController priceController =
      TextEditingController(); // For inputting price per unit
  final TextEditingController coffeeVolume =
      TextEditingController(); // For inputting coffee volume
  final TextEditingController otherExpensesController =
      TextEditingController(); // For inputting other expenses
  final selectedCoffeeType = RxnString(); // Observable for selected coffee type
  final RxBool autoValidate =
      false.obs; // Observable for form auto-validation state

  // Outputs
  // The calculated cost of cherries per kg (intermediate value)
  double? volumeOfCherry;
  // The final calculated total market price
  double? totalMarketPrice;

  /// Performs the forecast calculation based on user input.
  ///
  /// Calculation steps:
  /// 1. Parse user inputs: price, other expenses, coffee volume, and selected coffee type.
  /// 2. Validate all required inputs are present and valid.
  /// 3. Retrieve the conversion factor for the selected coffee type.
  /// 4. Calculate the total equivalent cherry volume: coffee volume * conversion factor.
  /// 5. Calculate total revenue: price per unit * coffee volume.
  /// 6. Subtract other expenses from total revenue to get net revenue.
  /// 7. Calculate the total market price per kg cherry: net revenue / total cherry volume.
  /// 8. Navigate to the results overview page, passing the calculated values as arguments.
  void onCalculate() {
    // Parse the price input, removing any commas
    final priceInput =
        double.tryParse(priceController.text.replaceAll(',', ''));
    // Parse the other expenses input, removing any commas
    final otherExpensesInput =
        double.tryParse(otherExpensesController.text.replaceAll(',', ''));
    // Parse the coffee volume input, removing any commas
    final coffeeVolumeInput =
        double.tryParse(coffeeVolume.text.replaceAll(',', ''));
    // Get the selected coffee type
    final coffeeType = selectedCoffeeType.value;

    // Validate that all required inputs are present and valid
    if (priceInput == null ||
        otherExpensesInput == null ||
        coffeeVolumeInput == null ||
        coffeeType == null) {
      return;
    }

    // Retrieve the conversion factor for the selected coffee type
    final conversionFactor = conversionFactors[coffeeType];
    if (conversionFactor == null || conversionFactor == 0.0) {
      return;
    }

    // Step 4: Calculate the total equivalent cherry volume
    // (How many kg of cherry are needed for the given coffee volume)
    volumeOfCherry = coffeeVolumeInput * conversionFactor;

    // Step 5: convert the input

    final convertedPriceInput =
        priceInput / CalcuationConstants.unitToKg[selectedUnit.value]!;
    final convertedCoffeeVolumeInput =
        coffeeVolumeInput * CalcuationConstants.unitToKg[selectedUnit.value]!;

    // Step 6: Calculate total revenue
    final totalRevenue = convertedPriceInput * convertedCoffeeVolumeInput;

    // Step 7: Subtract other expenses to get net revenue
    final totalOtherExpenseOutput = totalRevenue - otherExpensesInput;

    // Step 8: Calculate the total market price per kg cherry
    totalMarketPrice = totalOtherExpenseOutput / (volumeOfCherry ?? 0);

    // Step 9: Navigate to the results overview page, passing the calculated values
    Get.toNamed<void>(
      AppRoutes.RESULTSOVERVIEWVIEW,
      arguments: {
        'type': ResultsOverviewType.forecast,
        'totalMarketPrice': totalMarketPrice,
        'cherryPrice': totalMarketPrice,
        'selectedUnit': selectedUnit.value,
        'isBestPractice': true,
        'selectedCoffeeType': selectedCoffeeType.value
      },
    );
  }
}
