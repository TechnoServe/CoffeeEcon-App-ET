import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/basic_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/primary_icon_button.dart';
import 'package:flutter_template/app/Pages/stock/widget/section_title.dart';
import 'package:flutter_template/app/core/config/constants/calcuation_constants.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:get/get.dart';

class BasicTab extends StatefulWidget {
  BasicTab({
    super.key,
    this.siteData,
    this.entry,
  }) {
    controller =
        Get.put(BasicCalculatorController(), tag: UniqueKey().toString());
  }
  final BasicCalculationEntryModel? entry;
  late final BasicCalculatorController controller;
  final Map<String, String>? siteData;
  @override
  State<BasicTab> createState() => _BasicTabState();
}

class _BasicTabState extends State<BasicTab> {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BasicCalculatorController>()) {
      Get.put(BasicCalculatorController(), tag: UniqueKey().toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.entry != null) {
        widget.controller.patchPreviousData(data: widget.entry);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        widget.controller.autoValidate.value = false;
        return true;
      },
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            autovalidateMode: widget.controller.autoValidate.value
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: widget.controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SectionTitle(
                    title: 'Simple Price Calculator',
                    subtitle:
                        'Quickly estimate coffee pricing with essential cost factors',
                    isCurrency: false,
                    isRegion: false,
                    isUnit: true,
                    showChip: true,
                    chipLabel: widget.controller.selectedUnit.value,
                    onUnitSelected: (value) {
                      widget.controller.selectedUnit.value = value ?? 'KG';
                    },
                    chipSvgPath: 'assets/icons/birr.svg',
                    onChipTap: () => {},
                  ),
                ),
                const SizedBox(height: 24),
                LabeledTextField(
                  key: ValueKey(
                    'purchaseVolume-${widget.controller.fieldAlerts['purchaseVolume'] == true}',
                  ),
                  label: 'Cherry purchase volume',
                  keyboardType: TextInputType.number,
                  controller: widget.controller.purchaseVolumeController,
                  hintText: 'Amount',
                  suffixText: 'Per ${widget.controller.selectedUnit.value}',
                  errorText: 'Cherry purchase volume is required',
                  minValue: '1',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'seasonalPrice-${widget.controller.fieldAlerts['seasonalPrice'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Seasonal Coffee Cherry Price',
                  controller: widget.controller.seasonalCoffeePriceController,
                  showAlert:
                      widget.controller.fieldAlerts['seasonalPrice'] == true,
                  focusNode: widget.controller.fieldFocusNodes['seasonalPrice'],
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'seasonalPrice',
                    );
                  },
                  errorText: 'Seasonal Coffee Cherry Price is required',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'fuelAndOils-${widget.controller.fieldAlerts['fuelAndOils'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Fuels',
                  controller: widget.controller.fuelAndOilController,
                  hintText: 'Amount',
                  showAlert:
                      widget.controller.fieldAlerts['fuelAndOils'] == true,
                  focusNode: widget.controller.fieldFocusNodes['fuelAndOils'],
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'fuelAndOils',
                    );
                  },
                  errorText: 'Fuels is required',
                ),
                const SizedBox(height: 20),
                // LabeledTextField(
                //   label: 'Input 1',
                //   hintText: 'Value',
                //   isLabelEditable: true,
                // ),
                LabeledTextField(
                  key: ValueKey(
                    'cherryTransport-${widget.controller.fieldAlerts['cherryTransport'] == true}',
                  ),
                  label: 'Cherry Transport and Commission',
                  controller: widget.controller.cherryTransportController,
                  showAlert:
                      widget.controller.fieldAlerts['cherryTransport'] == true,
                  focusNode:
                      widget.controller.fieldFocusNodes['cherryTransport'],
                  keyboardType: TextInputType.number,
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'cherryTransport',
                    );
                  },
                  errorText: 'Cherry transport is required',
                ),

                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'laborFullTime-${widget.controller.fieldAlerts['laborFullTime'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Labor (Full-Time)',
                  controller: widget.controller.laborFullTimeController,
                  showAlert:
                      widget.controller.fieldAlerts['laborFullTime'] == true,
                  focusNode: widget.controller.fieldFocusNodes['laborFullTime'],
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'laborFullTime',
                    );
                  },
                  errorText: 'Labor (Full-Time) is required',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'laborCasual-${widget.controller.fieldAlerts['laborCasual'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Labor (Casual)',
                  controller: widget.controller.laborCasualController,
                  showAlert:
                      widget.controller.fieldAlerts['laborCasual'] == true,
                  focusNode: widget.controller.fieldFocusNodes['laborCasual'],
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'laborCasual',
                    );
                  },
                  errorText: 'Labor (Casual) is required',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'repairsAndMaintenance-${widget.controller.fieldAlerts['repairsAndMaintenance'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Repairs and Maintenance in season',
                  controller: widget.controller.repairsAndMaintenance,
                  showAlert:
                      widget.controller.fieldAlerts['repairsAndMaintenance'] ==
                          true,
                  focusNode: widget
                      .controller.fieldFocusNodes['repairsAndMaintenance'],
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'repairsAndMaintenance',
                    );
                  },
                  errorText: 'Repairs and maintenance in season is required',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  key: ValueKey(
                    'otherExpenses-${widget.controller.fieldAlerts['otherExpenses'] == true}',
                  ),
                  keyboardType: TextInputType.number,
                  label: 'Other Expenses',
                  controller: widget.controller.otherExpensesController,
                  showAlert:
                      widget.controller.fieldAlerts['otherExpenses'] == true,
                  focusNode: widget.controller.fieldFocusNodes['otherExpenses'],
                  hintText: 'Amount',
                  onAlertTap: () {
                    widget.controller.showFieldRangeWarning(
                      context: context,
                      fieldKey: 'otherExpenses',
                    );
                  },
                  errorText: 'Other expenses is required',
                ),
                const SizedBox(
                  height: 20,
                ),

                LabeledDropdown<String>(
                  label: 'Coffee Selling Type',
                  hintText: 'Select type',
                  value: widget.controller.selectedTCoffeesellingType.value,

                  items: widget.controller.coffeeTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type.tr)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() {
                    if (val != null) {
                      widget.controller.ratioController.text =
                          CalcuationConstants.conversionFactors[val].toString();
                    }
                    widget.controller.selectedTCoffeesellingType.value = val;
                  }),
                  errorText: 'Coffee selling type is required',

                  // validator: widget.controller.validateDropdown,
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: 'Conversion Ratio',
                  keyboardType: TextInputType.number,
                  hintText: '18.0%',
                  controller: widget.controller.ratioController,
                  errorText: 'Conversion Ratio is required',
                  minValue: '0.1',
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: 'Profit Margin',
                  keyboardType: TextInputType.number,
                  hintText: 'Amount',
                  controller: widget.controller.expectedProfitMarginController,
                  errorText: 'Profit margin is required',
                ),
                const SizedBox(height: 20),
                PrimaryIconButton(
                  text: 'Calculate',
                  iconPath: 'assets/icons/calc.svg',
                  onPressed: () {
                    widget.controller.autoValidate.value = true;

                    final isValid =
                        widget.controller.formKey.currentState?.validate() ??
                            false;
                    if (isValid) {
                      widget.controller.submit();
                    }
                  },
                  type: ButtonType.filled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
