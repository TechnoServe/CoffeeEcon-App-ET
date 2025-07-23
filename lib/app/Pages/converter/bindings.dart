import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:get/get.dart';

class ConverterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(HistoryController.new, fenix: true);
    Get.lazyPut<ConverterController>(
      ConverterController.new,
    );
  }
}
