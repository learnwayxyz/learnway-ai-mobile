// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_money_withdrawal_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileMoneyWithdrawalRequest _$MobileMoneyWithdrawalRequestFromJson(
  Map<String, dynamic> json,
) => MobileMoneyWithdrawalRequest(
  fiatAmount: (json['fiatAmount'] as num).toDouble(),
  currency: $enumDecode(_$WithdrawCurrencyEnumMap, json['currency']),
  chain: $enumDecode(_$WithdrawChainEnumMap, json['chain']),
  token: $enumDecode(_$WithdrawTokenEnumMap, json['token']),
  cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
  senderAddress: json['senderAddress'] as String?,
  referenceId: json['referenceId'] as String,
  mobileMoneyObjects: MobileMoneyObjects.fromJson(
    json['mobileMoneyObjects'] as Map<String, dynamic>,
  ),
  callbackUrl: json['callbackUrl'] as String?,
  rateId: json['rateId'] as String?,
  refundInitiated: json['refundInitiated'] as bool?,
  refundStatus: json['refundStatus'] as String?,
  refundTransactionHash: json['refundTransactionHash'] as String?,
  refundAmount: json['refundAmount'] as String?,
);

Map<String, dynamic> _$MobileMoneyWithdrawalRequestToJson(
  MobileMoneyWithdrawalRequest instance,
) => <String, dynamic>{
  'fiatAmount': instance.fiatAmount,
  'currency': _$WithdrawCurrencyEnumMap[instance.currency]!,
  'chain': _$WithdrawChainEnumMap[instance.chain]!,
  'token': _$WithdrawTokenEnumMap[instance.token]!,
  'senderAddress': instance.senderAddress,
  'referenceId': instance.referenceId,
  'callbackUrl': instance.callbackUrl,
  'rateId': instance.rateId,
  'refundInitiated': instance.refundInitiated,
  'refundStatus': instance.refundStatus,
  'refundTransactionHash': instance.refundTransactionHash,
  'refundAmount': instance.refundAmount,
  'cryptoAmount': instance.cryptoAmount,
  'mobileMoneyObjects': instance.mobileMoneyObjects,
};

const _$WithdrawCurrencyEnumMap = {
  WithdrawCurrency.kes: 'KES',
  WithdrawCurrency.ghs: 'GHS',
  WithdrawCurrency.ngn: 'NGN',
  WithdrawCurrency.zar: 'ZAR',
  WithdrawCurrency.usd: 'USD',
  WithdrawCurrency.xof: 'XOF',
  WithdrawCurrency.zmw: 'ZMW',
  WithdrawCurrency.xaf: 'XAF',
  WithdrawCurrency.sle: 'SLE',
  WithdrawCurrency.cdf: 'CDF',
  WithdrawCurrency.tzs: 'TZS',
  WithdrawCurrency.ugx: 'UGX',
  WithdrawCurrency.egp: 'EGP',
  WithdrawCurrency.mwk: 'MWK',
  WithdrawCurrency.rwf: 'RWF',
  WithdrawCurrency.etb: 'ETB',
};

const _$WithdrawChainEnumMap = {
  WithdrawChain.ethereum: 'ETHEREUM',
  WithdrawChain.celo: 'CELO',
  WithdrawChain.avalanche: 'AVALANCHE',
  WithdrawChain.polygon: 'POLYGON',
  WithdrawChain.arbitrum: 'ARBITRUM',
  WithdrawChain.optimism: 'OPTIMISM',
  WithdrawChain.stellar: 'STELLAR',
  WithdrawChain.tron: 'TRON',
  WithdrawChain.fuse: 'FUSE',
  WithdrawChain.lightning: 'LIGHTNING',
  WithdrawChain.solana: 'SOLANA',
  WithdrawChain.provenance: 'PROVENANCE',
  WithdrawChain.cardano: 'CARDANO',
  WithdrawChain.hedera: 'HEDERA',
  WithdrawChain.base: 'BASE',
  WithdrawChain.lisk: 'LISK',
  WithdrawChain.viction: 'VICTION',
  WithdrawChain.scroll: 'SCROLL',
};

const _$WithdrawTokenEnumMap = {
  WithdrawToken.cusd: 'CUSD',
  WithdrawToken.usdc: 'USDC',
  WithdrawToken.usdt: 'USDT',
  WithdrawToken.sat: 'SAT',
  WithdrawToken.btc: 'BTC',
  WithdrawToken.hash: 'HASH',
  WithdrawToken.fuse: 'FUSE',
  WithdrawToken.hbar: 'HBAR',
  WithdrawToken.usd: 'USD',
  WithdrawToken.glock: 'GLOCK',
  WithdrawToken.escghs: 'ESCGHS',
  WithdrawToken.msat: 'MSAT',
};

MobileMoneyObjects _$MobileMoneyObjectsFromJson(Map<String, dynamic> json) =>
    MobileMoneyObjects(
      phoneNumber: json['phoneNumber'] as String,
      accountName: json['accountName'] as String,
      networkProvider: json['networkProvider'] as String,
    );

Map<String, dynamic> _$MobileMoneyObjectsToJson(MobileMoneyObjects instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'accountName': instance.accountName,
      'networkProvider': instance.networkProvider,
    };
