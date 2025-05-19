import 'package:flutter_template/app/Pages/auth/controllers/home_controllers.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(AuthController.new);
    Get.lazyPut<HomeControllers>(HomeControllers.new);
    Get.lazyPut<CalculatorController>(CalculatorController.new);
  }
}
