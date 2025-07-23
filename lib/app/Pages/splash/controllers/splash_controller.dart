import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/auth_view.dart';
import 'package:flutter_template/app/Pages/onboarding/views/onboarding_view.dart';
import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/core/services/secure_storage_service.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController imageController;
  late final Animation<double> scaleAnimation;

  final isLogoVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    imageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: imageController,
        curve: Curves.easeOutBack,
      ),
    );

    // Delay before showing the logo
    Future.delayed(const Duration(seconds: 1), () {
      isLogoVisible.value = true;
      imageController.forward().whenComplete(() async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));

        final hive = Get.find<UserService>();
        final user = hive.getCurrentUser();
        final isFirstLaunch =
            await Get.find<SecureStorageService>().isFirstLaunch();

        Get.offAll<void>(
          () {
            if (isFirstLaunch) return const OnboardingView();
            if (user == null || user.fullName.isEmpty) return AuthView();
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
    imageController.dispose();
    super.onClose();
  }
}
