// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmOrderResponse _$ConfirmOrderResponseFromJson(
  Map<String, dynamic> json,
) => ConfirmOrderResponse(
  transactionId: json['transactionId'] as String,
  fonbnkOrderId: json['fonbnkOrderId'] as String,
  status: json['status'] as String,
  cryptoTxHash: json['cryptoTxHash'] as String?,
);

Map<String, dynamic> _$ConfirmOrderResponseToJson(
  ConfirmOrderResponse instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'status': instance.status,
  'cryptoTxHash': instance.cryptoTxHash,
};
