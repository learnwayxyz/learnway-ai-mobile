// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_quote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampQuoteResponse _$OnRampQuoteResponseFromJson(Map<String, dynamic> json) =>
    OnRampQuoteResponse(
      quoteId: json['quoteId'] as String,
      quoteExpiresAt: json['quoteExpiresAt'] as String,
      deposit: OnRampQuoteChannel.fromJson(
        json['deposit'] as Map<String, dynamic>,
      ),
      payout: OnRampQoteCurrencyDetails.fromJson(
        json['payout'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OnRampQuoteResponseToJson(
  OnRampQuoteResponse instance,
) => <String, dynamic>{
  'quoteId': instance.quoteId,
  'quoteExpiresAt': instance.quoteExpiresAt,
  'deposit': instance.deposit,
  'payout': instance.payout,
};

OnRampQuoteChannel _$OnRampQuoteChannelFromJson(
  Map<String, dynamic> json,
) => OnRampQuoteChannel(
  paymentChannel: json['paymentChannel'] as String,
  currencyType: json['currencyType'] as String,
  currencyCode: json['currencyCode'] as String,
  currencyDetails: OnRampQoteCurrencyDetails.fromJson(
    json['currencyDetails'] as Map<String, dynamic>,
  ),
  cashout: OnRampQuoteCashout.fromJson(json['cashout'] as Map<String, dynamic>),
  fieldsToCreateOrder: (json['fieldsToCreateOrder'] as List<dynamic>)
      .map(
        (e) =>
            OnRampQuoteFieldToCreateOrder.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$OnRampQuoteChannelToJson(OnRampQuoteChannel instance) =>
    <String, dynamic>{
      'paymentChannel': instance.paymentChannel,
      'currencyType': instance.currencyType,
      'currencyCode': instance.currencyCode,
      'currencyDetails': instance.currencyDetails,
      'cashout': instance.cashout,
      'fieldsToCreateOrder': instance.fieldsToCreateOrder,
    };

OnRampQoteCurrencyDetails _$OnRampQoteCurrencyDetailsFromJson(
  Map<String, dynamic> json,
) => OnRampQoteCurrencyDetails(
  countryIsoCode: json['countryIsoCode'] as String?,
  network: json['network'] as String?,
  asset: json['asset'] as String?,
);

Map<String, dynamic> _$OnRampQoteCurrencyDetailsToJson(
  OnRampQoteCurrencyDetails instance,
) => <String, dynamic>{
  'countryIsoCode': instance.countryIsoCode,
  'network': instance.network,
  'asset': instance.asset,
};

OnRampQuoteCashout _$OnRampQuoteCashoutFromJson(Map<String, dynamic> json) =>
    OnRampQuoteCashout(
      amountBeforeFees: (json['amountBeforeFees'] as num).toDouble(),
      amountAfterFees: (json['amountAfterFees'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      totalChargedFees: (json['totalChargedFees'] as num).toDouble(),
      chargedFees: (json['chargedFees'] as List<dynamic>?)
          ?.map(
            (e) => OnRampQuoteChargedFee.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$OnRampQuoteCashoutToJson(OnRampQuoteCashout instance) =>
    <String, dynamic>{
      'amountBeforeFees': instance.amountBeforeFees,
      'amountAfterFees': instance.amountAfterFees,
      'exchangeRate': instance.exchangeRate,
      'totalChargedFees': instance.totalChargedFees,
      'chargedFees': instance.chargedFees,
    };

OnRampQuoteChargedFee _$OnRampQuoteChargedFeeFromJson(
  Map<String, dynamic> json,
) => OnRampQuoteChargedFee(
  id: json['id'] as String,
  type: json['type'] as String,
  recipient: json['recipient'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$OnRampQuoteChargedFeeToJson(
  OnRampQuoteChargedFee instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'recipient': instance.recipient,
  'amount': instance.amount,
};

OnRampQuoteFieldToCreateOrder _$OnRampQuoteFieldToCreateOrderFromJson(
  Map<String, dynamic> json,
) => OnRampQuoteFieldToCreateOrder(
  key: json['key'] as String,
  label: json['label'] as String,
  required: json['required'] as bool,
  type: json['type'] as String,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => FieldOption.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OnRampQuoteFieldToCreateOrderToJson(
  OnRampQuoteFieldToCreateOrder instance,
) => <String, dynamic>{
  'key': instance.key,
  'label': instance.label,
  'required': instance.required,
  'type': instance.type,
  'options': instance.options?.map((e) => e.toJson()).toList(),
};
