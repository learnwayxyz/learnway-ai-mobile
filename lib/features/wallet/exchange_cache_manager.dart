import 'package:learnwayv2/features/wallet/wallet_data_source/wallet_data_source.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

class ExchangeRateCacheManager {
  static const int _cacheDurationDays = 3;

  static Future<bool> hasFreshRates() async {
    final rates = await LocalStorageService.getExchangeRates();
    final shouldUpdate = await LocalStorageService.shouldUpdateExchangeRates();

    return rates != null && rates.isNotEmpty && !shouldUpdate;
  }

  static Future<Map<String, dynamic>> getRatesWithFallback() async {
    if (await hasFreshRates()) {
      final cachedRates = await LocalStorageService.getExchangeRates();
      if (cachedRates != null) {
        return cachedRates;
      }
    }

    try {
      final freshRates = await WalletDataSource().getExchangeRates();
      await LocalStorageService.saveExchangeRates(freshRates);
      return freshRates;
    } catch (e) {
      final cachedRates = await LocalStorageService.getExchangeRates();
      if (cachedRates != null && cachedRates.isNotEmpty) {
        return cachedRates;
      }

      throw Exception(
        'Failed to fetch exchange rates and no cached rates available',
      );
    }
  }

  static Future<Map<String, dynamic>> forceRefreshRates() async {
    final freshRates = await WalletDataSource().getExchangeRates();
    await LocalStorageService.saveExchangeRates(freshRates);
    return freshRates;
  }

  static Future<Map<String, dynamic>> getCacheStatus() async {
    final lastUpdate = await LocalStorageService.getExchangeRatesLastUpdate();
    final cachedRates = await LocalStorageService.getExchangeRates();
    final shouldUpdate = await LocalStorageService.shouldUpdateExchangeRates();

    return {
      'hasCachedRates': cachedRates != null && cachedRates.isNotEmpty,
      'lastUpdate': lastUpdate?.toIso8601String(),
      'shouldUpdate': shouldUpdate,
      'daysSinceUpdate': lastUpdate != null
          ? DateTime.now().difference(lastUpdate).inDays
          : null,
      'cacheExpiresIn': lastUpdate != null
          ? _cacheDurationDays - DateTime.now().difference(lastUpdate).inDays
          : null,
    };
  }

  static Future<void> clearCache() async {
    await LocalStorageService.clearExchangeRates();
  }
}
