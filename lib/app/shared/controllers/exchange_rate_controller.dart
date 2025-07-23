import 'package:flutter_template/app/core/services/exchange_rate_service.dart';
import 'package:flutter_template/app/data/models/exchange_rate.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

/// Controller for managing exchange rates and currency conversion.
class ExchangeRateController extends GetxController {
  /// The exchange rate service used to fetch and cache rates.
  late final ExchangeRateService _service;

  /// List of available exchange rates.
  var rates = <ExchangeRate>[].obs;

  /// The currently selected currency code.
  var selectedCurrency = 'ETB'.obs;

  /// Whether exchange rates are being loaded.
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service = ExchangeRateService(Get.find<Dio>());
    loadRates();
  }

  /// Loads exchange rates from the service or cache.
  Future<void> loadRates() async {
    isLoading.value = true;
    try {
      final today = DateTime.now().toIso8601String().split('T').first;
      final fetchedRates = await _service.fetchRates(date: today);
      rates.assignAll(fetchedRates);
      await _service.cacheRates(fetchedRates);
    } catch (_) {
      final cachedRates = await _service.getCachedRates();
      rates.assignAll(cachedRates);
    } finally {
      isLoading.value = false;
    }
  }

  /// Converts a price in ETB to the selected currency.
  double convertPrice(double priceInETB) {
    if (selectedCurrency.value == 'ETB') return priceInETB;
    final rate = rates.firstWhere(
      (rate) => rate.code == selectedCurrency.value,
      orElse: () => ExchangeRate(code: 'USD', buying: 1.0, selling: 1.0),
    );
    return priceInETB / rate.buying;
  }

  /// Changes the selected currency code.
  void changeCurrency(String currencyCode) {
    selectedCurrency.value = currencyCode;
  }
}
