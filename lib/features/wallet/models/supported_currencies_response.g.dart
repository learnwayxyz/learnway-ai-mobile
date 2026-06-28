// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_currencies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedCurrency _$SupportedCurrencyFromJson(Map<String, dynamic> json) =>
    SupportedCurrency(
      currencyType: json['currencyType'] as String,
      currencyCode: json['currencyCode'] as String,
      paymentChannels: (json['paymentChannels'] as List<dynamic>)
          .map((e) => PaymentChannel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currencyDetails: CurrencyDetails.fromJson(
        json['currencyDetails'] as Map<String, dynamic>,
      ),
      pairs: (json['pairs'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SupportedCurrencyToJson(
  SupportedCurrency instance,
) => <String, dynamic>{
  'currencyType': instance.currencyType,
  'currencyCode': instance.currencyCode,
  'paymentChannels': instance.paymentChannels.map((e) => e.toJson()).toList(),
  'currencyDetails': instance.currencyDetails.toJson(),
  'pairs': instance.pairs,
};

PaymentChannel _$PaymentChannelFromJson(Map<String, dynamic> json) =>
    PaymentChannel(
      type: json['type'] as String,
      transferTypes: (json['transferTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isDepositAllowed: json['isDepositAllowed'] as bool,
      isPayoutAllowed: json['isPayoutAllowed'] as bool,
      carriers: (json['carriers'] as List<dynamic>?)
          ?.map((e) => Carrier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentChannelToJson(PaymentChannel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'transferTypes': instance.transferTypes,
      'isDepositAllowed': instance.isDepositAllowed,
      'isPayoutAllowed': instance.isPayoutAllowed,
      'carriers': instance.carriers?.map((e) => e.toJson()).toList(),
    };

Carrier _$CarrierFromJson(Map<String, dynamic> json) =>
    Carrier(code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$CarrierToJson(Carrier instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
};

CurrencyDetails _$CurrencyDetailsFromJson(Map<String, dynamic> json) =>
    CurrencyDetails(
      countryIsoCode: json['countryIsoCode'] as String?,
      merchantName: json['merchantName'] as String?,
      network: json['network'] as String?,
      asset: json['asset'] as String?,
      contractAddress: json['contractAddress'] as String?,
    );

Map<String, dynamic> _$CurrencyDetailsToJson(CurrencyDetails instance) =>
    <String, dynamic>{
      'countryIsoCode': instance.countryIsoCode,
      'merchantName': instance.merchantName,
      'network': instance.network,
      'asset': instance.asset,
      'contractAddress': instance.contractAddress,
    };
