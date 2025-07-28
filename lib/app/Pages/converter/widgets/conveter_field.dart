import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/widgets/tab_button.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/shared/widgets/app_dropdown.dart';
import 'package:flutter_template/app/shared/widgets/app_number_keyboard.dart';
import 'package:flutter_template/app/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';

class ConverterField<T> extends StatelessWidget {
  const ConverterField({
    required this.onItemSelected,
    required this.textFieldController,
    required this.isUnitConverstion,
    super.key,
    this.selectedUnitIndex,
    this.onUnitSelected,
    this.showUnits = true,
    this.label,
    this.selectedItem,
    this.dropdownItems = const [],
  });

  final TextEditingController textFieldController;
  final String? label;
  final bool showUnits;
  final bool isUnitConverstion;

  final RxInt? selectedUnitIndex;
  final void Function(int)? onUnitSelected;

  final Rx<T?>? selectedItem;
  final ValueChanged<T?> onItemSelected;
  final List<T> dropdownItems;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConverterController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (label != null)
                  Text(
                    label ?? '',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.grey60,
                        ),
                  ),
                // if (!isUnitConverstion) const SizedBox(width: 8),
                Obx(
                  () {
                    final screenWidth = MediaQuery.of(context).size.width;

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isUnitConverstion
                            ? screenWidth * 0.35
                            : screenWidth * 0.32,
                      ),
                      child: AppDropdown<T>(
                        items: dropdownItems,
                        value: selectedItem!.value,
                        onChanged: onItemSelected,
                        hintText: 'Select Grade',
                        bottomBorderOnly: true,
                      ),
                    );
                  },
                ),
              ],
            ),
            if (showUnits)
              Obx(() {
                Get.find<ConverterController>();
                final screenWidth = MediaQuery.of(context).size.width;
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        screenWidth * 0.55, // Adjust to balance with dropdown
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TabButton(
                          label: 'kg'.tr,
                          isSelected: selectedUnitIndex!.value == 0,
                          onTap: () => onUnitSelected!(0),
                          height: 29.h,
                          textStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: selectedUnitIndex!.value == 0
                                        ? AppColors.textWhite100
                                        : AppColors.textBlack60,
                                  ),
                          borderRadius: 4,
                        ),
                        const SizedBox(width: 4),
                        TabButton(
                          label: 'Qt'.tr,
                          isSelected: selectedUnitIndex!.value == 1,
                          onTap: () => onUnitSelected!(1),
                          height: 29.h,
                          textStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: selectedUnitIndex!.value == 1
                                        ? AppColors.textWhite100
                                        : AppColors.textBlack60,
                                  ),
                          borderRadius: 4,
                        ),
                        const SizedBox(width: 4),
                        TabButton(
                          label: 'Feresula'.tr,
                          isSelected: selectedUnitIndex!.value == 2,
                          onTap: () => onUnitSelected!(2),
                          height: 29.h,
                          textStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: selectedUnitIndex!.value == 2
                                        ? AppColors.textWhite100
                                        : AppColors.textBlack60,
                                  ),
                          borderRadius: 4,
                        ),
                        const SizedBox(width: 4),
                        TabButton(
                          label: 'Mt'.tr,
                          isSelected: selectedUnitIndex!.value == 3,
                          onTap: () => onUnitSelected!(3),
                          height: 29.h,
                          textStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: selectedUnitIndex!.value == 3
                                        ? AppColors.textWhite100
                                        : AppColors.textBlack60,
                                  ),
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        AppTextField(
          controller: textFieldController,
          borderBottomOnly: true,
          readOnly: true,
          textAlign: TextAlign.end,
          borderColor: AppColors.grey50,
          textStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 28,
              ),
          onTap: () {
            // final convController = Get.find<ConverterController>();
            // convController.activeController.value = textFieldController;

            // if (!convController.isKeyboardOpen.value) {
            //   convController.isKeyboardOpen.value = true;
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              barrierColor: Colors.transparent,
              isDismissible: true,
              transitionAnimationController: AnimationController(
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(milliseconds: 500),
                vsync: Navigator.of(context),
              ),
              backgroundColor: Colors.transparent,
              builder: (_) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    Navigator.of(context).pop(), // dismiss when tapping outside
                child: GestureDetector(
                  onTap: () {}, // absorb tap inside
                  child: SafeArea(
                    child: AppNumberKeyboard(
                      onNumberTap: (val) => controller.onNumberInput(
                        val,
                        controller: textFieldController,
                        isUnitConverstion: isUnitConverstion,
                      ),
                      onClear: () => controller.clearAmount(
                        controller: textFieldController,
                        isUnitConverstion: isUnitConverstion,
                      ),
                    ),
                  ),
                ),
              ),
            );
            // }
          },
        ),
      ],
    );
  }
}
