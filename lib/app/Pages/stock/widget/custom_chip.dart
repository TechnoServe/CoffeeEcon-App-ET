import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/basic_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/forecast_calculator_controller.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_checkbox.dart';
import 'package:get/get.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    required this.label,
    required this.svgPath,
    required this.onTap,
    super.key,
    this.isRegion = false,
    this.isCurrency = false,
    this.isUnit = false,
    this.isUploadCalculation = false,
    this.basicController,
    this.forCastController,
  });
  final String label;
  final String svgPath;
  final VoidCallback onTap;
  final bool isRegion;
  final bool isCurrency;
  final bool isUnit;
  final bool isUploadCalculation;
  final BasicCalculatorController? basicController;
  final ForecastCalculatorController? forCastController;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (isRegion) {
            _showRegionBottomSheet(context);
          } else if (isCurrency) {
            _showCurrencyBottomSheet(context);
          } else if (isUnit) {
            _showUnitBottomSheet(context, basicController, forCastController);
          } else if (isUploadCalculation) {
            _showUploadCalculationBottomSheet(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgPath,
                width: 16,
                height: 16,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                label.tr,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  void _showRegionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 24, top: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Text(
              'Change Region'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Switch region for coffee prices'.tr,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            _buildRegionTile('USA', 'Set as Default', true, false, () => {}),
            _buildRegionTile('EU', '', false, false, () => {}),
            _buildRegionTile('East Asia', '', false, false, () => {}),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.black87,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Cancel'.tr),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Save'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitBottomSheet(
    BuildContext context,
    BasicCalculatorController? basicCalcuationController,
    ForecastCalculatorController? forCastController,
  ) {
    final RxString tempSelectedUnit =
        basicCalcuationController?.selectedUnit.value.obs ??
            forCastController?.selectedUnit.value.obs ??
            ''.obs;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 24, top: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Text(
              'Change Unit'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Easily switch between KG, Pounds, Kuntal, and Feresula'.tr,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),

            // Reactive region tiles
            Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildRegionTile(
                          'KG',
                          tempSelectedUnit.value == 'KG'
                              ? 'Set as Default'
                              : '',
                          tempSelectedUnit.value == 'KG',
                          true,
                          () => tempSelectedUnit.value = 'KG',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildRegionTile(
                          'Pound',
                          tempSelectedUnit.value == 'Pound'
                              ? 'Set as Default'
                              : '',
                          tempSelectedUnit.value == 'Pound',
                          true,
                          () => tempSelectedUnit.value = 'Pound',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRegionTile(
                          'Feresula',
                          tempSelectedUnit.value == 'Feresula'
                              ? 'Set as Default'
                              : '',
                          tempSelectedUnit.value == 'Feresula',
                          true,
                          () => tempSelectedUnit.value = 'Feresula',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildRegionTile(
                          'Quintal',
                          tempSelectedUnit.value == 'Quintal'
                              ? 'Set as Default'
                              : '',
                          tempSelectedUnit.value == 'Quintal',
                          true,
                          () => tempSelectedUnit.value = 'Quintal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.black87,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Cancel'.tr),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Step 3: Apply change only on save
                        basicController?.selectedUnit.value =
                            tempSelectedUnit.value;
                        forCastController?.selectedUnit.value =
                            tempSelectedUnit.value;
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Save'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 24, top: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Text(
              'Switch Currency'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the currency you wish to use for the pricing'.tr,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            _buildCurrencyTile('🇪🇹', 'BIRR', 'Ethiopian Birr', true),
            _buildCurrencyTile('🇺🇸', 'USD', 'US Dollar', false),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.black87,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Cancel'.tr),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      child: Text('Save'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Replace the region/unit list with a GridView in _showUnitBottomSheet

  Widget _buildRegionTile(
    String title,
    String subtitle,
    bool isSelected,
    bool isUnit,
    void Function()? onTap,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.teal
                : isUnit
                    ? Colors.grey.shade200
                    : Colors.transparent,
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            title.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            subtitle.tr,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          trailing: CustomCheckbox(
            isSelected: isSelected,
            onChanged: (bool? value) {},
          ),
          onTap: onTap,
        ),
      );

  Widget _buildCurrencyTile(
    String flag,
    String currency,
    String subtitle,
    bool isSelected,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.transparent,
            width: 1,
          ),
        ),
        child: ListTile(
          leading: Text(flag, style: const TextStyle(fontSize: 24)),
          title: Text(
            currency.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            subtitle.tr,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          trailing: CustomCheckbox(
            isSelected: isSelected,
            onChanged: (bool? value) {},
          ),
          onTap: () {},
        ),
      );

  void _showUploadCalculationBottomSheet(BuildContext context) {
    String? selectedSite;
    final sites = ['Site A', 'Site B', 'Site C'];
    final TextEditingController titleController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upload Calculation Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Calculation Type Dropdown
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Calculation Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE6E8EC)),
                    color: const Color(0xFFF8F9FB),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedSite,
                      hint: const Text(
                        'Select Site',
                        style: TextStyle(
                          color: Color(0xFFB0B7C3),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFB0B7C3),
                      ),
                      items: sites
                          .map(
                            (site) => DropdownMenuItem(
                              value: site,
                              child: Text(site),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => selectedSite = val),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Save as TextField
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Save as',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0B7C3),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFB0B7C3)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Add File
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB),
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Add File',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle file browse
                        },
                        child: const Text(
                          'Browse',
                          style: TextStyle(
                            color: Color(0xFF11696D),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8F9FB),
                            side: const BorderSide(color: Color(0xFFF8F9FB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle upload
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF11696D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
