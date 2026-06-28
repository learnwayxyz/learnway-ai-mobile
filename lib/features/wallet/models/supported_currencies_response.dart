import 'package:json_annotation/json_annotation.dart';

part 'supported_currencies_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SupportedCurrency {
  final String currencyType;
  final String currencyCode;
  final List<PaymentChannel> paymentChannels;
  final CurrencyDetails currencyDetails;
  final List<String> pairs;

  SupportedCurrency({
    required this.currencyType,
    required this.currencyCode,
    required this.paymentChannels,
    required this.currencyDetails,
    required this.pairs,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) =>
      _$SupportedCurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$SupportedCurrencyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PaymentChannel {
  final String type;
  final List<String> transferTypes;
  final bool isDepositAllowed;
  final bool isPayoutAllowed;
  final List<Carrier>? carriers;

  PaymentChannel({
    required this.type,
    required this.transferTypes,
    required this.isDepositAllowed,
    required this.isPayoutAllowed,
    this.carriers,
  });

  factory PaymentChannel.fromJson(Map<String, dynamic> json) =>
      _$PaymentChannelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentChannelToJson(this);
}

@JsonSerializable()
class Carrier {
  final String code;
  final String name;

  Carrier({
    required this.code,
    required this.name,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) =>
      _$CarrierFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierToJson(this);
}

@JsonSerializable()
class CurrencyDetails {
  final String? countryIsoCode;
  final String? merchantName;
  final String? network;
  final String? asset;
  final String? contractAddress;

  CurrencyDetails({
    this.countryIsoCode,
    this.merchantName,
    this.network,
    this.asset,
    this.contractAddress,
  });

  factory CurrencyDetails.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyDetailsToJson(this);
}
