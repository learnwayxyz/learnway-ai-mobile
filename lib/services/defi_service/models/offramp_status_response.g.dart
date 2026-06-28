// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offramp_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfframpStatusResponse _$OfframpStatusResponseFromJson(
  Map<String, dynamic> json,
) => OfframpStatusResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : OfframpStatusData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OfframpStatusResponseToJson(
  OfframpStatusResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

OfframpStatusData _$OfframpStatusDataFromJson(Map<String, dynamic> json) =>
    OfframpStatusData(
      referenceId: json['referenceId'] as String,
      fiatAmount: (json['fiatAmount'] as num).toDouble(),
      fiatTransactionAmount: (json['fiatTransactionAmount'] as num).toDouble(),
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      fiatCurrency: json['fiatCurrency'] as String,
      customerKey: json['customerKey'] as String,
      senderAddress: json['senderAddress'] as String,
      transactionHash: json['transactionHash'] as String?,
      status: json['status'] as String,
      onchainStatus: json['onchainStatus'] as String,
      rate: Rate.fromJson(json['rate'] as Map<String, dynamic>),
      escrowAddress: json['escrowAddress'] as String,
      usingIntegratedWallet: json['usingIntegratedWallet'] as bool,
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$OfframpStatusDataToJson(OfframpStatusData instance) =>
    <String, dynamic>{
      'referenceId': instance.referenceId,
      'fiatAmount': instance.fiatAmount,
      'fiatTransactionAmount': instance.fiatTransactionAmount,
      'cryptoAmount': instance.cryptoAmount,
      'fiatCurrency': instance.fiatCurrency,
      'customerKey': instance.customerKey,
      'senderAddress': instance.senderAddress,
      'transactionHash': instance.transactionHash,
      'status': instance.status,
      'onchainStatus': instance.onchainStatus,
      'rate': instance.rate.toJson(),
      'escrowAddress': instance.escrowAddress,
      'usingIntegratedWallet': instance.usingIntegratedWallet,
      'created_at': instance.created_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
    };

Rate _$RateFromJson(Map<String, dynamic> json) => Rate(
  id: json['id'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  value: json['value'] as String,
  fiatAmount: (json['fiatAmount'] as num).toDouble(),
  transactionAmount: (json['transactionAmount'] as num).toDouble(),
  cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
  fee: (json['fee'] as num).toDouble(),
);

Map<String, dynamic> _$RateToJson(Rate instance) => <String, dynamic>{
  'id': instance.id,
  'from': instance.from,
  'to': instance.to,
  'value': instance.value,
  'fiatAmount': instance.fiatAmount,
  'transactionAmount': instance.transactionAmount,
  'cryptoAmount': instance.cryptoAmount,
  'fee': instance.fee,
};
