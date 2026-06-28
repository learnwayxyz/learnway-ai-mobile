// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_confirm_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampConfirmResponse _$OnRampConfirmResponseFromJson(
  Map<String, dynamic> json,
) => OnRampConfirmResponse(
  transactionId: json['transactionId'] as String,
  fonbnkOrderId: json['fonbnkOrderId'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$OnRampConfirmResponseToJson(
  OnRampConfirmResponse instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'status': instance.status,
};
