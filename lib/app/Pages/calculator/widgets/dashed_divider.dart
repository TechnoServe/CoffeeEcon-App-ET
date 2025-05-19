
import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {

  const DashedDivider({
    this.height = 1,
    this.color = const Color(0xFFE6E8EC),
    this.dashWidth = 5,
    this.dashSpace = 3,
    super.key,
  });
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(dashCount, (_) => Container(
              width: dashWidth,
              height: height,
              color: color,
              margin: EdgeInsets.only(right: dashSpace),
            ),),
        );
      },
    );
}


