import 'package:json_annotation/json_annotation.dart';

part 'mobile_money_response.g.dart';

/// Mobile Money Deposit Response Model
@JsonSerializable(explicitToJson: true)
class MobileMoneyDepositResponse {
  final bool success;
  final String message;
  final MobileMoneyDepositData? data;

  MobileMoneyDepositResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MobileMoneyDepositResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyDepositResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyDepositResponseToJson(this);
}

@JsonSerializable()
class MobileMoneyDepositData {
  final String? id;
  final String? transactionId;
  final String? referenceId;
  final String? status;
  final String? statusDescription;
  final double? fiatAmount;
  final double? cryptoAmount;
  final String? receiverAddress;
  final String? redirectUrl;

  MobileMoneyDepositData({
    this.id,
    this.transactionId,
    this.referenceId,
    this.status,
    this.statusDescription,
    this.fiatAmount,
    this.cryptoAmount,
    this.receiverAddress,
    this.redirectUrl,
  });

  factory MobileMoneyDepositData.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyDepositDataFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyDepositDataToJson(this);
}
