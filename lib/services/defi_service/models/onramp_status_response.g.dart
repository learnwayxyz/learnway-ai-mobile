// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampStatusResponse _$OnRampStatusResponseFromJson(
  Map<String, dynamic> json,
) => OnRampStatusResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: OnRampStatusData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnRampStatusResponseToJson(
  OnRampStatusResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

OnRampStatusData _$OnRampStatusDataFromJson(Map<String, dynamic> json) =>
    OnRampStatusData(
      referenceId: json['referenceId'] as String,
      status: json['status'] as String,
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      cryptoAmountReceived: (json['cryptoAmountReceived'] as num).toDouble(),
      feeInCrypto: (json['feeInCrypto'] as num).toDouble(),
      feeType: json['feeType'] as String,
      cryptoWallet: json['cryptoWallet'] as String,
      chain: ChainInfo.fromJson(json['chain'] as Map<String, dynamic>),
      token: TokenInfo.fromJson(json['token'] as Map<String, dynamic>),
      transactionHash: json['transactionHash'] as String,
    );

Map<String, dynamic> _$OnRampStatusDataToJson(OnRampStatusData instance) =>
    <String, dynamic>{
      'referenceId': instance.referenceId,
      'status': instance.status,
      'cryptoAmount': instance.cryptoAmount,
      'cryptoAmountReceived': instance.cryptoAmountReceived,
      'feeInCrypto': instance.feeInCrypto,
      'feeType': instance.feeType,
      'cryptoWallet': instance.cryptoWallet,
      'chain': instance.chain.toJson(),
      'token': instance.token.toJson(),
      'transactionHash': instance.transactionHash,
    };

ChainInfo _$ChainInfoFromJson(Map<String, dynamic> json) => ChainInfo(
  id: json['id'] as String?,
  name: json['name'] as String?,
  code: json['code'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$ChainInfoToJson(ChainInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'icon': instance.icon,
};

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => TokenInfo(
  id: json['id'] as String?,
  name: json['name'] as String?,
  code: json['code'] as String?,
  icon: json['icon'] as String?,
  contractAddress: json['contractAddress'] as String?,
);

Map<String, dynamic> _$TokenInfoToJson(TokenInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'icon': instance.icon,
  'contractAddress': instance.contractAddress,
};
