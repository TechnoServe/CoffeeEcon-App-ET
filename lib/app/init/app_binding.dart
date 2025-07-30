import 'package:dio/dio.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/core/network/api_client.dart';
import 'package:flutter_template/app/core/services/secure_storage_service.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:flutter_template/app/shared/controllers/exchange_rate_controller.dart';
import 'package:get/get.dart';

/// Dependency injection bindings for the application.
/// This class sets up all the dependencies that need to be available
/// throughout the app using GetX dependency injection.
class AppBindings extends Bindings {
  /// Configures all dependencies for the application.
  /// This method is called during app initialization to register
  /// all services, controllers, and other dependencies with GetX.
  @override
  void dependencies() {
    // Core network setup
    // Register the configured Dio instance for API requests
    Get.put<Dio>(ApiClient.createDio());

    // App-wide Services
    // Register secure storage service for sensitive data persistence
    Get.put<SecureStorageService>(SecureStorageService());

    // Global Controllers
    // Register authentication controller for user management
    Get.put<AuthController>(AuthController());
    // Register history controller for managing conversion history
    Get.put<HistoryController>(HistoryController());
    // Register converter controller for currency conversion functionality
    Get.put<ConverterController>(ConverterController());
    // Register exchange rate controller for managing exchange rates
    Get.put<ExchangeRateController>(ExchangeRateController());
  }
}
