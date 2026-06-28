// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_money_withdrawal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileMoneyWithdrawalResponse _$MobileMoneyWithdrawalResponseFromJson(
  Map<String, dynamic> json,
) => MobileMoneyWithdrawalResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : MobileMoneyWithdrawalData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MobileMoneyWithdrawalResponseToJson(
  MobileMoneyWithdrawalResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

MobileMoneyWithdrawalData _$MobileMoneyWithdrawalDataFromJson(
  Map<String, dynamic> json,
) => MobileMoneyWithdrawalData(
  referenceId: json['referenceId'] as String?,
  fiatAmount: (json['fiatAmount'] as num?)?.toDouble(),
  fiatTransactionAmount: (json['fiatTransactionAmount'] as num?)?.toDouble(),
  cryptoAmount: (json['cryptoAmount'] as num?)?.toDouble(),
  fiatCurrency: json['fiatCurrency'] as String?,
  customerKey: json['customerKey'] as String?,
  senderAddress: json['senderAddress'] as String?,
  status: json['status'] as String?,
  onchainStatus: json['onchainStatus'] as String?,
  rate: json['rate'] == null
      ? null
      : RateInfo.fromJson(json['rate'] as Map<String, dynamic>),
  escrowAddress: json['escrowAddress'] as String?,
  usingIntegratedWallet: json['usingIntegratedWallet'] as bool?,
  redirectUrl: json['redirectUrl'] as String?,
  created_at: json['created_at'] as String?,
  updated_at: json['updated_at'] as String?,
);

Map<String, dynamic> _$MobileMoneyWithdrawalDataToJson(
  MobileMoneyWithdrawalData instance,
) => <String, dynamic>{
  'referenceId': instance.referenceId,
  'fiatAmount': instance.fiatAmount,
  'fiatTransactionAmount': instance.fiatTransactionAmount,
  'cryptoAmount': instance.cryptoAmount,
  'fiatCurrency': instance.fiatCurrency,
  'customerKey': instance.customerKey,
  'senderAddress': instance.senderAddress,
  'status': instance.status,
  'onchainStatus': instance.onchainStatus,
  'rate': instance.rate?.toJson(),
  'escrowAddress': instance.escrowAddress,
  'usingIntegratedWallet': instance.usingIntegratedWallet,
  'redirectUrl': instance.redirectUrl,
  'created_at': instance.created_at,
  'updated_at': instance.updated_at,
};

RateInfo _$RateInfoFromJson(Map<String, dynamic> json) => RateInfo(
  id: json['id'] as String?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  value: json['value'] as String?,
  fiatAmount: (json['fiatAmount'] as num?)?.toDouble(),
  transactionAmount: (json['transactionAmount'] as num?)?.toDouble(),
  cryptoAmount: (json['cryptoAmount'] as num?)?.toDouble(),
  fee: (json['fee'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RateInfoToJson(RateInfo instance) => <String, dynamic>{
  'id': instance.id,
  'from': instance.from,
  'to': instance.to,
  'value': instance.value,
  'fiatAmount': instance.fiatAmount,
  'transactionAmount': instance.transactionAmount,
  'cryptoAmount': instance.cryptoAmount,
  'fee': instance.fee,
};

const _$FiatCurrencyEnumMap = {
  FiatCurrency.kes: 'KES',
  FiatCurrency.ghs: 'GHS',
  FiatCurrency.tzs: 'TZS',
  FiatCurrency.ugx: 'UGX',
  FiatCurrency.zmw: 'ZMW',
  FiatCurrency.xaf: 'XAF',
  FiatCurrency.xof: 'XOF',
  FiatCurrency.cdf: 'CDF',
  FiatCurrency.rwf: 'RWF',
  FiatCurrency.etb: 'ETB',
  FiatCurrency.zar: 'ZAR',
};
