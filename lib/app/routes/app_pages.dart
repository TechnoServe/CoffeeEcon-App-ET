import 'package:flutter_template/app/Pages/auth/bindings.dart';
import 'package:flutter_template/app/Pages/calculator/bindings.dart';
import 'package:flutter_template/app/Pages/calculator/views/calculator_view.dart';
import 'package:flutter_template/app/Pages/calculator/views/results_overview_view.dart';
import 'package:flutter_template/app/Pages/calculator/views/saved_view.dart';
import 'package:flutter_template/app/Pages/converter/bindings.dart';
import 'package:flutter_template/app/Pages/converter/view/converter_view.dart';
import 'package:flutter_template/app/Pages/main/bindings.dart';
import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/auth_view.dart';
import 'package:flutter_template/app/Pages/auth/view/home_view.dart';
import 'package:flutter_template/app/Pages/onboarding/bindings.dart';
import 'package:flutter_template/app/Pages/onboarding/views/onboarding_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/onboarding_site_registration_view.dart';
import 'package:flutter_template/app/Pages/plan/bindings.dart';
import 'package:flutter_template/app/Pages/plan/views/operational_summary_view.dart';
import 'package:flutter_template/app/Pages/plan/views/plan_view.dart';
import 'package:flutter_template/app/Pages/splash/bindings.dart';
import 'package:flutter_template/app/Pages/splash/views/splash_view.dart';
import 'package:flutter_template/app/Pages/stock/bindings.dart';
import 'package:flutter_template/app/Pages/stock/views/stock_view_detail.dart';
import 'package:flutter_template/app/Pages/wetMill/bindings.dart';
import 'package:flutter_template/app/Pages/wetMill/view/site_detail.dart';
import 'package:flutter_template/app/Pages/wetMill/view/site_list.dart';
import 'package:flutter_template/app/Pages/wetMill/view/site_registration.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

/// Defines all application pages and their routes.
class AppPages {
  /// Private constructor to prevent instantiation.
  AppPages._();

  /// List of all app routes for navigation.
  static final routes = [
    GetPage<HomeView>(
      name: AppRoutes.INITIAL,
      page: HomeView.new,
      binding: HomeBindings(),
    ),
    GetPage<SplashView>(
      name: AppRoutes.SPLASH,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage<OnboardingView>(
      name: AppRoutes.ONBOARDING,
      page: OnboardingView.new,
      binding: OnboardingBinding(),
    ),
    GetPage<AuthView>(
      name: AppRoutes.AUTH,
      page: AuthView.new,
      binding: OnboardingBinding(),
    ),
    GetPage<OnboardingSiteRegistrationView>(
      name: AppRoutes.ONBOARDINGSITEREGISTRATION,
      page: OnboardingSiteRegistrationView.new,
      binding: OnboardingBinding(),
    ),
    GetPage<MainView>(
      name: AppRoutes.MAINVIEW,
      page: MainView.new,
      binding: MainViewBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.CONVERTER,
      page: ConverterView.new,
      binding: ConverterBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.SITEREGISTRATION,
      page: () {
        final site = Get.arguments?['site'] as SiteInfo?;
        final onBoardingSiteData =
            Get.arguments?['onBoardingSiteData'] as OnboardingSiteData?;

        return SiteRegistrationView(
          site: site,
          onBoardingSiteData: onBoardingSiteData,
        );
      },
      binding: WetMillBinding(),
    ),
    GetPage<MainView>(
      name: AppRoutes.SITELIST,
      page: SiteListView.new,
      binding: WetMillBinding(),
    ),
    GetPage<MainView>(
      name: AppRoutes.SITEDETAIL,
      page: () {
        final site = Get.arguments['site'] as SiteInfo;
        return SiteDetailView(site: site);
      },
      binding: WetMillBinding(),
    ),
    GetPage<MainView>(
      name: AppRoutes.STOCKDETAIL,
      page: () {
        final stock = Get.arguments['stock'];
        if (stock is Map<String, Object>) {
          return StockViewDetail(
            stock: stock,
            stockName: stock['name']! as String,
          );
        } else {
          throw ArgumentError(
            'Expected stock to be of type Map<String, Object>',
          );
        }
      },
      binding: StockBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.CALCULATOR,
      page: CalculatorView.new,
      binding: CalculatorBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.RESULTSOVERVIEWVIEW,
      page: () {
        //for basic
        final type = Get.arguments?['type'] as ResultsOverviewType;
        final basicCalcData =
            Get.arguments?['basicCalcData'] as BasicCalculationEntryModel?;
        final advancedCalcData =
            Get.arguments?['advancedCalcData'] as AdvancedCalculationModel?;

        final breakEvenPrice = Get.arguments?['breakEvenPrice'] as double?;
        final isBestPractice = Get.arguments?['isBestPractice'] as bool;

        //for forecast
        final totalMarketPrice = Get.arguments?['totalMarketPrice'] as double?;
        final cherryPrice = Get.arguments?['cherryPrice'] as double?;
        final selectedUnit = Get.arguments?['selectedUnit'] as String?;
        final selectedCoffeeType =
            Get.arguments?['selectedCoffeeType'] as String?;

        return ResultsOverviewView(
          type: type,
          basicCalcData: basicCalcData,
          advancedCalcData: advancedCalcData,
          breakEvenPrice: breakEvenPrice,
          totalMarketPrice: totalMarketPrice,
          cherryPrice: cherryPrice,
          isBestPractice: isBestPractice,
          selectedUnit: selectedUnit,
          selectedCoffeeType: selectedCoffeeType,
        );
      },
      binding: CalculatorBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.SAVEDVIEW,
      page: SavedView.new,
      binding: CalculatorBindings(),
    ),
    GetPage<MainView>(
      name: AppRoutes.OPERATIONAL_SUMMARY,
      page: () {
        final data = Get.arguments?['data'] as OperationalPlanningModel;
        final isFromTable = Get.arguments?['isFromTable'] as bool;

        return OperationalSummary(
          data: data,
          isFromTable: isFromTable,
        );
      },
      binding: PlanBinding(),
    ),
    GetPage<MainView>(
      name: AppRoutes.PLAN_VIEW,
      page: PlanView.new,
      binding: PlanBinding(),
    ),
  ];
}

/// Model for onboarding page content.
class OnboardingPage {
  /// Creates an [OnboardingPage] with image, title, and subtitle.
  const OnboardingPage({
    required this.image,
    required this.title,
    required this.subTitle,
  });

  /// The image asset for the onboarding page.
  final String image;

  /// The title text.
  final String title;

  /// The subtitle text.
  final String subTitle;
}

/// Model for onboarding site data.
class OnboardingSiteData {
  /// Creates an [OnboardingSiteData] with site name, location, and business model.
  const OnboardingSiteData({
    required this.siteName,
    required this.locationValue,
    required this.businessModelValue,
  });

  /// The name of the site.
  final String siteName;

  /// The location value.
  final String locationValue;

  /// The business model value.
  final String businessModelValue;
}
