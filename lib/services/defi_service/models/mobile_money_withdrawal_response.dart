import 'package:json_annotation/json_annotation.dart';

part 'mobile_money_withdrawal_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MobileMoneyWithdrawalResponse {
  final bool success;
  final String message;
  final MobileMoneyWithdrawalData? data;

  MobileMoneyWithdrawalResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MobileMoneyWithdrawalResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyWithdrawalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyWithdrawalResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MobileMoneyWithdrawalData {
  MobileMoneyWithdrawalData({
    this.referenceId,
    this.fiatAmount,
    this.fiatTransactionAmount,
    this.cryptoAmount,
    this.fiatCurrency,
    this.customerKey,
    this.senderAddress,
    this.status,
    this.onchainStatus,
    this.rate,
    this.escrowAddress,
    this.usingIntegratedWallet,
    this.redirectUrl,
    this.created_at,
    this.updated_at,
  });

  final String? referenceId;
  final double? fiatAmount;
  final double? fiatTransactionAmount;
  final double? cryptoAmount;
  final String? fiatCurrency;
  final String? customerKey;
  final String? senderAddress;
  final String? status;
  final String? onchainStatus;
  final RateInfo? rate;
  final String? escrowAddress;
  final bool? usingIntegratedWallet;
  final String? redirectUrl;
  final String? created_at;
  final String? updated_at;

  factory MobileMoneyWithdrawalData.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyWithdrawalDataFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyWithdrawalDataToJson(this);
}

@JsonSerializable()
class RateInfo {
  RateInfo({
    this.id,
    this.from,
    this.to,
    this.value,
    this.fiatAmount,
    this.transactionAmount,
    this.cryptoAmount,
    this.fee,
  });

  final String? id;
  final String? from;
  final String? to;
  final String? value;
  final double? fiatAmount;
  final double? transactionAmount;
  final double? cryptoAmount;
  final double? fee;

  factory RateInfo.fromJson(Map<String, dynamic> json) =>
      _$RateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RateInfoToJson(this);
}

// Keep your FiatCurrency enum for other uses if needed
@JsonEnum(alwaysCreate: true)
enum FiatCurrency {
  @JsonValue('KES')
  kes,
  @JsonValue('GHS')
  ghs,
  @JsonValue('TZS')
  tzs,
  @JsonValue('UGX')
  ugx,
  @JsonValue('ZMW')
  zmw,
  @JsonValue('XAF')
  xaf,
  @JsonValue('XOF')
  xof,
  @JsonValue('CDF')
  cdf,
  @JsonValue('RWF')
  rwf,
  @JsonValue('ETB')
  etb,
  @JsonValue('ZAR')
  zar,
}
