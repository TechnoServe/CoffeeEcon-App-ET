import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/Pages/splash/controllers/splash_controller.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets.dart';

/// Splash screen view displayed at app startup.
class SplashView extends GetView<SplashController> {
  /// Creates a [SplashView].
  const SplashView({super.key});

  /// Builds the splash screen UI.
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.splashPadding),
          child: Obx(() {
            final showContent = controller.isLogoVisible.value;

            return Stack(
              children: [
                if (showContent)
                  Center(
                    child: ScaleTransition(
                      scale: controller.scaleAnimation,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          AppAssets.primaryLogo,
                          width: AppSizes.splashLogoWidth.w,
                        ),
                      ),
                    ),
                  ),
                if (showContent)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const text =
                            'This app was developed By TechnoServe In collaboration with U.S Department of Agriculture Food for Progress Regrow Yirga Project Processing Program';

                        final textStyle =
                            Theme.of(context).textTheme.labelMedium!;
                        final span = TextSpan(text: text, style: textStyle);

                        final tp = TextPainter(
                          text: span,
                          textDirection: TextDirection.ltr,
                          maxLines: null,
                        );

                        tp.layout(maxWidth: constraints.maxWidth);
                        final lastLineWidth =
                            tp.computeLineMetrics().last.width;
                        final isLastLineShort =
                            lastLineWidth < constraints.maxWidth * 0.8;

                        return Text(
                          text,
                          textAlign: isLastLineShort
                              ? TextAlign.center
                              : TextAlign.start,
                          style: textStyle,
                        );
                      },
                    ),
                  ),
              ],
            );
          }),
        ),
      );
}
