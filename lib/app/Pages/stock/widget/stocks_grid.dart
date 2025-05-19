import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

class StocksGrid extends StatelessWidget {
  const StocksGrid({super.key, this.isDetailPage = false});
  final bool isDetailPage;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockController>();
    final stocks = controller.coffeeStocks.cast<Map<String, Object>>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Coffee Stocks'.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                ),
                if (isDetailPage) const SizedBox(height: 8),
                if (isDetailPage)
                  Text(
                    'Get real-time coffee prices and trends'.tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
            const Spacer(),
            if (isDetailPage)
              CustomChip(
                label: 'Unit',
                svgPath: 'assets/icons/birr.svg',
                onTap: () {},
                isCurrency: false,
                isRegion: false,
              ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4 / 2,
          children: stocks.map((stock) => _StockTile(stock: stock)).toList(),
        ),
      ],
    );
  }
}

class _StockTile extends StatelessWidget {
  const _StockTile({required this.stock});
  final Map<String, Object> stock;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = stock['isPositive']! as bool;
    final double change = stock['change']! as double;
    final double price = stock['price']! as double;
    return GestureDetector(
      onTap: () {
        Get.toNamed<void>(AppRoutes.STOCKDETAIL,
            arguments: {'stock': stock, 'stockName': stock['name']!},);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5FAFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['name']! as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12,),
                ),
                Text(
                  stock['type']! as String,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,),
                ),
              ],
            ),
            const SizedBox(height: 7.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ETB ${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,),
                ),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : '-'}${(change * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
