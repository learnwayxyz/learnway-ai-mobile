import 'dart:developer';

import 'package:variance_dart/variance_dart.dart';
import 'package:wallet/wallet.dart' show EthereumAddress;
import 'package:core/src/config/env/env.dart';

class ChainConfiguration {
  ChainConfiguration({
    required this.bundleUrl,
    required this.accountFactoryAddress,
    required this.learnWayPOCAddress,
    required this.learnWayTokenAddress,
    required this.learnWayFaucetAddress,
  });
  final String bundleUrl;
  final String accountFactoryAddress;
  final String learnWayPOCAddress;
  final String learnWayTokenAddress;
  final String learnWayFaucetAddress;

  Chain getChain() {
    return Chain(
      chainId: int.parse(Env.chainId),
      entrypoint: EntryPointAddress.v07,
      explorer: Env.explorerUrl,
      accountFactory: EthereumAddress.fromHex(accountFactoryAddress),
      bundler: (url: Env.bundleUrl, headers: null),
      paymaster: (url: Env.paymasterUrl, headers: null),
      jsonRpc: (url: Env.rpcUrl, headers: null),
      testnet: Env.isDev
          ? true
          : Env.isStaging
          ? false
          : Env.isProd
          ? false
          : true,
    );
  }
}
