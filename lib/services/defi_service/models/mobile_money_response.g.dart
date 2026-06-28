// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_money_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileMoneyDepositResponse _$MobileMoneyDepositResponseFromJson(
  Map<String, dynamic> json,
) => MobileMoneyDepositResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : MobileMoneyDepositData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MobileMoneyDepositResponseToJson(
  MobileMoneyDepositResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

MobileMoneyDepositData _$MobileMoneyDepositDataFromJson(
  Map<String, dynamic> json,
) => MobileMoneyDepositData(
  id: json['id'] as String?,
  transactionId: json['transactionId'] as String?,
  referenceId: json['referenceId'] as String?,
  status: json['status'] as String?,
  statusDescription: json['statusDescription'] as String?,
  fiatAmount: (json['fiatAmount'] as num?)?.toDouble(),
  cryptoAmount: (json['cryptoAmount'] as num?)?.toDouble(),
  receiverAddress: json['receiverAddress'] as String?,
  redirectUrl: json['redirectUrl'] as String?,
);

Map<String, dynamic> _$MobileMoneyDepositDataToJson(
  MobileMoneyDepositData instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionId': instance.transactionId,
  'referenceId': instance.referenceId,
  'status': instance.status,
  'statusDescription': instance.statusDescription,
  'fiatAmount': instance.fiatAmount,
  'cryptoAmount': instance.cryptoAmount,
  'receiverAddress': instance.receiverAddress,
  'redirectUrl': instance.redirectUrl,
};
