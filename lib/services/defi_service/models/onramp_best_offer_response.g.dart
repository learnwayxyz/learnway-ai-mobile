// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_best_offer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampBestOfferResponse _$OnRampBestOfferResponseFromJson(
  Map<String, dynamic> json,
) => OnRampBestOfferResponse(
  quoteId: json['quoteId'] as String?,
  offer: json['offer'] == null
      ? null
      : OnRampOffer.fromJson(json['offer'] as Map<String, dynamic>),
  cashout: json['cashout'] == null
      ? null
      : OnRampCashout.fromJson(json['cashout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnRampBestOfferResponseToJson(
  OnRampBestOfferResponse instance,
) => <String, dynamic>{
  'quoteId': instance.quoteId,
  'offer': instance.offer,
  'cashout': instance.cashout,
};

OnRampOffer _$OnRampOfferFromJson(Map<String, dynamic> json) => OnRampOffer(
  countryIsoCode: json['countryIsoCode'] as String?,
  currencyIsoCode: json['currencyIsoCode'] as String?,
  exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
  cryptoExchangeRate: (json['cryptoExchangeRate'] as num?)?.toDouble(),
  paymentChannel: json['paymentChannel'] as String?,
  requiredFields: (json['requiredFields'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, RequiredField.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$OnRampOfferToJson(OnRampOffer instance) =>
    <String, dynamic>{
      'countryIsoCode': instance.countryIsoCode,
      'currencyIsoCode': instance.currencyIsoCode,
      'exchangeRate': instance.exchangeRate,
      'cryptoExchangeRate': instance.cryptoExchangeRate,
      'paymentChannel': instance.paymentChannel,
      'requiredFields': instance.requiredFields,
    };

RequiredField _$RequiredFieldFromJson(Map<String, dynamic> json) =>
    RequiredField(
      type: json['type'] as String?,
      label: json['label'] as String?,
      required: json['required'] as bool?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FieldOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RequiredFieldToJson(RequiredField instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'required': instance.required,
      'options': instance.options,
    };

FieldOption _$FieldOptionFromJson(Map<String, dynamic> json) => FieldOption(
  value: json['value'] as String?,
  label: json['label'] as String?,
);

Map<String, dynamic> _$FieldOptionToJson(FieldOption instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};

OnRampCashout _$OnRampCashoutFromJson(
  Map<String, dynamic> json,
) => OnRampCashout(
  localCurrencyAmount: (json['localCurrencyAmount'] as num?)?.toDouble(),
  totalAmountUsd: (json['totalAmountUsd'] as num?)?.toDouble(),
  withdrawAmountUsd: (json['withdrawAmountUsd'] as num?)?.toDouble(),
  totalAmountCrypto: (json['totalAmountCrypto'] as num?)?.toDouble(),
  withdrawAmountCrypto: (json['withdrawAmountCrypto'] as num?)?.toDouble(),
  feePercent: (json['feePercent'] as num?)?.toDouble(),
  feePercentFonbnk: (json['feePercentFonbnk'] as num?)?.toDouble(),
  feePercentPartner: (json['feePercentPartner'] as num?)?.toDouble(),
  feeAmountUsd: (json['feeAmountUsd'] as num?)?.toDouble(),
  feeAmountUsdFonbnk: (json['feeAmountUsdFonbnk'] as num?)?.toDouble(),
  feeAmountUsdPartner: (json['feeAmountUsdPartner'] as num?)?.toDouble(),
  feeAmountLocalCurrency: (json['feeAmountLocalCurrency'] as num?)?.toDouble(),
  feeAmountLocalCurrencyFonbnk: (json['feeAmountLocalCurrencyFonbnk'] as num?)
      ?.toDouble(),
  feeAmountLocalCurrencyPartner: (json['feeAmountLocalCurrencyPartner'] as num?)
      ?.toDouble(),
  feeAmountCrypto: (json['feeAmountCrypto'] as num?)?.toDouble(),
  feeAmountCryptoFonbnk: (json['feeAmountCryptoFonbnk'] as num?)?.toDouble(),
  feeAmountCryptoPartner: (json['feeAmountCryptoPartner'] as num?)?.toDouble(),
  gasAmountUsd: (json['gasAmountUsd'] as num?)?.toDouble(),
  gasAmountLocalCurrency: (json['gasAmountLocalCurrency'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OnRampCashoutToJson(OnRampCashout instance) =>
    <String, dynamic>{
      'localCurrencyAmount': instance.localCurrencyAmount,
      'totalAmountUsd': instance.totalAmountUsd,
      'withdrawAmountUsd': instance.withdrawAmountUsd,
      'totalAmountCrypto': instance.totalAmountCrypto,
      'withdrawAmountCrypto': instance.withdrawAmountCrypto,
      'feePercent': instance.feePercent,
      'feePercentFonbnk': instance.feePercentFonbnk,
      'feePercentPartner': instance.feePercentPartner,
      'feeAmountUsd': instance.feeAmountUsd,
      'feeAmountUsdFonbnk': instance.feeAmountUsdFonbnk,
      'feeAmountUsdPartner': instance.feeAmountUsdPartner,
      'feeAmountLocalCurrency': instance.feeAmountLocalCurrency,
      'feeAmountLocalCurrencyFonbnk': instance.feeAmountLocalCurrencyFonbnk,
      'feeAmountLocalCurrencyPartner': instance.feeAmountLocalCurrencyPartner,
      'feeAmountCrypto': instance.feeAmountCrypto,
      'feeAmountCryptoFonbnk': instance.feeAmountCryptoFonbnk,
      'feeAmountCryptoPartner': instance.feeAmountCryptoPartner,
      'gasAmountUsd': instance.gasAmountUsd,
      'gasAmountLocalCurrency': instance.gasAmountLocalCurrency,
    };
