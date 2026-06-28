import 'dart:typed_data';

import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_request.dart'
    as mm;
import 'package:learnwayv2/services/defi_service/models/mobile_money_withdrawal_request.dart';
import 'package:variance_dart/variance_dart.dart';
import 'package:wallet/wallet.dart' show EthereumAddress;

WithdrawCurrency mapWithdrawCurrency(String currencyCode) {
  switch (currencyCode.toUpperCase()) {
    case 'NGN':
      return WithdrawCurrency.ngn;
    case 'GHS':
      return WithdrawCurrency.ghs;
    case 'KES':
      return WithdrawCurrency.kes;
    case 'ZAR':
      return WithdrawCurrency.zar;
    case 'USD':
      return WithdrawCurrency.usd;
    case 'XOF':
      return WithdrawCurrency.xof;
    case 'ZMW':
      return WithdrawCurrency.zmw;
    case 'XAF':
      return WithdrawCurrency.xaf;
    case 'SLE':
      return WithdrawCurrency.sle;
    case 'CDF':
      return WithdrawCurrency.cdf;
    case 'TZS':
      return WithdrawCurrency.tzs;
    case 'UGX':
      return WithdrawCurrency.ugx;
    case 'EGP':
      return WithdrawCurrency.egp;
    case 'MWK':
      return WithdrawCurrency.mwk;
    case 'RWF':
      return WithdrawCurrency.rwf;
    case 'ETB':
      return WithdrawCurrency.etb;
    default:
      throw Exception('Unsupported currency: $currencyCode');
  }
}

mm.Currency mapCurrency(String currencyCode) {
  switch (currencyCode.toUpperCase()) {
    case 'NGN':
      return mm.Currency.ngn;
    case 'GHS':
      return mm.Currency.ghs;
    case 'KES':
      return mm.Currency.kes;
    case 'ZAR':
      return mm.Currency.zar;
    case 'USD':
      return mm.Currency.usd;
    case 'XOF':
      return mm.Currency.xof;
    case 'ZMW':
      return mm.Currency.zmw;
    case 'XAF':
      return mm.Currency.xaf;
    case 'SLE':
      return mm.Currency.sle;
    case 'CDF':
      return mm.Currency.cdf;
    case 'TZS':
      return mm.Currency.tzs;
    case 'UGX':
      return mm.Currency.ugx;
    case 'EGP':
      return mm.Currency.egp;
    case 'MWK':
      return mm.Currency.mwk;
    case 'RWF':
      return mm.Currency.rwf;
    case 'ETB':
      return mm.Currency.etb;
    default:
      throw Exception('Unsupported currency: $currencyCode');
  }
}

int getTokenDecimals() {
  if (Env.isDev) {
    return 18;
  } else if (Env.isStaging) {
    return 6;
  } else if (Env.isProd) {
    return 6;
  }
  return 6;
}

String getPaymentChannelName(String userFriendlyName) {
  switch (userFriendlyName) {
    case 'Airtime':
      return 'airtime';
    case 'Bank Transfer':
      return 'bank';
    case 'Mobile money':
      return 'mobile_money';
    default:
      return 'mobile_money';
  }
}

const List<int> _learnwayTag = [0x4c, 0x45, 0x41, 0x52, 0x4e, 0x57, 0x41, 0x59];

Uint8List encodeERC20TransferWithTag(
  EthereumAddress tokenAddress,
  EthereumAddress recipient,
  BigInt amountInWei,
) {
  final baseCalldata = ContractUtils.encodeERC20TransferCall(
    tokenAddress,
    recipient,
    amountInWei,
  );

  final taggedCalldata = Uint8List(baseCalldata.length + _learnwayTag.length);
  taggedCalldata.setAll(0, baseCalldata);
  taggedCalldata.setAll(baseCalldata.length, _learnwayTag);
  return taggedCalldata;
}
