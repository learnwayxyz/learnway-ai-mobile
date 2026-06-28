// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_order_limit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampOrderLimit _$OnRampOrderLimitFromJson(
  Map<String, dynamic> json,
) => OnRampOrderLimit(
  deposit: OnRampPayoutLimit.fromJson(json['deposit'] as Map<String, dynamic>),
  payout: OnRampPayoutLimit.fromJson(json['payout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnRampOrderLimitToJson(OnRampOrderLimit instance) =>
    <String, dynamic>{'deposit': instance.deposit, 'payout': instance.payout};

OnRampPayoutLimit _$OnRampPayoutLimitFromJson(Map<String, dynamic> json) =>
    OnRampPayoutLimit(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      minUsd: (json['minUsd'] as num).toDouble(),
      maxUsd: (json['maxUsd'] as num).toDouble(),
    );

Map<String, dynamic> _$OnRampPayoutLimitToJson(OnRampPayoutLimit instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'minUsd': instance.minUsd,
      'maxUsd': instance.maxUsd,
    };
