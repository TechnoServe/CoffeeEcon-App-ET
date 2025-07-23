import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/Pages/auth/controllers/home_controllers.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/widgets/site_card.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/config/app_sizes.dart';

import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_title.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final homeController = Get.put(HomeControllers(), permanent: true);

  int _currentPage = 0;
  Timer? _autoSlideTimer;
  final List<String> imageUrls = [
    AppAssets.carouselOne,
    AppAssets.carouselTwo,
    AppAssets.carouselThree,
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();

    homeController.loadSites();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final nextPage = (_currentPage + 1) % imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutBack,
      );
      setState(() {
        _currentPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> sliderTexts = [
    {
      'title': 'Market Insights in Your Hands',
      'subtitle': 'Check real-time stock prices and make informed decisions',
    },
    {
      'title': 'New: Price Calculator',
      'subtitle': 'Plan your coffee business with advanced cost analysis tools',
    },
    {
      'title': 'Visit ECX Site',
      'subtitle':
          'Get insights and market trends on Ethiopian Commodity Exchange website',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final calcController = Get.put(CalculatorController(), permanent: true);
    final planController = Get.put(PlanController(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Remove default spacing
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.themeCyan,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.userIcon,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textWhite100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome'.tr,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.grey70,
                            ),
                      ),
                      Obx(
                        () => Text(
                          controller.userName.value ?? 'Guest',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.grey100,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: homeController.toggleLanguage,
                    child: Obx(
                      () => AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                                child: Image.asset(
                                  homeController.flagAsset,
                                  key: ValueKey(homeController.flagAsset),
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                                child: Text(
                                  homeController.languageText,
                                  key: ValueKey(homeController.languageText),
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: AppColors.textBlack60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final shouldExit = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Exit'.tr),
                          content:
                              Text('Are you sure you want to exit the app?'.tr),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Exit'.tr),
                            ),
                          ],
                        ),
                      );

                      if (shouldExit == true) {
                        SystemNavigator.pop();
                      }
                    },
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: Icon(
                              Icons.logout,
                              key: const ValueKey('exit-icon'),
                              size: 20,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: Text(
                              'Exit'.tr,
                              key: const ValueKey('exit-text'),
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 134,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final isActive = index == _currentPage;
                  final scale = isActive ? 1.0 : 0.95;

                  return Transform.scale(
                    scale: scale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.asset(
                            imageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (sliderTexts[index]['title'] ?? '').tr,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      (sliderTexts[index]['subtitle'] ?? '').tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.white70,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: AppSizes.pageHorizontalPadding,
            //   ),
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 24,
            //     ),
            //     decoration: BoxDecoration(
            //       color: AppColors.secondary,
            //       borderRadius: BorderRadius.circular(24),
            //     ),
            //     child: const Center(
            //       child: ComingSoon(),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pageHorizontalPadding,
              ),
              child: Column(
                children: [
                  //sites list
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppTitle(titleName: 'Sites'),
                            GestureDetector(
                              onTap: () =>
                                  {Get.toNamed<void>(AppRoutes.SITELIST)},
                              child: Text(
                                'seeAll'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (homeController.sites.isEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.coffeeCup),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'No Sites Added Yet'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textBlack100,
                                  ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Start by adding your first wet mill site to track and manage your operations'
                                  .tr,
                              style: Theme.of(context).textTheme.labelSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppButton(
                              text: 'Add Site',
                              width: 166.5,
                              height: 56,
                              onPressed: () => {
                                Get.toNamed<void>(
                                  AppRoutes.SITEREGISTRATION,
                                ),
                              },
                            ),
                          ],
                        ),
                      if (homeController.sites.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.18,
                          ),
                          itemCount: homeController.sites.length,
                          itemBuilder: (context, index) {
                            final site = homeController.sites[index];
                            return GestureDetector(
                              onTap: () {
                                calcController.loadCalculationsBySite(
                                  siteId: site.id,
                                );
                                planController.loadPlansBySite(
                                  siteId: site.id,
                                );
                                Get.toNamed<void>(
                                  AppRoutes.SITEDETAIL,
                                  arguments: {'site': site},
                                );
                              },
                              child: SiteCard(
                                site: site,
                                isForDashobard: true,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
