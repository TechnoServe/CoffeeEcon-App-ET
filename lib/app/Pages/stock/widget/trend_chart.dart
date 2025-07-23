import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:flutter_template/app/Pages/stock/widget/bottom_title_widgets.dart';
import 'package:get/get.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockController>();
    return SizedBox(
      height: 281,
      child: Obx(
        () => LineChart(
          LineChartData(
            maxX: (controller.chartData.length - 1).toDouble(),
            minX: 0,
            maxY: 1500,
            minY: 0,
            gridData:  FlGridData(
              show: true,
              horizontalInterval: 250,
              drawVerticalLine: true,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) => const FlLine(
                  color: Color(0xFFF5F5F5),
                  strokeWidth: 1,
                ),
              getDrawingVerticalLine: (value) => const FlLine(
                  color: Color(0xFFF5F5F5),
                  strokeWidth: 1,
                ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets,
              ),),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 250,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),),
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: controller.chartData
                    .map((e) => FlSpot(
                        controller.chartData.indexOf(e).toDouble(),
                        e['price']! as double,),)
                    .toList(),
                isCurved: true,
                color: Colors.teal.shade300,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false, // make it true if you want to show dots
                  getDotPainter: (spot, percent, bar, idx) =>
                      FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.teal.shade300,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF00B3B0).withOpacity(0.4),
                      const Color(0xFF00B3B0).withOpacity(0.0),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
