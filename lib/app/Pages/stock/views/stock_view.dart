import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/forecast_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_text_field.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/primary_icon_button.dart';
import 'package:flutter_template/app/Pages/stock/controllers/stock_controllers.dart';
import 'package:flutter_template/app/Pages/stock/widget/section_title.dart';

import 'package:get/get.dart';

/// Main stock view that provides the interface for coffee price forecasting and stock analysis.
///
/// This view serves as the container for stock-related functionality including:
/// - Coffee price forecasting based on cost factors
/// - Unit selection for price calculations
/// - Form-based input for forecast parameters
/// - Integration with forecast calculator controller
/// - Responsive layout with scrollable content
///
/// The view uses GetX for state management and provides a clean, form-based interface
/// for users to input forecast parameters and view price predictions.
class StockView extends GetView<StockController> {
  /// Creates a StockView widget.
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure stock controller is available for state management
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
/// Body widget that contains the main stock forecasting interface.
///
/// This widget manages the form-based interface for coffee price forecasting,
/// including unit selection, input fields, and forecast calculations.
/// It integrates with the ForecastCalculatorController for business logic.
class _StockBody extends StatefulWidget {
  /// Creates a _StockBody widget with forecast calculator controller.
  _StockBody({
    super.key,
  }) {
    // Initialize forecast calculator controller with unique tag for proper state management
    controller =
        Get.put(ForecastCalculatorController(), tag: UniqueKey().toString());
  }

  /// Reference to the forecast calculator controller for business logic
  late final ForecastCalculatorController controller;
  @override
  State<_StockBody> createState() => _StockBodyState();
}

class _StockBodyState extends State<_StockBody> {
  // Simulate connection status for demonstration; replace with your actual logic or controller
  /// Whether the app has an active internet connection
  /// This is used for determining if real-time data can be fetched
  bool get hasConnection => true;
  // Set this based on your connectivity logic
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // You can use a controller or a package like connectivity_plus for real status
    // return const Center(child: ComingSoon());
    return WillPopScope(
      // Handle back navigation and reset form validation state
      onWillPop: () async {
        widget.controller.autoValidate.value = false;
        return true;
      },
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            // Configure form validation based on controller state
            autovalidateMode: widget.controller.autoValidate.value
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: widget.controller.formKey,
            child: Column(
              children: [
                // Scrollable content area for form inputs
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Section title with unit selection chip
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
                        // Coffee type selection dropdown
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
