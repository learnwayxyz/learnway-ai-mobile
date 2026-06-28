// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteResponse _$QuoteResponseFromJson(Map<String, dynamic> json) =>
    QuoteResponse(
      quoteId: json['quoteId'] as String,
      quoteExpiresAt: json['quoteExpiresAt'] as String,
      deposit: QuoteDeposit.fromJson(json['deposit'] as Map<String, dynamic>),
      payout: QuotePayout.fromJson(json['payout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuoteResponseToJson(QuoteResponse instance) =>
    <String, dynamic>{
      'quoteId': instance.quoteId,
      'quoteExpiresAt': instance.quoteExpiresAt,
      'deposit': instance.deposit.toJson(),
      'payout': instance.payout.toJson(),
    };

QuoteDeposit _$QuoteDepositFromJson(Map<String, dynamic> json) => QuoteDeposit(
  paymentChannel: json['paymentChannel'] as String,
  currencyType: json['currencyType'] as String,
  currencyCode: json['currencyCode'] as String,
  currencyDetails: DepositCurrencyDetails.fromJson(
    json['currencyDetails'] as Map<String, dynamic>,
  ),
  cashout: Cashout.fromJson(json['cashout'] as Map<String, dynamic>),
  fieldsToCreateOrder: (json['fieldsToCreateOrder'] as List<dynamic>)
      .map((e) => FieldToCreateOrder.fromJson(e as Map<String, dynamic>))
      .toList(),
  transferType: json['transferType'] as String,
);

Map<String, dynamic> _$QuoteDepositToJson(QuoteDeposit instance) =>
    <String, dynamic>{
      'paymentChannel': instance.paymentChannel,
      'currencyType': instance.currencyType,
      'currencyCode': instance.currencyCode,
      'currencyDetails': instance.currencyDetails.toJson(),
      'cashout': instance.cashout.toJson(),
      'fieldsToCreateOrder': instance.fieldsToCreateOrder
          .map((e) => e.toJson())
          .toList(),
      'transferType': instance.transferType,
    };

QuotePayout _$QuotePayoutFromJson(Map<String, dynamic> json) => QuotePayout(
  paymentChannel: json['paymentChannel'] as String,
  currencyType: json['currencyType'] as String,
  currencyCode: json['currencyCode'] as String,
  currencyDetails: PayoutCurrencyDetails.fromJson(
    json['currencyDetails'] as Map<String, dynamic>,
  ),
  cashout: Cashout.fromJson(json['cashout'] as Map<String, dynamic>),
  fieldsToCreateOrder: (json['fieldsToCreateOrder'] as List<dynamic>)
      .map((e) => FieldToCreateOrder.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuotePayoutToJson(QuotePayout instance) =>
    <String, dynamic>{
      'paymentChannel': instance.paymentChannel,
      'currencyType': instance.currencyType,
      'currencyCode': instance.currencyCode,
      'currencyDetails': instance.currencyDetails.toJson(),
      'cashout': instance.cashout.toJson(),
      'fieldsToCreateOrder': instance.fieldsToCreateOrder
          .map((e) => e.toJson())
          .toList(),
    };

DepositCurrencyDetails _$DepositCurrencyDetailsFromJson(
  Map<String, dynamic> json,
) => DepositCurrencyDetails(
  network: json['network'] as String?,
  asset: json['asset'] as String?,
  contractAddress: json['contractAddress'] as String?,
);

Map<String, dynamic> _$DepositCurrencyDetailsToJson(
  DepositCurrencyDetails instance,
) => <String, dynamic>{
  'network': instance.network,
  'asset': instance.asset,
  'contractAddress': instance.contractAddress,
};

PayoutCurrencyDetails _$PayoutCurrencyDetailsFromJson(
  Map<String, dynamic> json,
) => PayoutCurrencyDetails(countryIsoCode: json['countryIsoCode'] as String?);

Map<String, dynamic> _$PayoutCurrencyDetailsToJson(
  PayoutCurrencyDetails instance,
) => <String, dynamic>{'countryIsoCode': instance.countryIsoCode};

Cashout _$CashoutFromJson(Map<String, dynamic> json) => Cashout(
  amountBeforeFees: (json['amountBeforeFees'] as num).toDouble(),
  amountAfterFees: (json['amountAfterFees'] as num).toDouble(),
  chargedFees: (json['chargedFees'] as List<dynamic>)
      .map((e) => ChargedFee.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalChargedFees: (json['totalChargedFees'] as num).toDouble(),
  chargedFeesPerRecipient:
      (json['chargedFeesPerRecipient'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
  amountBeforeFeesUsd: (json['amountBeforeFeesUsd'] as num).toDouble(),
  amountAfterFeesUsd: (json['amountAfterFeesUsd'] as num).toDouble(),
  chargedFeesUsd: (json['chargedFeesUsd'] as List<dynamic>)
      .map((e) => ChargedFee.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalChargedFeesUsd: (json['totalChargedFeesUsd'] as num).toDouble(),
  exchangeRate: (json['exchangeRate'] as num).toDouble(),
  exchangeRateAfterFees: (json['exchangeRateAfterFees'] as num).toDouble(),
  chargedFeesPerRecipientUsd:
      (json['chargedFeesPerRecipientUsd'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
  feeSettings: (json['feeSettings'] as List<dynamic>)
      .map((e) => FeeSetting.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashoutToJson(Cashout instance) => <String, dynamic>{
  'amountBeforeFees': instance.amountBeforeFees,
  'amountAfterFees': instance.amountAfterFees,
  'chargedFees': instance.chargedFees.map((e) => e.toJson()).toList(),
  'totalChargedFees': instance.totalChargedFees,
  'chargedFeesPerRecipient': instance.chargedFeesPerRecipient,
  'amountBeforeFeesUsd': instance.amountBeforeFeesUsd,
  'amountAfterFeesUsd': instance.amountAfterFeesUsd,
  'chargedFeesUsd': instance.chargedFeesUsd.map((e) => e.toJson()).toList(),
  'totalChargedFeesUsd': instance.totalChargedFeesUsd,
  'exchangeRate': instance.exchangeRate,
  'exchangeRateAfterFees': instance.exchangeRateAfterFees,
  'chargedFeesPerRecipientUsd': instance.chargedFeesPerRecipientUsd,
  'feeSettings': instance.feeSettings.map((e) => e.toJson()).toList(),
};

ChargedFee _$ChargedFeeFromJson(Map<String, dynamic> json) => ChargedFee(
  id: json['id'] as String,
  type: json['type'] as String,
  recipient: json['recipient'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$ChargedFeeToJson(ChargedFee instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'recipient': instance.recipient,
      'amount': instance.amount,
    };

FeeSetting _$FeeSettingFromJson(Map<String, dynamic> json) => FeeSetting(
  id: json['id'] as String,
  type: json['type'] as String,
  value: (json['value'] as num).toDouble(),
  min: (json['min'] as num).toDouble(),
  max: json['max'],
  recipient: json['recipient'] as String,
);

Map<String, dynamic> _$FeeSettingToJson(FeeSetting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'value': instance.value,
      'min': instance.min,
      'max': instance.max,
      'recipient': instance.recipient,
    };

FieldToCreateOrder _$FieldToCreateOrderFromJson(Map<String, dynamic> json) =>
    FieldToCreateOrder(
      key: json['key'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      required: json['required'] as bool,
      defaultValue: json['defaultValue'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FieldOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FieldToCreateOrderToJson(FieldToCreateOrder instance) =>
    <String, dynamic>{
      'key': instance.key,
      'type': instance.type,
      'label': instance.label,
      'required': instance.required,
      'defaultValue': instance.defaultValue,
      'options': instance.options?.map((e) => e.toJson()).toList(),
    };

FieldOption _$FieldOptionFromJson(Map<String, dynamic> json) => FieldOption(
  value: json['value'] as String?,
  label: json['label'] as String,
);

Map<String, dynamic> _$FieldOptionToJson(FieldOption instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};
