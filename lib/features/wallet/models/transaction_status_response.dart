import 'package:json_annotation/json_annotation.dart';

part 'transaction_status_response.g.dart';

@JsonSerializable()
class TransactionStatusResponse {
  TransactionStatusResponse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.fonbnkOrderId,
    required this.type,
    required this.status,
    required this.cryptoCurrency,
    required this.cryptoNetwork,
    required this.cryptoAmount,
    required this.cryptoWalletAddress,
    this.cryptoTxHash,
    required this.fiatCurrency,
    required this.fiatAmount,
    required this.payoutChannel,
    this.payoutAccountNumber,
    this.payoutAccountName,
    this.payoutBankName,
    required this.countryCode,
    required this.exchangeRate,
    required this.feeAmount,
    required this.feeCurrency,
    required this.quoteId,
    this.webhookData,
    this.metadata,
    this.completedAt,
    this.failedAt,
    this.failureReason,
    required this.expiresAt,
    required this.userEmail,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final String fonbnkOrderId;
  final String type;
  final String status;
  final String cryptoCurrency;
  final String cryptoNetwork;
  final String cryptoAmount;
  final String cryptoWalletAddress;
  final String? cryptoTxHash;
  final String fiatCurrency;
  final String fiatAmount;
  final String payoutChannel;
  final String? payoutAccountNumber;
  final String? payoutAccountName;
  final String? payoutBankName;
  final String countryCode;
  final String exchangeRate;
  final String feeAmount;
  final String feeCurrency;
  final String quoteId;
  final dynamic webhookData;
  final dynamic metadata;
  final DateTime? completedAt;
  final DateTime? failedAt;
  final String? failureReason;
  final DateTime expiresAt;
  final String userEmail;

  factory TransactionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionStatusResponseToJson(this);
}
