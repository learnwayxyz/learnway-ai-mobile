import 'package:json_annotation/json_annotation.dart';

part 'mobile_money_withdrawal_request.g.dart';

/// Mobile Money Deposit Request Model
@JsonSerializable()
class MobileMoneyWithdrawalRequest {
  MobileMoneyWithdrawalRequest({
    required this.fiatAmount,
    required this.currency,
    required this.chain,
    required this.token,
    required this.cryptoAmount,
    this.senderAddress,
    required this.referenceId,
    required this.mobileMoneyObjects,
    this.callbackUrl,
    this.rateId,
    this.refundInitiated,
    this.refundStatus,
    this.refundTransactionHash,
    this.refundAmount,
  });

  final double fiatAmount;
  final WithdrawCurrency currency;
  final WithdrawChain chain;
  final WithdrawToken token;
  final String? senderAddress;
  final String referenceId;
  final String? callbackUrl;
  final String? rateId;
  final bool? refundInitiated;
  final String? refundStatus;
  final String? refundTransactionHash;
  final String? refundAmount;
  final double cryptoAmount;
  final MobileMoneyObjects mobileMoneyObjects;

  factory MobileMoneyWithdrawalRequest.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyWithdrawalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyWithdrawalRequestToJson(this);
}

@JsonSerializable()
class MobileMoneyObjects {
  MobileMoneyObjects({
    required this.phoneNumber,
    required this.accountName,
    required this.networkProvider,
  });
  final String phoneNumber;
  final String accountName;
  final String networkProvider;
  factory MobileMoneyObjects.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyObjectsFromJson(json);
  Map<String, dynamic> toJson() => _$MobileMoneyObjectsToJson(this);
}

/// Currency Enum
@JsonEnum(alwaysCreate: true)
enum WithdrawCurrency {
  @JsonValue('KES')
  kes,
  @JsonValue('GHS')
  ghs,
  @JsonValue('NGN')
  ngn,
  @JsonValue('ZAR')
  zar,
  @JsonValue('USD')
  usd,
  @JsonValue('XOF')
  xof,
  @JsonValue('ZMW')
  zmw,
  @JsonValue('XAF')
  xaf,
  @JsonValue('SLE')
  sle,
  @JsonValue('CDF')
  cdf,
  @JsonValue('TZS')
  tzs,
  @JsonValue('UGX')
  ugx,
  @JsonValue('EGP')
  egp,
  @JsonValue('MWK')
  mwk,
  @JsonValue('RWF')
  rwf,
  @JsonValue('ETB')
  etb,
}

/// Chain Enum
@JsonEnum(alwaysCreate: true)
enum WithdrawChain {
  @JsonValue('ETHEREUM')
  ethereum,
  @JsonValue('CELO')
  celo,
  @JsonValue('AVALANCHE')
  avalanche,
  @JsonValue('POLYGON')
  polygon,
  @JsonValue('ARBITRUM')
  arbitrum,
  @JsonValue('OPTIMISM')
  optimism,
  @JsonValue('STELLAR')
  stellar,
  @JsonValue('TRON')
  tron,
  @JsonValue('FUSE')
  fuse,
  @JsonValue('LIGHTNING')
  lightning,
  @JsonValue('SOLANA')
  solana,
  @JsonValue('PROVENANCE')
  provenance,
  @JsonValue('CARDANO')
  cardano,
  @JsonValue('HEDERA')
  hedera,
  @JsonValue('BASE')
  base,
  @JsonValue('LISK')
  lisk,
  @JsonValue('VICTION')
  viction,
  @JsonValue('SCROLL')
  scroll,
}

/// Token Enum
@JsonEnum(alwaysCreate: true)
enum WithdrawToken {
  @JsonValue('CUSD')
  cusd,
  @JsonValue('USDC')
  usdc,
  @JsonValue('USDT')
  usdt,
  @JsonValue('SAT')
  sat,
  @JsonValue('BTC')
  btc,
  @JsonValue('HASH')
  hash,
  @JsonValue('FUSE')
  fuse,
  @JsonValue('HBAR')
  hbar,
  @JsonValue('USD')
  usd,
  @JsonValue('GLOCK')
  glock,
  @JsonValue('ESCGHS')
  escghs,
  @JsonValue('MSAT')
  msat,
}
