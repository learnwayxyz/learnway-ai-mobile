// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRatesResponse _$ExchangeRatesResponseFromJson(
  Map<String, dynamic> json,
) => ExchangeRatesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ExchangeRatesData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExchangeRatesResponseToJson(
  ExchangeRatesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

ExchangeRatesData _$ExchangeRatesDataFromJson(Map<String, dynamic> json) =>
    ExchangeRatesData(
      baseCurrency: json['baseCurrency'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ExchangeRateEntry.fromJson(e as Map<String, dynamic>)),
      ),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );

Map<String, dynamic> _$ExchangeRatesDataToJson(ExchangeRatesData instance) =>
    <String, dynamic>{
      'baseCurrency': instance.baseCurrency,
      'rates': instance.rates.map((k, e) => MapEntry(k, e.toJson())),
      'cachedAt': instance.cachedAt.toIso8601String(),
    };

ExchangeRateEntry _$ExchangeRateEntryFromJson(Map<String, dynamic> json) =>
    ExchangeRateEntry(
      rate: (json['rate'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExchangeRateEntryToJson(ExchangeRateEntry instance) =>
    <String, dynamic>{
      'rate': instance.rate,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
