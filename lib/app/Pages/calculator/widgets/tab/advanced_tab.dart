import 'package:flutter/material.dart';

import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/shared/widgets/coming_soon.dart';

class AdvancedTab extends StatelessWidget {
  const AdvancedTab({
    super.key,
    this.initialStep = 0, // 0-based index
    this.totalSteps = 6,
    this.entry,
  });

  final AdvancedCalculationModel? entry;

  final int initialStep;
  final int totalSteps;
  @override
  Widget build(BuildContext context) => const Center(
        child: ComingSoon(),
      );
}
