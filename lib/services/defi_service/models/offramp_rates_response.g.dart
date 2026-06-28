// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offramp_rates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffRampRatesResponse _$OffRampRatesResponseFromJson(
  Map<String, dynamic> json,
) => OffRampRatesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: OffRampRateData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OffRampRatesResponseToJson(
  OffRampRatesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

OffRampRateData _$OffRampRateDataFromJson(Map<String, dynamic> json) =>
    OffRampRateData(
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      id: json['id'] as String,
      fiatAmount: (json['fiatAmount'] as num).toDouble(),
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      transactionAmount: (json['transactionAmount'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      redirectUrl: json['redirectUrl'] as String?,
    );

Map<String, dynamic> _$OffRampRateDataToJson(OffRampRateData instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'id': instance.id,
      'fiatAmount': instance.fiatAmount,
      'cryptoAmount': instance.cryptoAmount,
      'transactionAmount': instance.transactionAmount,
      'fee': instance.fee,
      'redirectUrl': instance.redirectUrl,
    };
