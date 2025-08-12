import 'package:dio/dio.dart';
import 'package:flutter_template/app/data/models/exchange_rate.dart';
import 'package:hive/hive.dart';

/// Service for fetching and caching currency exchange rates.
class ExchangeRateService {
  /// The Dio HTTP client used for API requests.
  final Dio dio;

  /// Creates an [ExchangeRateService] with the given [dio] client.
  ExchangeRateService(this.dio);

  final String _apiUrl = 'https://api.nbe.gov.et/api/filter-exchange-rates';

  /// Fetches exchange rates for the given [date] from the API.
  /// Falls back to cached rates if the API call fails.
  Future<List<ExchangeRate>> fetchRates({required String date}) async {
    try {
      final response = await dio.get('$_apiUrl?date=$date');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;

        final rates = data
            .map((e) => ExchangeRate.fromJson(e as Map<String, dynamic>))
            .toList();

        // Cache the fetched rates
        await cacheRates(rates);
        return rates;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        // Fallback to cached rates
        return await getCachedRates();
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      // Fallback to cached rates
      return await getCachedRates();
    }
  }

  /// Caches a list of [rates] locally using Hive.
  Future<void> cacheRates(List<ExchangeRate> rates) async {
    final box = await Hive.openBox('exchange_rates');
    for (var rate in rates) {
      box.put(rate.code, {
        'buying': rate.buying,
        'selling': rate.selling,
      });
    }
  }

  /// Retrieves cached exchange rates from local storage.
  Future<List<ExchangeRate>> getCachedRates() async {
    final box = await Hive.openBox('exchange_rates');
    if (box.isEmpty) {
      print('No cached rates available');
      return []; // Return empty list if no cached data
    }
    return box.keys.map((key) {
      final data = box.get(key) as Map<dynamic, dynamic>;
      return ExchangeRate(
        code: key as String,
        buying: (data['buying'] as num).toDouble(),
        selling: (data['selling'] as num).toDouble(),
      );
    }).toList();
  }
}