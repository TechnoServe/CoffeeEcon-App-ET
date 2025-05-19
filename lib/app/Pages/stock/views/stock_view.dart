import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';

import 'package:flutter_template/app/shared/widgets/coming_soon.dart';
import 'package:get/get.dart';

class StockView extends GetView<StockController> {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StockController());
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _StockBody(),
    );
  }
}

// Body Widget
class _StockBody extends StatelessWidget {
  const _StockBody();

  bool get hasConnection => true;

  @override
  Widget build(BuildContext context) => const Center(child: ComingSoon());
}
