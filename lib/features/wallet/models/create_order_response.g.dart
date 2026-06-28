// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      transactionId: json['transactionId'] as String,
      fonbnkOrderId: json['fonbnkOrderId'] as String,
      cryptoWalletAddress: json['cryptoWalletAddress'] as String,
      cryptoAmount: CreateOrderResponse._stringFromJson(json['cryptoAmount']),
      fiatAmount: CreateOrderResponse._stringFromJson(json['fiatAmount']),
      status: json['status'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
  CreateOrderResponse instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'cryptoWalletAddress': instance.cryptoWalletAddress,
  'cryptoAmount': instance.cryptoAmount,
  'fiatAmount': instance.fiatAmount,
  'status': instance.status,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
