import 'package:json_annotation/json_annotation.dart';

part 'offramp_rates_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OffRampRatesResponse {
  OffRampRatesResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  final bool success;
  final String message;
  final OffRampRateData data;

  factory OffRampRatesResponse.fromJson(Map<String, dynamic> json) =>
      _$OffRampRatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OffRampRatesResponseToJson(this);

  OffRampRatesResponse copyWith({
    bool? success,
    String? message,
    OffRampRateData? data,
  }) {
    return OffRampRatesResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

@JsonSerializable()
class OffRampRateData {
  OffRampRateData({
    required this.from,
    required this.to,
    required this.value,
    required this.id,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.transactionAmount,
    required this.fee,
    this.redirectUrl,
  });

  final String from;
  final String to;
  final String value;
  final String id;
  final double fiatAmount;
  final double cryptoAmount;
  final double transactionAmount;
  final double fee;
  final String? redirectUrl;

  factory OffRampRateData.fromJson(Map<String, dynamic> json) =>
      _$OffRampRateDataFromJson(json);

  Map<String, dynamic> toJson() => _$OffRampRateDataToJson(this);

  OffRampRateData copyWith({
    String? from,
    String? to,
    String? value,
    String? id,
    double? fiatAmount,
    double? cryptoAmount,
    double? transactionAmount,
    double? fee,
    String? redirectUrl,
  }) {
    return OffRampRateData(
      from: from ?? this.from,
      to: to ?? this.to,
      value: value ?? this.value,
      id: id ?? this.id,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      cryptoAmount: cryptoAmount ?? this.cryptoAmount,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      fee: fee ?? this.fee,
      redirectUrl: redirectUrl ?? this.redirectUrl,
    );
  }
}
