import 'package:flutter_template/app/Pages/auth/controllers/home_controllers.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/main/controllers/nav_controller.dart';
import 'package:get/get.dart';

class MainViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(NavController.new);
    Get.lazyPut<HomeControllers>(HomeControllers.new);
    Get.lazyPut<CalculatorController>(CalculatorController.new);
  }
}
