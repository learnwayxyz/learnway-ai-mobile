// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_money_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileMoneyDepositRequest _$MobileMoneyDepositRequestFromJson(
  Map<String, dynamic> json,
) => MobileMoneyDepositRequest(
  fiatAmount: (json['fiatAmount'] as num).toDouble(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  chain: $enumDecode(_$ChainEnumMap, json['chain']),
  token: $enumDecode(_$TokenEnumMap, json['token']),
  receiverAddress: json['receiverAddress'] as String,
  referenceId: json['referenceId'] as String,
  mobileMoneyObjects: json['mobileMoneyObjects'] == null
      ? null
      : MobileMoneyDepositObjects.fromJson(
          json['mobileMoneyObjects'] as Map<String, dynamic>,
        ),
  callbackUrl: json['callbackUrl'] as String?,
  rateId: json['rateId'] as String?,
);

Map<String, dynamic> _$MobileMoneyDepositRequestToJson(
  MobileMoneyDepositRequest instance,
) => <String, dynamic>{
  'fiatAmount': instance.fiatAmount,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'chain': _$ChainEnumMap[instance.chain]!,
  'token': _$TokenEnumMap[instance.token]!,
  'receiverAddress': instance.receiverAddress,
  'referenceId': instance.referenceId,
  'callbackUrl': instance.callbackUrl,
  'rateId': instance.rateId,
  'mobileMoneyObjects': instance.mobileMoneyObjects?.toJson(),
};

const _$CurrencyEnumMap = {
  Currency.kes: 'KES',
  Currency.ghs: 'GHS',
  Currency.ngn: 'NGN',
  Currency.zar: 'ZAR',
  Currency.usd: 'USD',
  Currency.xof: 'XOF',
  Currency.zmw: 'ZMW',
  Currency.xaf: 'XAF',
  Currency.sle: 'SLE',
  Currency.cdf: 'CDF',
  Currency.tzs: 'TZS',
  Currency.ugx: 'UGX',
  Currency.egp: 'EGP',
  Currency.mwk: 'MWK',
  Currency.rwf: 'RWF',
  Currency.etb: 'ETB',
};

const _$ChainEnumMap = {
  Chain.ethereum: 'ETHEREUM',
  Chain.celo: 'CELO',
  Chain.avalanche: 'AVALANCHE',
  Chain.polygon: 'POLYGON',
  Chain.arbitrum: 'ARBITRUM',
  Chain.optimism: 'OPTIMISM',
  Chain.stellar: 'STELLAR',
  Chain.tron: 'TRON',
  Chain.fuse: 'FUSE',
  Chain.lightning: 'LIGHTNING',
  Chain.solana: 'SOLANA',
  Chain.provenance: 'PROVENANCE',
  Chain.cardano: 'CARDANO',
  Chain.hedera: 'HEDERA',
  Chain.base: 'BASE',
  Chain.lisk: 'LISK',
  Chain.viction: 'VICTION',
  Chain.scroll: 'SCROLL',
};

const _$TokenEnumMap = {
  Token.cusd: 'CUSD',
  Token.usdc: 'USDC',
  Token.usdt: 'USDT',
  Token.sat: 'SAT',
  Token.btc: 'BTC',
  Token.hash: 'HASH',
  Token.fuse: 'FUSE',
  Token.hbar: 'HBAR',
  Token.usd: 'USD',
  Token.glock: 'GLOCK',
  Token.escghs: 'ESCGHS',
  Token.msat: 'MSAT',
};

MobileMoneyDepositObjects _$MobileMoneyDepositObjectsFromJson(
  Map<String, dynamic> json,
) => MobileMoneyDepositObjects(
  phoneNumber: json['phoneNumber'] as String,
  accountName: json['accountName'] as String,
  networkProvider: json['networkProvider'] as String,
);

Map<String, dynamic> _$MobileMoneyDepositObjectsToJson(
  MobileMoneyDepositObjects instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'accountName': instance.accountName,
  'networkProvider': instance.networkProvider,
};
