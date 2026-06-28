import 'dart:convert';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:core/src/config/env/env.dart';

class CurrencyExchangeService {
  static Future<Map<String, double>> fetchExchangeRates() async {
    final response = BaseApiClients(baseUrl: Env.exchangeApi);
    final data = await response.get(
      '/live?access_key=${Env.exchangeApiKey}&currencies=NGN,GHS,KES,ZAR,USD,GBP',
    );
    final val = json.decode(data.body)['quotes'];
    final ratesMap = Map<String, double>.from(val);
    final rates = ratesMap.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    log('Exchange rates: $rates');

    return rates;
  }

  /// Converts an amount from USD to the specified target currency
  static double convertFromUSD(
    double usdAmount,
    String targetCurrency,
    Map<String, dynamic> exchangeRates,
  ) {
    if (targetCurrency == 'USD') return usdAmount;

    final rateKey = 'USD$targetCurrency';
    final rate = exchangeRates[rateKey]?.toDouble() ?? 1.0;

    return usdAmount * rate;
  }

  static double convertToUSD(
    double amount,
    String fromCurrency,
    Map<String, dynamic> exchangeRates,
  ) {
    if (fromCurrency == 'USD') return amount;

    final rateKey = 'USD$fromCurrency';
    final rate = exchangeRates[rateKey]?.toDouble() ?? 1.0;

    return amount / rate;
  }

  static double convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
    Map<String, dynamic> exchangeRates,
  ) {
    if (fromCurrency == toCurrency) return amount;

    final usdAmount = convertToUSD(amount, fromCurrency, exchangeRates);
    return convertFromUSD(usdAmount, toCurrency, exchangeRates);
  }

  static String getCurrencyCodeForCountry(String country) {
    return countryToCurrency[_getCountryCode(country)] ?? 'USD';
  }

  static String _getCountryCode(String countryName) {
    switch (countryName) {
      case 'Nigeria':
        return 'NG';
      case 'Ghana':
        return 'GH';
      case 'Kenya':
        return 'KE';
      case 'South Africa':
        return 'ZA';
      case 'United Kingdom':
        return 'UK';
      case 'United States':
      default:
        return 'US';
    }
  }

  static const countryToCurrency = {
    'NG': 'U+20A6',
    'GH': 'U+20B5',
    'KE': 'KSh',
    'ZA': 'R',
    'US': 'U+0024',
    'UK': 'U+00A3',
  };

  static const currencySymbols = {
    'NGN': 'U+20A6',
    'GHS': 'U+20B5',
    'KES': 'KSh',
    'ZAR': 'R',
    'USD': 'U+0024',
    'GBP': 'U+00A3',
  };

  static String getCurrencySymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? '\$';
  }
}
