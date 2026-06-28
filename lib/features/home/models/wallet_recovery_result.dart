import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:variance_dart/variance_dart.dart';

class WalletRecoveryResult {
  final SmartWallet? wallet;
  final String? error;
  final WalletRecoveryStatus status;

  WalletRecoveryResult({this.wallet, this.error, required this.status});
}

class WalletRecoveryParams {
  final String userEmail;
  final String remoteSharesData;
  final String userPassphrase;
  final String walletAddress;

  WalletRecoveryParams({
    required this.userEmail,
    required this.remoteSharesData,
    required this.userPassphrase,
    required this.walletAddress,
  });
}
