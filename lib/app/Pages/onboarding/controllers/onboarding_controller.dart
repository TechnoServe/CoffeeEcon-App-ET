import 'package:flutter/material.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/routes/app_routes.dart';

class OnboardingController extends GetxController
    with GetTickerProviderStateMixin {
  final currentPage = 0.obs;
  final fullNameController = TextEditingController();
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;
  final List<OnboardingPage> pages = const [
    OnboardingPage(
      image: AppAssets.onboardingOne,
      title: 'Welcome',
      subTitle:
          'This app helps you streamline coffee operations, track pricing, and maximize profitability with powerful business tools',
    ),
    OnboardingPage(
      image: AppAssets.onboardingTwo,
      title: 'Convert Easily',
      subTitle:
          'Easily calculate coffee yield across all processing stages, from cherries to green coffee, with accurate conversion tools',
    ),
    OnboardingPage(
      image: AppAssets.onboardingThree,
      title: 'Market Insight',
      subTitle:
          'Stay updated with real-time coffee prices, track market trends, and compare regional rates to make better decisions',
    ),
    OnboardingPage(
      image: AppAssets.onboardingFour,
      title: 'Lets Begin',
      subTitle:
          'Set up to unlock full access to pricing tools, planning features, and market insights designed for coffee businesses',
    ),
  ];
  @override
  void onInit() {
    super.onInit();
    for (final page in pages) {
      precacheImage(AssetImage(page.image), Get.context!);
    }
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      fadeController.forward(); // Delayed fade-in of UI
    });
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      final nextImage = AssetImage(pages[currentPage.value + 1].image);
      precacheImage(nextImage, Get.context!);

      currentPage.value++;
    } else {
      Get.offAllNamed<void>(AppRoutes.AUTH);
    }
  }
}
