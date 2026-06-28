import 'package:json_annotation/json_annotation.dart';

part 'exchange_rates_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ExchangeRatesResponse {
  final bool success;
  final String message;
  final ExchangeRatesData data;

  ExchangeRatesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRatesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExchangeRatesData {
  final String baseCurrency;
  final Map<String, ExchangeRateEntry> rates;
  final DateTime cachedAt;

  ExchangeRatesData({
    required this.baseCurrency,
    required this.rates,
    required this.cachedAt,
  });

  factory ExchangeRatesData.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRatesDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRatesDataToJson(this);

  /// Converts to flat map: {"USDNGN": 1343.39, "USDKES": 129.01, ...}
  Map<String, double> toFlatRatesMap() {
    return rates.map(
      (currency, entry) => MapEntry('USD$currency', entry.rate),
    );
  }
}

@JsonSerializable()
class ExchangeRateEntry {
  final double rate;
  final DateTime updatedAt;

  ExchangeRateEntry({
    required this.rate,
    required this.updatedAt,
  });

  factory ExchangeRateEntry.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateEntryToJson(this);
}
