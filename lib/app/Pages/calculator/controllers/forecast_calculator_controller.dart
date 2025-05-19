import 'package:flutter/material.dart';
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
  final Map<String, double> conversionFactors = {
    'Parchment': 0.2,
    'Dried pod/Jenfel': 0.12,
  };
  final formKey = GlobalKey<FormState>();
  final List<String> coffeeTypes = [
    'Parchment',
    'Dried pod/Jenfel',
  ];
  final selectedUnit = 'Feresula'.obs;

  //intialize the controllers
  final TextEditingController priceController = TextEditingController();
  final TextEditingController otherExpensesController = TextEditingController();
  final selectedCoffeeType = RxnString();
  final RxBool autoValidate = false.obs;

  // Outputs
  double? costOfCherriesPerKg;
  double? marketPrice;

  void onCalculate() {
    final priceInput =
        double.tryParse(priceController.text.replaceAll(',', ''));
    final otherExpensesInput =
        double.tryParse(otherExpensesController.text.replaceAll(',', ''));
    final coffeeType = selectedCoffeeType.value;

    if (priceInput == null ||
        otherExpensesInput == null ||
        coffeeType == null) {
      return;
    }

    final conversionFactor = conversionFactors[coffeeType];
    if (conversionFactor == null || conversionFactor == 0.0) {
      return;
    }

    marketPrice = priceInput;

    costOfCherriesPerKg =
        (marketPrice! - otherExpensesInput) / conversionFactor;

    final totalMarketPrice = costOfCherriesPerKg! + otherExpensesInput;

    Get.toNamed<void>(
      AppRoutes.RESULTSOVERVIEWVIEW,
      arguments: {
        'type': ResultsOverviewType.forecast,
        'totalMarketPrice': totalMarketPrice,
        'cherryPrice': costOfCherriesPerKg,
        'isBestPractice': true,
      },
    );
  }
}
