// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_rates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampRateResponse _$OnRampRateResponseFromJson(Map<String, dynamic> json) =>
    OnRampRateResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OnRampRateData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OnRampRateResponseToJson(OnRampRateResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

OnRampRateData _$OnRampRateDataFromJson(Map<String, dynamic> json) =>
    OnRampRateData(
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      id: json['id'] as String,
      fiatAmount: (json['fiatAmount'] as num).toDouble(),
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      transactionAmount: (json['transactionAmount'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
    );

Map<String, dynamic> _$OnRampRateDataToJson(OnRampRateData instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'id': instance.id,
      'fiatAmount': instance.fiatAmount,
      'cryptoAmount': instance.cryptoAmount,
      'transactionAmount': instance.transactionAmount,
      'fee': instance.fee,
    };
