import 'package:flutter_template/app/core/services/exchange_rate_service.dart';
import 'package:flutter_template/app/data/models/exchange_rate.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

/// Controller for managing exchange rates and currency conversion.
/// This controller handles fetching, caching, and converting exchange rates
/// to support multi-currency functionality throughout the app.
class ExchangeRateController extends GetxController {
  /// The exchange rate service used to fetch and cache rates.
  /// This service handles API calls and local storage for exchange rate data.
  late final ExchangeRateService _service;

  /// List of available exchange rates.
  /// Observable list that automatically updates UI when rates change.
  var rates = <ExchangeRate>[].obs;

  /// The currently selected currency code.
  /// Defaults to ETB (Ethiopian Birr) and updates UI when changed.
  var selectedCurrency = 'ETB'.obs;

  /// Whether exchange rates are being loaded.
  /// Used to show loading indicators in the UI during rate fetching.
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the exchange rate service with the Dio HTTP client
    _service = ExchangeRateService(Get.find<Dio>());
    // Load exchange rates immediately when controller is initialized
    loadRates();
  }

  /// Loads exchange rates from the service or cache.
  /// Attempts to fetch fresh rates from the API, falls back to cached rates
  /// if the API call fails. This ensures the app works offline.
  Future<void> loadRates() async {
    isLoading.value = true;
    try {
      // Get today's date in ISO format for API request
      final today = DateTime.now().toIso8601String().split('T').first;
      // Fetch fresh exchange rates from the API
      final fetchedRates = await _service.fetchRates(date: today);
      // Update the observable rates list with fresh data
      rates.assignAll(fetchedRates);
      // Cache the fresh rates for offline use
      await _service.cacheRates(fetchedRates);
    } catch (_) {
      // If API call fails, load cached rates as fallback
      final cachedRates = await _service.getCachedRates();
      rates.assignAll(cachedRates);
    } finally {
      // Always stop loading indicator regardless of success/failure
      isLoading.value = false;
    }
  }

  /// Converts a price in ETB to the selected currency.
  /// Uses the buying rate for conversion calculations.
  /// 
  /// [priceInETB] - The price in Ethiopian Birr to convert
  /// Returns the converted price in the selected currency
  double convertPrice(double priceInETB) {
    // If selected currency is ETB, no conversion needed
    if (selectedCurrency.value == 'ETB') return priceInETB;
    
    // Find the exchange rate for the selected currency
    // Default to USD with 1.0 rate if currency not found
    final rate = rates.firstWhere(
      (rate) => rate.code == selectedCurrency.value,
      orElse: () => ExchangeRate(code: 'USD', buying: 1.0, selling: 1.0),
    );
    print({'selected currency-------*****************************F',priceInETB,rate.buying,selectedCurrency.value});
    
    // Convert using the buying rate (rate at which bank buys foreign currency)
    return priceInETB / rate.buying;
  }

  /// Changes the selected currency code.
  /// Updates the observable currency selection and triggers UI updates.
  /// 
  /// [currencyCode] - The new currency code to select (e.g., 'USD', 'EUR')
  void changeCurrency(String currencyCode) {
    selectedCurrency.value = currencyCode;
  }
}
