import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:get/get.dart';

/// Returns a widget for displaying bottom axis titles in a chart.
Widget bottomTitleWidgets(double value, TitleMeta meta) {
  final controller = Get.find<StockController>();
  final labels = controller.chartData
      .map(
        (data) => data['day'] ?? data['time'] ?? data['week'] ?? data['month'],
      )
      .whereType<String>()
      .toList();

  const style = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  Widget text;
  if (value.toInt() < labels.length) {
    text = Text(labels[value.toInt()], style: style);
  } else {
    text = const Text('', style: style);
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8,
    child: text,
  );
}
