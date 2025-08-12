import 'package:flutter/material.dart';
import 'package:flutter_template/app/shared/controllers/exchange_rate_controller.dart';
import 'package:get/get.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
    this.showCurrency = true,
    this.isBold = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool showCurrency;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final exchangeController = Get.find<ExchangeRateController>();

    return Row(
      children: [
        Expanded(
          child: Text(
            label.tr,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF252B37),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          showCurrency
              ? '${exchangeController.selectedCurrency.value.tr} $value'
              : value,
          style: TextStyle(
            fontSize: 12,
            color: valueColor ?? const Color(0xFF23262F),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
