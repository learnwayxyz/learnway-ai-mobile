// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatusResponse _$TransactionStatusResponseFromJson(
  Map<String, dynamic> json,
) => TransactionStatusResponse(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  userId: json['userId'] as String,
  fonbnkOrderId: json['fonbnkOrderId'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  cryptoCurrency: json['cryptoCurrency'] as String,
  cryptoNetwork: json['cryptoNetwork'] as String,
  cryptoAmount: json['cryptoAmount'] as String,
  cryptoWalletAddress: json['cryptoWalletAddress'] as String,
  cryptoTxHash: json['cryptoTxHash'] as String?,
  fiatCurrency: json['fiatCurrency'] as String,
  fiatAmount: json['fiatAmount'] as String,
  payoutChannel: json['payoutChannel'] as String,
  payoutAccountNumber: json['payoutAccountNumber'] as String?,
  payoutAccountName: json['payoutAccountName'] as String?,
  payoutBankName: json['payoutBankName'] as String?,
  countryCode: json['countryCode'] as String,
  exchangeRate: json['exchangeRate'] as String,
  feeAmount: json['feeAmount'] as String,
  feeCurrency: json['feeCurrency'] as String,
  quoteId: json['quoteId'] as String,
  webhookData: json['webhookData'],
  metadata: json['metadata'],
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  failedAt: json['failedAt'] == null
      ? null
      : DateTime.parse(json['failedAt'] as String),
  failureReason: json['failureReason'] as String?,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  userEmail: json['userEmail'] as String,
);

Map<String, dynamic> _$TransactionStatusResponseToJson(
  TransactionStatusResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'userId': instance.userId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'type': instance.type,
  'status': instance.status,
  'cryptoCurrency': instance.cryptoCurrency,
  'cryptoNetwork': instance.cryptoNetwork,
  'cryptoAmount': instance.cryptoAmount,
  'cryptoWalletAddress': instance.cryptoWalletAddress,
  'cryptoTxHash': instance.cryptoTxHash,
  'fiatCurrency': instance.fiatCurrency,
  'fiatAmount': instance.fiatAmount,
  'payoutChannel': instance.payoutChannel,
  'payoutAccountNumber': instance.payoutAccountNumber,
  'payoutAccountName': instance.payoutAccountName,
  'payoutBankName': instance.payoutBankName,
  'countryCode': instance.countryCode,
  'exchangeRate': instance.exchangeRate,
  'feeAmount': instance.feeAmount,
  'feeCurrency': instance.feeCurrency,
  'quoteId': instance.quoteId,
  'webhookData': instance.webhookData,
  'metadata': instance.metadata,
  'completedAt': instance.completedAt?.toIso8601String(),
  'failedAt': instance.failedAt?.toIso8601String(),
  'failureReason': instance.failureReason,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'userEmail': instance.userEmail,
};
