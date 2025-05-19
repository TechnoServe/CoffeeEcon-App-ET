import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:get/get.dart';

class StockBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockController>(StockController.new);
  }
}
