import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

/// A placeholder widget that displays a "Coming Soon" message with an animation.
/// This widget is used to indicate features that are under development or
/// not yet available in the current version of the application.
class ComingSoon extends StatelessWidget {
  /// Creates a [ComingSoon] widget.
  const ComingSoon({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display coffee animation image as the main visual element
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(AppAssets.coffeeAnimation),
          ),
          const SizedBox(
            height: 16,
          ),
          // Main "Coming Soon" title text
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
          // Subtitle describing the upcoming feature
          Text(
            'Advanced stock tools and market insights',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      );
}
