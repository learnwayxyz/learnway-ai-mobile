import 'package:json_annotation/json_annotation.dart';

part 'onramp_best_offer_response.g.dart';

@JsonSerializable()
class OnRampBestOfferResponse {
  OnRampBestOfferResponse({
    this.quoteId,
    this.offer,
    this.cashout,
  });
  final String? quoteId;
  final OnRampOffer? offer;
  final OnRampCashout? cashout;

  factory OnRampBestOfferResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampBestOfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampBestOfferResponseToJson(this);
}

@JsonSerializable()
class OnRampOffer {
  OnRampOffer({
    this.countryIsoCode,
    this.currencyIsoCode,
    this.exchangeRate,
    this.cryptoExchangeRate,
    this.paymentChannel,
    this.requiredFields,
  });
  final String? countryIsoCode;
  final String? currencyIsoCode;
  final double? exchangeRate;
  final double? cryptoExchangeRate;
  final String? paymentChannel;
  final Map<String, RequiredField>? requiredFields;

  factory OnRampOffer.fromJson(Map<String, dynamic> json) =>
      _$OnRampOfferFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampOfferToJson(this);
}

@JsonSerializable()
class RequiredField {
  RequiredField({
    this.type,
    this.label,
    this.required,
    this.options,
  });
  final String? type;
  final String? label;
  final bool? required;
  final List<FieldOption>? options;

  factory RequiredField.fromJson(Map<String, dynamic> json) =>
      _$RequiredFieldFromJson(json);

  Map<String, dynamic> toJson() => _$RequiredFieldToJson(this);
}

@JsonSerializable()
class FieldOption {
  final String? value;
  final String? label;

  FieldOption({this.value, this.label});

  factory FieldOption.fromJson(Map<String, dynamic> json) =>
      _$FieldOptionFromJson(json);

  Map<String, dynamic> toJson() => _$FieldOptionToJson(this);
}

@JsonSerializable()
class OnRampCashout {
  OnRampCashout({
    this.localCurrencyAmount,
    this.totalAmountUsd,
    this.withdrawAmountUsd,
    this.totalAmountCrypto,
    this.withdrawAmountCrypto,
    this.feePercent,
    this.feePercentFonbnk,
    this.feePercentPartner,
    this.feeAmountUsd,
    this.feeAmountUsdFonbnk,
    this.feeAmountUsdPartner,
    this.feeAmountLocalCurrency,
    this.feeAmountLocalCurrencyFonbnk,
    this.feeAmountLocalCurrencyPartner,
    this.feeAmountCrypto,
    this.feeAmountCryptoFonbnk,
    this.feeAmountCryptoPartner,
    this.gasAmountUsd,
    this.gasAmountLocalCurrency,
  });

  final double? localCurrencyAmount;
  final double? totalAmountUsd;
  final double? withdrawAmountUsd;
  final double? totalAmountCrypto;
  final double? withdrawAmountCrypto;
  final double? feePercent;
  final double? feePercentFonbnk;
  final double? feePercentPartner;
  final double? feeAmountUsd;
  final double? feeAmountUsdFonbnk;
  final double? feeAmountUsdPartner;
  final double? feeAmountLocalCurrency;
  final double? feeAmountLocalCurrencyFonbnk;
  final double? feeAmountLocalCurrencyPartner;
  final double? feeAmountCrypto;
  final double? feeAmountCryptoFonbnk;
  final double? feeAmountCryptoPartner;
  final double? gasAmountUsd;
  final double? gasAmountLocalCurrency;

  factory OnRampCashout.fromJson(Map<String, dynamic> json) =>
      _$OnRampCashoutFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampCashoutToJson(this);
}
