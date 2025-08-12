import 'package:flutter_template/app/Pages/auth/controllers/home_controllers.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:get/get.dart';

class WetMillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteController>(SiteController.new);
    Get.lazyPut<CalculatorController>(CalculatorController.new);
    Get.lazyPut<PlanController>(PlanController.new);
    Get.lazyPut<HomeControllers>(HomeControllers.new);

  }
}
