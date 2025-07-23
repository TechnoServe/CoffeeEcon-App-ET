import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LegendDot extends StatelessWidget {
  const LegendDot({required this.color, required this.label, super.key});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.tr,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF23262F),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
}
