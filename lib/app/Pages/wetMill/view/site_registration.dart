import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_bar.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_dropdown.dart';
import 'package:flutter_template/app/shared/widgets/app_text_field.dart';
import 'package:flutter_template/app/shared/widgets/app_title.dart';
import 'package:flutter_template/app/utils/bottom_sheet_loader.dart';
import 'package:get/get.dart';

class SiteRegistrationView extends StatelessWidget {
  SiteRegistrationView({
    super.key,
    this.site,
    this.onBoardingSiteData,
  }) {
    controller = Get.put(SiteController(), tag: UniqueKey().toString());
  }

  final SiteInfo? site;
  final OnboardingSiteData? onBoardingSiteData;
  late final SiteController controller;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (site != null) {
        controller.patchSiteInfo(site: site);
      } else if (onBoardingSiteData != null) {
        controller.patchOnBoardingSiteData(onBoardingSiteData);
      } else {
        controller.clearForm();
        controller.autoValidate.value = false;
      }
    });
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.autoValidate.value = false;
        return true;
      },
      child: Scaffold(
        appBar: SharableAppBar(
          title: site != null ? 'Edit Site' : 'Add Site',
          backText: 'Back',
          onBack: Get.back<void>,
          backgroundColor: Colors.white,
        ),
        body: Obx(
          () => Form(
            autovalidateMode: controller.autoValidate.value
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pageHorizontalPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const AppTitle(titleName: 'Basic Information'),
                    const SizedBox(
                      height: 24,
                    ),
                    AppTextField(
                      controller: controller.siteNameController,
                      label: 'Coffee Washing Station',
                      borderColor: AppColors.stroke100,
                      hintText: site != null ? 'Edit Site' : 'Add Site',
                      errorText: controller.siteNameController.text.isEmpty
                          ? 'Coffee Washing Station is required'
                          : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                   AppTextField(
                        label: 'Location',
                        borderColor: AppColors.stroke100,
                        hintText: 'Add Location',
                        controller: controller.locationController,
                        errorText: controller.locationController.text.isEmpty
                            ? 'Location is required'
                            : null,
                      ),
                    
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => AppDropdown(
                        label: 'Business Model',
                        borderColor: AppColors.stroke100,
                        hintText: 'Select Model',
                        useTextFieldStyle: true,
                        // value: controller.businessValue.value,
                        value: controller.businessValue.value,
                        useDarkDropDown: true,
                        items: DropdownData.businessModels,
                        onChanged: (value) {
                          controller.businessValue.value = value;
                          controller.businessModelController.text = value ?? '';
                        },
                        errorText: controller.siteNameController.text.isEmpty
                            ? 'Business model is required'
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const AppTitle(titleName: 'Operational Details'),
                    const SizedBox(
                      height: 24,
                    ),
                    AppTextField(
                      controller: controller.processingCapacityController,
                      label: 'Processing Capacity',
                      borderColor: AppColors.stroke100,
                      hintText: '200',
                      keyboardType: TextInputType.number,
                      subLabel: '(${'kg'.tr}/${'day'.tr})',
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.storageSpaceController,
                      label: 'Storage space available',
                      borderColor: AppColors.stroke100,
                      hintText: '20',
                      subLabel: '(${'square meters'.tr})',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.dryingBedsController,
                      label: 'Number of drying beds',
                      borderColor: AppColors.stroke100,
                      hintText: '12',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.fermentationTanksController,
                      label: 'Number of Fermentation Tanks',
                      borderColor: AppColors.stroke100,
                      hintText: '3',
                      subLabel: '(${'if available'.tr})',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.pulpingCapacityController,
                      label: 'Pulping Machine Capacity ',
                      borderColor: AppColors.stroke100,
                      hintText: '2000',
                      subLabel: '(${'kg'.tr}/${'day'.tr})',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.workersController,
                      label: 'Workers & Overhead Managers',
                      borderColor: AppColors.stroke100,
                      hintText: '32',
                      subLabel: '(${'Number of employees'.tr})',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      controller: controller.farmersController,
                      label: ' Outgrower Farmers',
                      borderColor: AppColors.stroke100,
                      hintText: '11',
                      subLabel: '(${'Number of suplliers'.tr})',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        if (site != null)
                          Expanded(
                            child: AppButton(
                              text: 'Discard',
                              width: 0,
                              backgroundColor: AppColors.secondary,
                              textColor: AppColors.grey100,
                              onPressed: () {
                                Get.back<void>();
                              },
                            ),
                          ),
                        if (site != null) const SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            text: site != null ? 'Save Changes' : 'Save Site',
                            width: site != null ? 0 : double.infinity,
                            onPressed: () async {
                              controller.autoValidate.value = true;

                              if (!controller.formKey.currentState!
                                  .validate()) {
                                return;
                              }

                              bool success = false;
                              String title = '';
                              String subTitle = '';
                              bool isLimitReached = false;

                              try {
                                if (site != null) {
                                  success = await controller.updateSite(site!);
                                } else {
                                  success = await controller.addSite();
                                }
                              } catch (e) {
                                if (e.toString().contains('DUPLICATE_NAME')) {
                                  title = 'Duplicate Coffee Washing Station';
                                  subTitle =
                                      'A site with this name already exists. Please choose a different name';
                                } else if (e
                                    .toString()
                                    .contains('LIMIT_REACHED')) {
                                  title = "You can't add any more sites";
                                  subTitle =
                                      'The system has reached its limit for adding new sites. Delete previous sites to add new sites.';
                                  isLimitReached = true;
                                } else {
                                  title = 'Unexpected Error';
                                  subTitle =
                                      'An error occurred while adding the site. Please try again.';
                                }
                              }

                              if (!success) {
                                await Helpers().showBottomSheet(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  title: title,
                                  subTitle: subTitle,
                                  buttonText: 'OK',
                                  imagePath: AppAssets.warningIcon,
                                  isCenteredSubtitle: true,
                                  onButtonPressed: () {
                                    if (isLimitReached) {
                                      Get.offAllNamed<void>(
                                        AppRoutes.SITELIST,
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                );
                                return;
                              }

                              if (site != null) {
                                await Helpers().showBottomSheet(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  title: 'Site Updated',
                                  subTitle:
                                      'Your wet mill site has been updated successfully',
                                  isCenteredSubtitle: true,
                                  imagePath: AppAssets.sucessIcon,
                                  autoDismiss: true,
                                );
                              }

                              Get.offAllNamed<void>(AppRoutes.SITELIST);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
