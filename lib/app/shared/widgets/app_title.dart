import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({required this.titleName, super.key});
  final String titleName;

  @override
  Widget build(BuildContext context) => Text(
        titleName.tr,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
      );
}
