import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
    this.isBold = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF252B37),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            'ETB $value',
            style: TextStyle(
              fontSize: 12,
              color: valueColor ?? const Color(0xFF23262F),
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      );
}
