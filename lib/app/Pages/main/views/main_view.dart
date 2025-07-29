import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/app/Pages/auth/view/home_view.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/views/calculator_view.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/Pages/converter/view/converter_view.dart';
import 'package:flutter_template/app/Pages/main/controllers/nav_controller.dart';
 import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/Pages/plan/views/plan_view.dart';
import 'package:flutter_template/app/shared/widgets/app_bottom_nav.dart';
import 'package:get/get.dart';
import 'package:flutter_template/app/Pages/stock/views/stock_view.dart';

class MainView extends GetView<NavController> {
  MainView({
    super.key,
    int? initialIndex,
    this.basicCalcData,
    this.advancedCalcData,
    this.type = ResultsOverviewType.basic,
  }) {
    if (initialIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navController = Get.find<NavController>();
        navController.currentIndex.value = initialIndex;
      });
    }
  }

  final BasicCalculationEntryModel? basicCalcData;
  final AdvancedCalculationModel? advancedCalcData;

  final ResultsOverviewType type;

  late final List<Widget> pages = [
    HomeView(),
    CalculatorView(
      basicCalcData: basicCalcData,
      advancedCalcData: advancedCalcData,
      type: type,
    ),
    const ConverterView(),
    const PlanView(),
    const StockView(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController(), permanent: true);
    void handleTabChange(int index) {
      // Force dispose ConverterController when navigating away
      if (index != 2) {
        Get.delete<ConverterController>(force: true);
        Get.delete<HistoryController>(force: true);
        Get.put<HistoryController>(HistoryController(), permanent: true);
        Get.put<ConverterController>(ConverterController(), permanent: true);
      }
      if (index != 1) {
        Get.delete<CalculatorController>(force: true);
        Get.put<CalculatorController>(CalculatorController(), permanent: true);
      }

      controller.currentIndex.value = index;
    }

    return WillPopScope(
      onWillPop: () async {
        print(
            'Back button pressed, currentIndex: ${controller.currentIndex.value}');
        if (controller.currentIndex.value != 0) {
          controller.currentIndex.value = 0;
          return false; // Prevent app exit
        } else {
          // Show confirmation dialog on home page
          final bool? shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirm Exit'.tr),
              content: Text('Are you sure you want to exit the app?'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: SystemNavigator.pop,
                  child: Text('Exit'.tr),
                ),
              ],
            ),
          );
          return shouldExit ?? false; // Return false if dialog is dismissed
        }
      },
      child: Obx(
        () => AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: pages[controller.currentIndex.value],
            bottomNavigationBar: AppBottomNav(
              selectedIndex: controller.currentIndex.value,
              onTap: handleTabChange,
            ),
          ),
        ),
      ),
    );
  }
}
