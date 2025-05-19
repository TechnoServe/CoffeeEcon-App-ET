import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:get/get.dart';

class CalculatorBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalculatorController>(CalculatorController.new);
  }
}
