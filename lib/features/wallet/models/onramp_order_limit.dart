import 'package:json_annotation/json_annotation.dart';

part 'onramp_order_limit.g.dart';

@JsonSerializable()
class OnRampOrderLimit {
  OnRampOrderLimit({required this.deposit, required this.payout});

  final OnRampPayoutLimit deposit;
  final OnRampPayoutLimit payout;

  factory OnRampOrderLimit.fromJson(Map<String, dynamic> json) =>
      _$OnRampOrderLimitFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampOrderLimitToJson(this);
}

@JsonSerializable()
class OnRampPayoutLimit {
  OnRampPayoutLimit({
    required this.min,
    required this.max,
    required this.minUsd,
    required this.maxUsd,
  });

  final double min;
  final double max;
  final double minUsd;
  final double maxUsd;

  factory OnRampPayoutLimit.fromJson(Map<String, dynamic> json) =>
      _$OnRampPayoutLimitFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampPayoutLimitToJson(this);
}
