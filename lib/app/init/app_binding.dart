import 'package:dio/dio.dart';
import 'package:flutter_template/app/Pages/converter/controllers/converter_controller.dart';
import 'package:flutter_template/app/Pages/converter/controllers/history_controller.dart';
import 'package:flutter_template/app/core/network/api_client.dart';
import 'package:flutter_template/app/core/services/secure_storage_service.dart';
import 'package:flutter_template/app/Pages/onboarding/controllers/auth_controller.dart';
import 'package:flutter_template/app/shared/controllers/exchange_rate_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core network setup
    Get.put<Dio>(ApiClient.createDio());

    // App-wide Services
    Get.put<SecureStorageService>(SecureStorageService());

    // Global Controller
    Get.put<AuthController>(AuthController());
    Get.put<HistoryController>(HistoryController());
    Get.put<ConverterController>(ConverterController());
    Get.put<ExchangeRateController>(ExchangeRateController());
  }
}
