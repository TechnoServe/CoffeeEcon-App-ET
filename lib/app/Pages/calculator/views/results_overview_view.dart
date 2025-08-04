import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/advanced_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/basic_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/dashed_divider.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/general_app_bar.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/legend_dot.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/primary_icon_button.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/save_cost_breakdown_sheet.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/summary_row.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/trailing_icon_button.dart';
import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/stock/widget/custom_chip.dart';
import 'package:flutter_template/app/Pages/stock/widget/section_title.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/services/export_service.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/shared/controllers/exchange_rate_controller.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;

class ResultsOverviewView extends StatefulWidget {
  const ResultsOverviewView({
    required this.type,
    this.isBestPractice = true,
    this.basicCalcData,
    this.advancedCalcData,
    this.breakEvenPrice,
    this.totalMarketPrice,
    this.cherryPrice,
    this.selectedUnit,
    this.selectedCoffeeType,
    super.key,
  });

  //for basic
  final ResultsOverviewType type;
  final BasicCalculationEntryModel? basicCalcData;
  final AdvancedCalculationModel? advancedCalcData;

  final double? breakEvenPrice;

  //for forcast
  final double? totalMarketPrice;
  final double? cherryPrice;
  final String? selectedUnit;
  final String? selectedCoffeeType;

  final bool isBestPractice;

  @override
  State<ResultsOverviewView> createState() => _ResultsOverviewViewState();
}

class _ResultsOverviewViewState extends State<ResultsOverviewView> {
  final controller = Get.put(CalculatorController());



