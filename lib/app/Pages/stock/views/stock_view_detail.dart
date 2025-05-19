import 'package:flutter_template/app/Pages/stock/widget/ecx_card.dart';
import 'package:flutter_template/app/Pages/stock/widget/Trend_chart.dart';
import 'package:flutter_template/app/Pages/stock/widget/stock_app_bar.dart';
import 'package:flutter_template/app/Pages/stock/widget/stocks_grid.dart';
import 'package:flutter_template/app/Pages/stock/widget/time_range_selector.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/stock_controllers.dart';

class StockViewDetail extends StatelessWidget {
  const StockViewDetail({required this.stock, required this.stockName, super.key});
  final Map<String, Object> stock;
  final String stockName;

  @override
  Widget build(BuildContext context) {
    Get.put(StockController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StockAppBar(title: stockName,showBackButton:true,onBack: () => Get.back<void>(), showUnitChip: true),
      body: const _StockBody(),
    );
  }

}
class _StockBody extends StatelessWidget {
  const _StockBody();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SectionTitle(),
            SizedBox(height: 20),
            TrendChart(),
            SizedBox(height: 20),
            TimeRangeSelector(),
            SizedBox(height: 20),
            ECXCard(),
            SizedBox(height: 20),
            StocksGrid(isDetailPage: true),

          ],
        ),
      );
}