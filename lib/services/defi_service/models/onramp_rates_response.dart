import 'package:json_annotation/json_annotation.dart';

part 'onramp_rates_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OnRampRateResponse {
  final bool success;
  final String message;
  final OnRampRateData data;

  OnRampRateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OnRampRateResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampRateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampRateResponseToJson(this);
}

@JsonSerializable()
class OnRampRateData {
  final String from;
  final String to;
  final String value;
  final String id;
  final double fiatAmount;
  final double cryptoAmount;
  final double transactionAmount;
  final double fee;

  OnRampRateData({
    required this.from,
    required this.to,
    required this.value,
    required this.id,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.transactionAmount,
    required this.fee,
  });

  factory OnRampRateData.fromJson(Map<String, dynamic> json) =>
      _$OnRampRateDataFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampRateDataToJson(this);
}
