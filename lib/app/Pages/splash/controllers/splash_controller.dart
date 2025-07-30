import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/auth_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/onboarding_view.dart';
import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/core/services/secure_storage_service.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

/// Controller for managing the splash screen and app initialization flow.
///
/// This controller handles the initial app launch experience including:
/// - Splash screen animations and timing
/// - User authentication state checking
/// - First launch detection and onboarding flow
/// - Navigation to appropriate screen based on user state
///
/// The controller determines whether to show onboarding, authentication,
/// or the main app based on user data and first launch status.
class SplashController extends GetxController with GetTickerProviderStateMixin {
  /// Animation controller for logo scaling animation
  late final AnimationController imageController;
  /// Scale animation for logo entrance effect
  late final Animation<double> scaleAnimation;

  /// Whether the logo is currently visible on screen
  final isLogoVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize logo animation controller
    imageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create scale animation for logo entrance
    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: imageController,
        curve: Curves.easeOutBack,
      ),
    );

    // Delay before showing the logo and starting animation sequence
    Future.delayed(const Duration(seconds: 1), () {
      // Show logo and start animation
      isLogoVisible.value = true;
      imageController.forward().whenComplete(() async {
        // Wait for animation to complete before checking user state
        await Future<void>.delayed(const Duration(milliseconds: 1000));

        // Check user authentication and first launch status
        final hive = Get.find<UserService>();
        final user = hive.getCurrentUser();
        final isFirstLaunch =
            await Get.find<SecureStorageService>().isFirstLaunch();

        // Navigate to appropriate screen based on user state
        Get.offAll<void>(
          () {
            // Show onboarding for first-time users
            if (isFirstLaunch) return const OnboardingView();
            // Show authentication if no user or empty name
            if (user == null || user.fullName.isEmpty) return AuthView();
            // Show main app for authenticated users
            return MainView();
          },
          transition: Transition.fade,
          duration: const Duration(milliseconds: 600),
        );
      });
    });
  }

  @override
  void onClose() {
    // Dispose animation controller to prevent memory leaks
    imageController.dispose();
    super.onClose();
  }
}
