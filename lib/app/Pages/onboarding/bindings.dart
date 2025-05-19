import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_template/app/Pages/wetMill/controllers/site_controller.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(OnboardingController.new);
    Get.lazyPut<SiteController>(SiteController.new);

    Get.lazyPut<AuthController>(AuthController.new);
  }
}
