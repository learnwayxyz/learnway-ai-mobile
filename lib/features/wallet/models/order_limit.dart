import 'package:json_annotation/json_annotation.dart';

part 'order_limit.g.dart';

@JsonSerializable()
class OrderLimit {
  OrderLimit({required this.deposit, required this.payout});

  final PayoutLimit deposit;
  final PayoutLimit payout;

  factory OrderLimit.fromJson(Map<String, dynamic> json) =>
      _$OrderLimitFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLimitToJson(this);
}

@JsonSerializable()
class PayoutLimit {
  PayoutLimit({
    required this.min,
    required this.max,
    required this.minUsd,
    required this.maxUsd,
  });

  final double min;
  final double max;
  final double minUsd;
  final double maxUsd;

  factory PayoutLimit.fromJson(Map<String, dynamic> json) =>
      _$PayoutLimitFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutLimitToJson(this);
}
