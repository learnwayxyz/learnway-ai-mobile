import 'package:json_annotation/json_annotation.dart';

part 'onramp_status_response.g.dart';

/// OnRamp Crypto Status Response Model
@JsonSerializable(explicitToJson: true)
class OnRampStatusResponse {
  final bool success;
  final String message;
  final OnRampStatusData data;

  OnRampStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OnRampStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampStatusResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OnRampStatusData {
  final String referenceId;
  final String status;
  final double cryptoAmount;
  final double cryptoAmountReceived;
  final double feeInCrypto;
  final String feeType;
  final String cryptoWallet;
  final ChainInfo chain;
  final TokenInfo token;
  final String transactionHash;

  OnRampStatusData({
    required this.referenceId,
    required this.status,
    required this.cryptoAmount,
    required this.cryptoAmountReceived,
    required this.feeInCrypto,
    required this.feeType,
    required this.cryptoWallet,
    required this.chain,
    required this.token,
    required this.transactionHash,
  });

  factory OnRampStatusData.fromJson(Map<String, dynamic> json) =>
      _$OnRampStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampStatusDataToJson(this);
}

@JsonSerializable()
class ChainInfo {
  final String? id;
  final String? name;
  final String? code;
  final String? icon;

  ChainInfo({this.id, this.name, this.code, this.icon});

  factory ChainInfo.fromJson(Map<String, dynamic> json) =>
      _$ChainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChainInfoToJson(this);
}

@JsonSerializable()
class TokenInfo {
  final String? id;
  final String? name;
  final String? code;
  final String? icon;
  final String? contractAddress;

  TokenInfo({this.id, this.name, this.code, this.icon, this.contractAddress});

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);
}
