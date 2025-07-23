import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_dropdown.dart';
import 'package:flutter_template/app/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';

class OnboardingSiteRegistrationView extends GetView<SiteController> {
  OnboardingSiteRegistrationView({super.key});
  @override
  final controller = Get.find<SiteController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(
          () => Form(
            key: _formKey,
            autovalidateMode: controller.onBoardingAutoValidator.value
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Stack(
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
                      padding: const EdgeInsets.only(
                        left: AppSizes.pageHorizontalPadding,
                        right: AppSizes.pageHorizontalPadding,
                        bottom: AppSizes.pageVerticaladding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: GestureDetector(
                                onTap: () =>
                                    Get.offAllNamed<void>(AppRoutes.MAINVIEW),
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
                            'Do You Have a Wet Mill Site'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.textWhite100),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your name to personalize your experience'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.5),
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: controller.siteNameController,
                            label: 'Coffee Washing Station',
                            hintText: 'Name',
                            useDarkTextField: false,
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => AppDropdown(
                              label: 'Location',
                              hintText: 'Select Location',
                              hintTextColor:
                                  AppColors.textWhite100.withOpacity(0.4),
                              useTextFieldStyle: true,
                              value: controller.locationValue.value,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              useDarkDropDown: false,
                              items: DropdownData.locations,
                              isForOnboarding: true,
                              onChanged: (value) {
                                controller.locationValue.value = value;
                                controller.locationController.text =
                                    value ?? '';
                              },
                              dropDownIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textWhite100,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => AppDropdown(
                              useTextFieldStyle: true,
                              label: 'Bussiness Model',
                              hintText: 'Select Model',
                              items: DropdownData.businessModels,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              value: controller.businessValue.value,
                              useDarkDropDown: false,
                              isForOnboarding: true,
                              onChanged: (value) {
                                controller.businessValue.value = value;
                                controller.businessModelController.text =
                                    value ?? '';
                              },
                              hintTextColor:
                                  AppColors.textWhite100.withOpacity(0.4),
                              dropDownIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textWhite100,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            onPressed: () {
                              controller.onBoardingAutoValidator.value = true;

                              if (_formKey.currentState!.validate()) {
                                Get.toNamed<void>(
                                  AppRoutes.SITEREGISTRATION,
                                  arguments: {
                                    'site': null,
                                    'onBoardingSiteData': OnboardingSiteData(
                                      siteName:
                                          controller.siteNameController.text,
                                      locationValue:
                                          controller.locationValue.value ?? '',
                                      businessModelValue:
                                          controller.businessValue.value ?? '',
                                    ),
                                  },
                                );
                              }
                            },
                            text: 'Add Site',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
