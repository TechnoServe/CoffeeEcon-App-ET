import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(AppAssets.coffeeAnimation),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Coming soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.textBlack100,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Advanced stock tools and market insights',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      );
}
