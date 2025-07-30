import 'package:flutter/material.dart';
import 'package:flutter_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/routes/app_routes.dart';

/// Controller for managing the app onboarding flow and user introduction.
///
/// This controller handles the multi-step onboarding process including:
/// - Page navigation through onboarding slides
/// - Animation management for smooth transitions
/// - Image preloading for optimal performance
/// - Navigation to authentication after onboarding completion
///
/// The controller provides a smooth introduction to the app's features
/// and guides users through the initial setup process.
class OnboardingController extends GetxController
    with GetTickerProviderStateMixin {
  /// Currently displayed onboarding page index
  final currentPage = 0.obs;
  /// Text controller for user name input (if needed during onboarding)
  final fullNameController = TextEditingController();
  /// Animation controller for fade transitions between pages
  late final AnimationController fadeController;
  /// Fade animation for smooth page transitions
  late final Animation<double> fadeAnimation;
  
  /// List of onboarding pages with their content and assets
  /// Each page contains an image, title, and subtitle explaining app features
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
    // Preload all onboarding images for smooth transitions
    for (final page in pages) {
      precacheImage(AssetImage(page.image), Get.context!);
    }
    
    // Initialize fade animation controller
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    // Start fade-in animation after a brief delay
    Future.delayed(const Duration(milliseconds: 400), () {
      fadeController.forward(); // Delayed fade-in of UI
    });
  }

  /// Advances to the next onboarding page or completes the onboarding flow.
  ///
  /// If there are more pages to show, advances to the next page and preloads
  /// the next image. If all pages have been shown, navigates to the authentication screen.
  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      // Preload the next image for smooth transition
      final nextImage = AssetImage(pages[currentPage.value + 1].image);
      precacheImage(nextImage, Get.context!);

      // Advance to next page
      currentPage.value++;
    } else {
      // Complete onboarding and navigate to authentication
      Get.offAllNamed<void>(AppRoutes.AUTH);
    }
  }
}
