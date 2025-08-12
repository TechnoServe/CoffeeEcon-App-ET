import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_checkbox.dart';
import 'package:get/get.dart';

class CustomChip extends StatefulWidget {
  const CustomChip({
    required this.label,
    required this.svgPath,
    required this.onTap,
    this.onUnitSelected,
    this.onCurrencySelected,
    super.key,
    this.isRegion = false,
    this.isCurrency = false,
    this.isUnit = false,
    this.isUploadCalculation = false,
    this.selectedUnit,
  });
  final String label;
  final String svgPath;
  final VoidCallback onTap;
  final bool isRegion;
  final bool isCurrency;
  final bool isUnit;
  final bool isUploadCalculation;
  final String? selectedUnit;
  final String? Function(String?)? onUnitSelected;
  final String? Function(String?)? onCurrencySelected;

  static final RxString tempSelectedUnit = 'KG'.obs;
  static final RxString tempSelectedCurrency = 'ETB'.obs;

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  void initState() {
    super.initState();
    // Initialize the selected unit if provided
    if (widget.selectedUnit != null) {
      CustomChip.tempSelectedUnit.value = widget.selectedUnit!;
    }
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (widget.isRegion) {
            _showRegionBottomSheet(context);
          } else if (widget.isCurrency) {
            _showCurrencyBottomSheet(
              context,
              widget.onCurrencySelected,
            );
          } else if (widget.isUnit) {
            _showUnitBottomSheet(
              context,
              widget.onUnitSelected,
            );
          } else if (widget.isUploadCalculation) {
            _showUploadCalculationBottomSheet(
              context,
            );
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
                widget.svgPath,
                width: 16,
                height: 16,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                widget.label.tr,
                overflow: TextOverflow.ellipsis,
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
    final String? Function(String?)? onUnitSelected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                'Easily switch between KG, Pounds, Quintal, and Feresula'.tr,
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
                            CustomChip.tempSelectedUnit.value == 'KG'
                                ? 'Set as Default'
                                : '',
                            CustomChip.tempSelectedUnit.value == 'KG',
                            true,
                            () {
                              CustomChip.tempSelectedUnit.value = 'KG';

                              if (onUnitSelected != null) {
                                onUnitSelected(CustomChip.tempSelectedUnit.value);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRegionTile(
                            'Pound',
                            CustomChip.tempSelectedUnit.value == 'Pound'
                                ? 'Set as Default'
                                : '',
                            CustomChip.tempSelectedUnit.value == 'Pound',
                            true,
                            () {
                              CustomChip.tempSelectedUnit.value = 'Pound';

                              if (onUnitSelected != null) {
                                onUnitSelected(CustomChip.tempSelectedUnit.value);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRegionTile(
                            'Feresula',
                            CustomChip.tempSelectedUnit.value == 'Feresula'
                                ? 'Set as Default'
                                : '',
                            CustomChip.tempSelectedUnit.value == 'Feresula',
                            true,
                            () {
                              CustomChip.tempSelectedUnit.value = 'Feresula';

                              if (onUnitSelected != null) {
                                onUnitSelected(CustomChip.tempSelectedUnit.value);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRegionTile(
                            'Quintal',
                            CustomChip.tempSelectedUnit.value == 'Quintal'
                                ? 'Set as Default'
                                : '',
                            CustomChip.tempSelectedUnit.value == 'Quintal',
                            true,
                            () {
                              CustomChip.tempSelectedUnit.value = 'Quintal';

                              if (onUnitSelected != null) {
                                onUnitSelected(CustomChip.tempSelectedUnit.value);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: double.infinity,
                      child: _buildRegionTile(
                        'Metric Ton',
                        CustomChip.tempSelectedUnit.value == 'Metric Ton'
                            ? 'Set as Default'
                            : '',
                        CustomChip.tempSelectedUnit.value == 'Metric Ton',
                        true,
                        () {
                          CustomChip.tempSelectedUnit.value = 'Metric Ton';

                          if (onUnitSelected != null) {
                            onUnitSelected(CustomChip.tempSelectedUnit.value);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         height: 56,
              //         decoration: BoxDecoration(
              //           color: Colors.grey.shade100,
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         child: TextButton(
              //           onPressed: () => Navigator.pop(context),
              //           style: TextButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 20,
              //               vertical: 8,
              //             ),
              //             foregroundColor: Colors.black87,
              //             textStyle: const TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14,
              //             ),
              //           ),
              //           child: Text('Cancel'.tr),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         height: 56,
              //         decoration: BoxDecoration(
              //           color: Colors.teal,
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         child: TextButton(
              //           onPressed: () {
              //             if (onUnitSelected != null) {
              //               onUnitSelected(tempSelectedUnit.value);
              //             }
              //             Navigator.pop(context);
              //           },
              //           style: TextButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 20,
              //               vertical: 8,
              //             ),
              //             foregroundColor: Colors.white,
              //             textStyle: const TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14,
              //             ),
              //           ),
              //           child: Text('Save'.tr),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCurrencyBottomSheet(
    BuildContext context,
    final String? Function(String?)? onCurrencySelected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Column(
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
              _buildCurrencyTile('🇪🇹', 'BIRR', 'Ethiopian Birr',
                  CustomChip.tempSelectedCurrency.value == 'ETB', () {
                CustomChip.tempSelectedCurrency.value = 'ETB';
                if (onCurrencySelected != null) {
                  onCurrencySelected(CustomChip.tempSelectedCurrency.value);
                }

                Navigator.pop(context);
              }),
              _buildCurrencyTile('🇺🇸', 'USD', 'US Dollar',
                  CustomChip.tempSelectedCurrency.value == 'USD', () {
                CustomChip.tempSelectedCurrency.value = 'USD';
                if (onCurrencySelected != null) {
                  onCurrencySelected(CustomChip.tempSelectedCurrency.value);
                }

                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         height: 56,
              //         decoration: BoxDecoration(
              //           color: Colors.grey.shade100,
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         child: TextButton(
              //           onPressed: () => {
              //             Navigator.pop(context),
              //           },
              //           style: TextButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 20,
              //               vertical: 8,
              //             ),
              //             foregroundColor: Colors.black87,
              //             textStyle: const TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14,
              //             ),
              //           ),
              //           child: Text('Cancel'.tr),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         height: 56,
              //         decoration: BoxDecoration(
              //           color: Colors.teal,
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         child: TextButton(
              //           onPressed: () => {
              //             if (onCurrencySelected != null)
              //               {onCurrencySelected(tempSelectedCurrency.value)},
              //             Navigator.pop(context),
              //           },
              //           style: TextButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 20,
              //               vertical: 8,
              //             ),
              //             foregroundColor: Colors.white,
              //             textStyle: const TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 14,
              //             ),
              //           ),
              //           child: Text('Save'.tr),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

// Replace the region/unit list with a GridView in _showUnitBottomSheet
  Widget _buildRegionTile(
    String title,
    String? subtitle, // Make subtitle nullable
    bool isSelected,
    bool isUnit,
    void Function()? onTap,
  ) =>
      Container(
        height: 56, // Fixed height of 56px
        padding: const EdgeInsets.all(8), // 8px padding
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
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity, // Take full height
                  child: subtitle?.isNotEmpty ?? false
                      ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Vertical center
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Left align
                          children: [
                            Text(
                              title.tr,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              subtitle!.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          // Only vertical center with left alignment
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
              ),
              CustomCheckbox(
                isSelected: isSelected,
                onChanged: (bool? value) {},
              ),
            ],
          ),
        ),
      );

  Widget _buildCurrencyTile(
    String flag,
    String currency,
    String subtitle,
    bool isSelected,
    void Function() onTap,
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
          onTap: onTap,
        ),
      );

  void _showUploadCalculationBottomSheet(
    BuildContext context,
  ) {
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upload Calculation Data'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF23262F),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Calculation Type Dropdown
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Calculation Type'.tr,
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
                      hint: Text(
                        'Select Site'.tr,
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
