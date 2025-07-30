import 'package:flutter_template/app/Pages/auth/controllers/home_controllers.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:get/get.dart';

/// Dependency injection bindings for the home/auth pages.
/// This class sets up controllers that are specifically needed
/// for the home and authentication-related pages using lazy loading.
class HomeBindings extends Bindings {
  /// Configures dependencies for home and auth pages.
  /// This method registers controllers using lazy loading to improve
  /// performance by only initializing them when needed.
  @override
  void dependencies() {
    // Register authentication controller for user management
    Get.lazyPut<AuthController>(AuthController.new);
    // Register home controllers for main page functionality
    Get.lazyPut<HomeControllers>(HomeControllers.new);
    // Register calculator controller for calculation features
    Get.lazyPut<CalculatorController>(CalculatorController.new);
  }
}
