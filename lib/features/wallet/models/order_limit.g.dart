// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_limit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLimit _$OrderLimitFromJson(Map<String, dynamic> json) => OrderLimit(
  deposit: PayoutLimit.fromJson(json['deposit'] as Map<String, dynamic>),
  payout: PayoutLimit.fromJson(json['payout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderLimitToJson(OrderLimit instance) =>
    <String, dynamic>{'deposit': instance.deposit, 'payout': instance.payout};

PayoutLimit _$PayoutLimitFromJson(Map<String, dynamic> json) => PayoutLimit(
  min: (json['min'] as num).toDouble(),
  max: (json['max'] as num).toDouble(),
  minUsd: (json['minUsd'] as num).toDouble(),
  maxUsd: (json['maxUsd'] as num).toDouble(),
);

Map<String, dynamic> _$PayoutLimitToJson(PayoutLimit instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'minUsd': instance.minUsd,
      'maxUsd': instance.maxUsd,
    };
