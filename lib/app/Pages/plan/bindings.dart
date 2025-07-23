import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:get/get.dart';

class PlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanController>(PlanController.new);
  }
}
