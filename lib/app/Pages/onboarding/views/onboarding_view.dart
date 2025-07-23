import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/Pages/onboarding/views/widgets/app_dot_indicator.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:transparent_image/transparent_image.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final current = controller.currentPage.value;
        final page = controller.pages[current];

        return Stack(
          children: [
            // Dynamic Background
            FadeInImage(
              key: ValueKey(current),
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage(page.image),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              fadeInDuration: const Duration(milliseconds: 250),
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.darken,
            ),

            // Main UI
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (current != controller.pages.length - 1)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: GestureDetector(
                                onTap: () =>
                                    Get.offAllNamed<void>(AppRoutes.AUTH),
                                child: Text(
                                  'Skip'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textWhite100,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.whiteLogo,
                            width: 150.w,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textWhite100,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.textWhite100),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                      height: 1.5,
                                    ),
                            text: '     ', // 5 spaces as indentation
                            children: [
                              TextSpan(
                                text: page.subTitle.toString().trim().tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                      height: 1.5,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: AppButton(
                            onPressed: controller.nextPage,
                            width: 235,
                            text: current == controller.pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => AppDotIndicator(
                            itemCount: controller.pages.length,
                            currentIndex: controller.currentPage.value,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
