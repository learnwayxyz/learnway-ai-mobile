import 'package:json_annotation/json_annotation.dart';

part 'offramp_status_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OfframpStatusResponse {
  final bool success;
  final String message;
  final OfframpStatusData? data;

  OfframpStatusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OfframpStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OfframpStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfframpStatusResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OfframpStatusData {
  final String referenceId;
  final double fiatAmount;
  final double fiatTransactionAmount;
  final double cryptoAmount;
  final String fiatCurrency;
  final String customerKey;
  final String senderAddress;
  final String? transactionHash;
  final String status;
  final String onchainStatus;
  final Rate rate;
  final String escrowAddress;
  final bool usingIntegratedWallet;
  final DateTime created_at;
  final DateTime updated_at;

  OfframpStatusData({
    required this.referenceId,
    required this.fiatAmount,
    required this.fiatTransactionAmount,
    required this.cryptoAmount,
    required this.fiatCurrency,
    required this.customerKey,
    required this.senderAddress,
    this.transactionHash, // <-- optional
    required this.status,
    required this.onchainStatus,
    required this.rate,
    required this.escrowAddress,
    required this.usingIntegratedWallet,
    required this.created_at,
    required this.updated_at,
  });

  factory OfframpStatusData.fromJson(Map<String, dynamic> json) =>
      _$OfframpStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$OfframpStatusDataToJson(this);
}

@JsonSerializable()
class Rate {
  final String id;
  final String from;
  final String to;
  final String value;
  final double fiatAmount;
  final double transactionAmount;
  final double cryptoAmount;
  final double fee;

  Rate({
    required this.id,
    required this.from,
    required this.to,
    required this.value,
    required this.fiatAmount,
    required this.transactionAmount,
    required this.cryptoAmount,
    required this.fee,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);

  Map<String, dynamic> toJson() => _$RateToJson(this);
}