  @override
  void dispose() {
    controller.selectedSite = [];

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: GeneralAppBar(
          title: 'Results Overview',
          showBackButton: true,
          onBack: () {
            Get.to<void>(
              () => MainView(
                initialIndex:
                    widget.type == ResultsOverviewType.forecast ? 4 : 1,
                basicCalcData: widget.basicCalcData,
                advancedCalcData: widget.advancedCalcData,
                type: widget.type,
              ),
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.type != ResultsOverviewType.forecast)
                TrailingIconButton(
                  type: TrailingButtonType.icon,
                  actionType: TrailingButtonActionType.action,
                  svgPath: 'assets/icons/save.svg',
                  iconColor: Colors.black,
                  size: 48,
                  backgroundColor: AppColors.background,
                  onPressed: () {
                    // Handle action for the first icon button

                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => SaveCostBreakdownSheet(
                        basicCalcData: widget.basicCalcData,
                        advancedCalcData: widget.advancedCalcData,
                        breakEvenPrice: widget.breakEvenPrice,
                        cherryPrice: widget.cherryPrice,
                        totalSellingPrice: widget.totalMarketPrice ?? 0,
                        type: widget.type,
                        isBestPractice: widget.isBestPractice,
                      ),
                    );
                  },
                ),
              if (widget.type != ResultsOverviewType.forecast)
                const SizedBox(width: 8),
              if (widget.type != ResultsOverviewType.forecast)
                TrailingIconButton(
                  type: TrailingButtonType.icon,
                  actionType: TrailingButtonActionType.dropdown,
                  svgPath: 'assets/icons/download.svg',
                  iconColor: Colors.black,
                  size: 48,
                  backgroundColor: AppColors.background,
                  dropdownItems: [
                    PopupMenuItem(
                      value: 'pdf',
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context); // Close the popup menu

                          await exportSavedBreakdownsToPdf(
                            basicCalcData: widget.basicCalcData,
                            advancedCalcData: widget.advancedCalcData,
                            breakEvenPrice: widget.breakEvenPrice!,
                            sites: controller.getSites(),
                            context: context,
                            isBestPractice: widget.isBestPractice,
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/pdf.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 9.13),
                            const Text(
                              'Download As PDF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'excel',
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context); // Close the popup menu

                          await exportSavedBreakdownsToExcel(
                            basicCalcData: widget.basicCalcData,
                            advancedCalcData: widget.advancedCalcData,
                            breakEvenPrice: widget.breakEvenPrice!,
                            sites: controller.getSites(),
                            context: context,
                            isBestPractice: widget.isBestPractice,
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/xl.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 9.13),
                            const Text(
                              'Download As Excel',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  // onSelected: (value) {
                  // // Handle dropdown selection here
                  // if (value == 'pdf') {
                  //   // Download as PDF logic
                  // } else if (value == 'excel') {
                  //   // Download as Excel logic
                  // }
                  // },
                ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            switch (widget.type) {
              case ResultsOverviewType.basic:
                return BasicResultsOverviewBody(
                  entry: widget.basicCalcData!,
                  breakEvenPrice: widget.breakEvenPrice!,
                );
              case ResultsOverviewType.advanced:
                return AdvancedResultsOverviewBody(
                  entry: widget.advancedCalcData!,
                  breakEvenPrice: widget.breakEvenPrice!,
                  jutBagTotal: widget.advancedCalcData?.jutBagTotal ?? 0,
                  variableCost: widget.advancedCalcData?.variableCostTotal ?? 0,
                );
              case ResultsOverviewType.forecast:
                return ForecastResultsOverviewBody(
                  totalMarketPrice: widget.totalMarketPrice!,
                  cherryPrice: widget.cherryPrice!,
                  selectedUnit: widget.selectedUnit!,
                  selectedCoffeeType: widget.selectedCoffeeType!,
                );
              case ResultsOverviewType.plan:
                return const SizedBox();
            }
          },
        ),
      );
}

class BasicResultsOverviewBody extends StatelessWidget {
  BasicResultsOverviewBody({
    required this.entry,
    required this.breakEvenPrice,
    super.key,
  });
  final BasicCalculationEntryModel entry;
  final double breakEvenPrice;
  final controller = Get.find<CalculatorController>();
  final exchangeController = Get.find<ExchangeRateController>();

  @override
  Widget build(BuildContext context) { 
  final basicCalculatorController = Get.find<BasicCalculatorController>();
    
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Cost Breakdown Summary',
                subtitle: 'Calculated coffee selling price based on key costs.',
                isCurrency: true,
                isRegion: false,
                showChip: true,
                chipLabel: exchangeController.selectedCurrency.value,
                chipSvgPath: 'assets/icons/birr.svg',
                onCurrencySelected: (value) {
                  exchangeController.changeCurrency(value ?? '');
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Summary Card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: SummaryRow(
                        label: 'Break Even Price',
                        value: exchangeController
                            .convertPrice(breakEvenPrice)
                            .toStringAsFixed(4),
                      ),
                    ),
                    const DashedDivider(
                      color: Color(0xFFE6E8EC),
                      height: 1,
                      dashWidth: 8,
                      dashSpace: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SummaryRow(
                        label: 'Profit Margin Applied',
                        value: '${entry.expectedProfit} %',
                        showCurrency: false,
                      ),
                    ),
                    const DashedDivider(
                      color: Color(0xFFE6E8EC),
                      height: 1,
                      dashWidth: 6,
                      dashSpace: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: SummaryRow(
                        label: 'Recommended Selling Price',
                        value: exchangeController
                            .convertPrice(entry.totalSellingPrice)
                            .toStringAsFixed(4),
                        valueColor: const Color(0xFF1AB98B),
                        isBold: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Pie Chart Widget using pie_chart package
              Center(
                child: SizedBox(
                  height: 200,
                  child: pie_chart.PieChart(
                    dataMap: {
                      'Cherry Price': double.tryParse(entry.seasonalPrice) ?? 0,
                      'Repairs and Maintenance in-season':
                          double.tryParse(entry.repairsAndMaintenance) ?? 0,
                      'Cherry Transport and Commission':
                          double.tryParse(entry.cherryTransport) ?? 0,
                      'Labor (Full-Time)':
                          double.tryParse(entry.laborFullTime) ?? 0,
                      'Labor (Casual)': double.tryParse(entry.laborCasual) ?? 0,
                      'Other Expenses':
                          double.tryParse(entry.otherExpenses) ?? 0,
                      'Fuel': double.tryParse(entry.fuelAndOils) ?? 0,
                    },
                    colorList: const [
                      Color(0xFF11696D), // Cherry Price
                      Color(0xFF3B82F6), // Repairs and Maintenance in-season
                      Color(0xFFFFC700), // Cherry Transport and Commission
                      Color(0xFF00B3B0), // Labor (Full-Time)
                      Color.fromARGB(255, 5, 62, 177), // Labor (casual)
                      Color(0xFF34D399), // Other Expenses
                      Color(0xFFEF4444), // fuel and oil
                    ],
                    chartType: pie_chart.ChartType.disc,
                    chartRadius: MediaQuery.of(context).size.width / 2.0,
                    legendOptions: const pie_chart.LegendOptions(
                      showLegends: false,
                    ),
                    chartValuesOptions: const pie_chart.ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                      showChartValueBackground: false,
                      decimalPlaces: 0,
                      chartValueStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Legend

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendDot(color: Color(0xFF11696D), label: 'Cherry Price'),
                  LegendDot(
                    color: Color(0xFF3B82F6),
                    label: 'Repairs and Maintenance in-season',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendDot(
                    color: Color(0xFFFFC700),
                    label: 'Cherry Transport and Commission',
                  ),
                  LegendDot(
                    color: Color(0xFF00B3B0),
                    label: 'Labor (Full-Time)',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendDot(
                    color: Color.fromARGB(255, 5, 62, 177),
                    label: 'Labor (Casual)',
                  ),
                  LegendDot(color: Color(0xFFEF4444), label: 'Fuel and Oils'),
                  LegendDot(color: Color(0xFF34D399), label: 'Other Expenses'),
                ],
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 32),
              // Outlined Button
              PrimaryIconButton(
                text: 'Calculate Again',
                iconPath: 'assets/icons/calc.svg',
                onPressed: () {
                  basicCalculatorController.skipBestPracticeWarning = true;
                  controller.selectedTab.value = 'Basic';
                  controller.goToTab(0);
         
                  Get.to<void>(
                    () => MainView(
                      initialIndex: 1,
                      basicCalcData: entry,
                    ),
                  );
                },
                type: ButtonType.outlined,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}
}
class AdvancedResultsOverviewBody extends StatefulWidget {
  const AdvancedResultsOverviewBody({
    required this.entry,
    required this.breakEvenPrice,
    required this.jutBagTotal,
    required this.variableCost,
    super.key,
  });
  final AdvancedCalculationModel entry;
  final double breakEvenPrice;
  final double jutBagTotal;
  final double variableCost;

  @override
  State<AdvancedResultsOverviewBody> createState() =>
      _AdvancedResultsOverviewBodyState();
}

class _AdvancedResultsOverviewBodyState
    extends State<AdvancedResultsOverviewBody> {
  String selectedUnit = 'KG';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();
    final exchangeController = Get.find<ExchangeRateController>();
    final advancedCalculatorController = Get.find<AdvancedCalculatorController>();

    int convertedOutPutVolume = controller
        .convertUnit(
          to: selectedUnit,
          input: double.tryParse(widget.entry.cherryPurchase)! *
              double.tryParse(widget.entry.ratio)!,
        )
        .toInt();

      final double convertedPreTaxBreakEvenPrice = controller
        .convertUnit(
          to: selectedUnit,
          input: widget.breakEvenPrice,
        );
           

    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pricing Breakdown'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Calculated coffee selling price based on key costs.'
                                .tr,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12,),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CustomChip(
                          label: selectedUnit,
                          svgPath: 'assets/icons/birr.svg',
                          onTap: () {},
                          isCurrency: false,
                          isRegion: false,
                          isUnit: true,
                          onUnitSelected: (unit) {
                            setState(() {
                              selectedUnit = unit ?? 'KG';
                              convertedOutPutVolume = controller
                                  .convertUnit(
                                    to: selectedUnit,
                                    input: double.tryParse(
                                          widget.entry.cherryPurchase,
                                        )! *
                                        double.tryParse(widget.entry.ratio)!,
                                  )
                                  .toInt();
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        CustomChip(
                          label: exchangeController.selectedCurrency.value,
                          svgPath: 'assets/icons/birr.svg',
                          onTap: () {},
                          isCurrency: true,
                          isRegion: false,
                          onCurrencySelected: (currency) {
                            exchangeController.changeCurrency(currency ?? '');
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
            Text(
              'Overview'.tr,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            // Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: SummaryRow(
                      label: 'Conversion Ratio',
                      value:
                          '${(double.tryParse(widget.entry.ratio)!).toStringAsFixed(2)}%',
                      showCurrency: false,
                      valueColor: const Color(0xFF1AB98B),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SummaryRow(
                      label: 'Output Volume of ${widget.entry.sellingType}',
                      showCurrency: false,
                      value: convertedOutPutVolume.toStringAsFixed(2),
                      valueColor: const Color(0xFF1AB98B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Cost Breakdown'.tr,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Cost Breakdown Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Raw Material Cost',
                      value: exchangeController
                          .convertPrice(widget.entry.procurementTotal)
                          .toStringAsFixed(4),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Transport and Commision',
                      value: exchangeController
                          .convertPrice(widget.entry.transportTotal)
                          .toStringAsFixed(4),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Labour Cost',
                      value: exchangeController
                          .convertPrice(
                            widget.entry.casualTotal +
                                widget.entry.permanentTotal,
                          )
                          .toStringAsFixed(4),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Fuel And Oils Cost',
                      value: exchangeController
                          .convertPrice(widget.entry.fuelTotal)
                          .toStringAsFixed(4),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Maintenance & Equipement Cost',
                      value: exchangeController
                          .convertPrice(widget.entry.maintenanceTotal)
                          .toStringAsFixed(4),
                    ),
                  ),
                  const DashedDivider(
                    color: Color(0xFFE6E8EC),
                    height: 1,
                    dashWidth: 8,
                    dashSpace: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SummaryRow(
                      label: 'Total Other Expenses',
                      value: exchangeController
                          .convertPrice(widget.entry.otherTotal)
                          .toStringAsFixed(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Breakeven Price Section
            // Text(
            //   'Breakeven Price',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            Text(
              'Final Price'.tr,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Jute Bag Price'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF252B37),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${exchangeController.selectedCurrency} ${exchangeController.convertPrice(widget.entry.jutBagTotal).toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1AB98B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Expenses'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF252B37),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${exchangeController.selectedCurrency} ${exchangeController.convertPrice(widget.entry.variableCostTotal).toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1AB98B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SummaryRow(
                label: 'Pre-Tax Break-even Price',
                value: convertedPreTaxBreakEvenPrice.toStringAsFixed(2),
                valueColor: const Color(0xFF1AB98B),
                isBold: true,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryIconButton(
              text: 'Calculate Again',
              iconPath: 'assets/icons/calc.svg',
              onPressed: () {
                advancedCalculatorController.skipBestPracticeWarning = true;
                controller.selectedTab.value = 'Advanced';
                controller.goToTab(1);
                Get.to<void>(
                  () => MainView(
                    initialIndex: 1,
                    advancedCalcData: widget.entry,
                    type: ResultsOverviewType.advanced,
                  ),
                );
              },
              type: ButtonType.outlined,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ForecastResultsOverviewBody extends StatelessWidget {
  ForecastResultsOverviewBody({
    required this.totalMarketPrice,
    required this.cherryPrice,
    required this.selectedUnit,
    required this.selectedCoffeeType,
    super.key,
  });
  final double totalMarketPrice;
  final double cherryPrice;
  final String selectedUnit;
  final String selectedCoffeeType;
  final exchangeController = Get.find<ExchangeRateController>();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Cost Breakdown Summary',
                subtitle: 'Calculated coffee selling price based on key costs.',
                isCurrency: true,
                isRegion: false,
                showChip: true,
                chipLabel: exchangeController.selectedCurrency.value,
                chipSvgPath: 'assets/icons/birr.svg',
                onCurrencySelected: (value) {
                  exchangeController.changeCurrency(value ?? '');
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Summary Card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 12),
                    //   child: SummaryRow(
                    //     label: 'Total Calculated Price',
                    //     value: 'ETB ${totalMarketPrice.toStringAsFixed(2)}',
                    //   ),
                    // ),
                    // const DashedDivider(
                    //   color: Color(0xFFE6E8EC),
                    //   height: 1,
                    //   dashWidth: 8,
                    //   dashSpace: 4,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Obx(
                        () => SummaryRow(
                          label: 'Cherry Price',
                          showCurrency: false,
                          valueColor: const Color(0xFF00B3B0),
                          value: selectedCoffeeType == 'Dried pod/Jenfel'
                              ? '${exchangeController.convertPrice(cherryPrice).toStringAsFixed(2)} Birr - ${(exchangeController.convertPrice(cherryPrice) * 1.25).toStringAsFixed(2)} Birr / $selectedUnit'
                              : '${exchangeController.convertPrice(cherryPrice).toStringAsFixed(2)} / ${'KG'.tr}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
