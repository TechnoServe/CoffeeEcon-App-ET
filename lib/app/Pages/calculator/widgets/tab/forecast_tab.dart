import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/forecast_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/primary_icon_button.dart';
import 'package:flutter_template/app/Pages/stock/widget/section_title.dart';
import 'package:get/get.dart';

class ForecastTab extends StatefulWidget {
  ForecastTab({
    super.key,
  }) {
    controller =
        Get.put(ForecastCalculatorController(), tag: UniqueKey().toString());
  }

  late final ForecastCalculatorController controller;

  @override
  State<ForecastTab> createState() => _ForecastTabState();
}

class _ForecastTabState extends State<ForecastTab> {
  @override
  Widget build(BuildContext context) => // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async {
          widget.controller.autoValidate.value = false;
          return true;
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              autovalidateMode: widget.controller.autoValidate.value
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              key: widget.controller.formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => SectionTitle(
                              title: 'Price Forecast',
                              subtitle:
                                  'Forecast coffee prices by analyzing key cost factors',
                              isCurrency: false,
                              isRegion: false,
                              isUnit: true,
                              showChip: true,
                              chipLabel: widget.controller.selectedUnit.value,
                              onUnitSelected: (value) {
                                widget.controller.selectedUnit.value =
                                    value ?? 'FERESULA';
                                return null;
                              },
                              chipSvgPath: 'assets/icons/birr.svg',
                              onChipTap: () => {},
                            ),
                          ),
                          const SizedBox(height: 24),
                          LabeledDropdown<String>(
                            label: 'Coffee Type',
                            hintText: 'Select type',
                            value: widget.controller.selectedCoffeeType.value,
                            errorText: 'Coffee type is required',
                            items: widget.controller.coffeeTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(
                              () => widget.controller.selectedCoffeeType.value =
                                  val,
                            ),
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            key: const ValueKey(
                              'seasonal-coffee-price',
                            ),
                            label: 'Seasonal Coffee Price',
                            errorText: 'Seasonal coffee is required',
                            hintText: 'Amount in birr',
                            controller: widget.controller.priceController,
                            suffixText:
                                'Per 1 ${widget.controller.selectedUnit.value}',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            key: const ValueKey(
                              'coffee-volume',
                            ),
                            label: 'Coffee Volume',
                            errorText: 'Coffee Volume is required',
                            hintText:
                                'Amount in ${widget.controller.selectedUnit.value}',
                            controller: widget.controller.coffeeVolume,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          LabeledTextField(
                            key: const ValueKey(
                              'other-expense',
                            ),
                            label: 'Other Expenses',
                            hintText: 'Total other expenses in birr',
                            errorText: 'Other expense is required',
                            controller:
                                widget.controller.otherExpensesController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PrimaryIconButton(
                    text: 'Calculate',
                    iconPath: 'assets/icons/calc.svg',
                    onPressed: () {

                      widget.controller.autoValidate.value = true;

                      final isValid =
                          widget.controller.formKey.currentState?.validate() ??
                              false;
                      if (isValid) {

                        widget.controller.onCalculate();
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
