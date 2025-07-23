import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/forecast_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/primary_icon_button.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:flutter_template/app/Pages/stock/widget/section_title.dart';

import 'package:get/get.dart';

class StockView extends GetView<StockController> {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StockController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: StockAppBar(
        //   title: 'Stock Price',
        //   showBackButton: false,
        //   showUnitChip: true,
        // ),
        body: _StockBody(),
      ),
    );
  }
}

// AppBar Widget

// Body Widget
class _StockBody extends StatefulWidget {
  _StockBody({
    super.key,
  }) {
    controller =
        Get.put(ForecastCalculatorController(), tag: UniqueKey().toString());
  }

  late final ForecastCalculatorController controller;
  @override
  State<_StockBody> createState() => _StockBodyState();
}

class _StockBodyState extends State<_StockBody> {
  // Simulate connection status for demonstration; replace with your actual logic or controller
  bool get hasConnection => true;
  // Set this based on your connectivity logic
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // You can use a controller or a package like connectivity_plus for real status
    // return const Center(child: ComingSoon());
    return WillPopScope(
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
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
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
                          hintText: 'Amount',
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
                          hintText: 'Amount',
                          controller: widget.controller.coffeeVolume,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        LabeledTextField(
                          key: const ValueKey(
                            'other-expense',
                          ),
                          label: 'Other Expenses',
                          hintText: 'Total Other Expenses',
                          errorText: 'Other expense is required',
                          controller: widget.controller.otherExpensesController,
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

    // return SingleChildScrollView(
    //   padding: const EdgeInsets.all(16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const SectionTitle(
    //           title: 'Trending Coffee',
    //           subtitle: 'Get real-time coffee prices and trends.',
    //           isRegion: true,
    //           showChip: true,
    //           chipLabel: 'Asia',
    //           chipSvgPath: 'assets/icons/region.svg'),
    //       const SizedBox(height: 20),
    //       hasConnection
    //           ? const Column(
    //               children: [
    //                 TrendChart(),
    //                 SizedBox(height: 20),
    //                 TimeRangeSelector(),
    //                 SizedBox(height: 20),
    //                 StocksGrid(),
    //               ],
    //             )
    //           : Column(
    //               children: [
    //                 SizedBox(
    //                   height: MediaQuery.of(context).size.height * 0.2,
    //                 ),
    //                 const NoConnectionWidget(),
    //               ],
    //             ),
    //     ],
    //   ),
    // );
  }
}
