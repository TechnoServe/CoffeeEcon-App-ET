import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';

class AuthView extends GetView<AuthController> {
  AuthView({super.key});
  @override
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Image.asset(
              AppAssets.onboardingOne,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.darken,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.pageHorizontalPadding,
                    vertical: AppSizes.pageVerticaladding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        AppAssets.whiteLogo,
                        height: 100.h,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textWhite100,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome! Let’s Get Started'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.textWhite100),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your name to personalize your experience'.tr,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withOpacity(0.5),
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: controller.fullNameController,
                        label: 'Full Name',
                        hintText: "What's your name",
                        useDarkTextField: false,
                        backgroundColor: const Color(0x1AF5F5F5),
                      ),
                      Obx(() {
                        final error = controller.nameError.value;
                        return error != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  error,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.redAccent,
                                      ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                      const SizedBox(height: 16),
                      AppButton(
                        onPressed: controller.onGetStarted,
                        text: 'Get Started',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
