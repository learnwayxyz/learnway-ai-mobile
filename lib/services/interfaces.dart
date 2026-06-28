import 'dart:io';

import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/services/cloud/cloud_services.dart'
    show GoogleCloudServices, IOSCloudService;

import 'package:variance_dart/variance_dart.dart';

import 'secret_sharing_service/secret_sharing_entities.dart';

abstract class IWalletService {
  Future<SmartWallet> createEOAWallet({required String salt});
  Future<(SmartWallet, RecoveryConfig)> createWalletWithRecovery({
    required String userEmail,
    required AuthProvider authProvider,
    required String userPassphrase,
    required String userId,
  });
  Future<SmartWallet> recoverAccount(String mnemonic);
  Future<void> claimSignUpReward(SmartWallet smartWallet);
  Future<BigInt?> checkBalanceOf(SmartWallet smartWallet);
}

abstract class ICloudServices {
  factory ICloudServices.google() => GoogleCloudServices();
  factory ICloudServices.ios() => IOSCloudService();
  factory ICloudServices.isPlatform() {
    return Platform.isAndroid ? GoogleCloudServices() : ICloudServices.ios();
  }
  static const String resourceIdentifier = 'cloudService.identifier';
  Future<bool?> upload(String data) async {
    throw UnimplementedError('Not implemented');
  }

  Future<Map<String, dynamic>> download() async {
    throw UnimplementedError('Not implemented');
  }

  Future<bool?> backUpExists() async {
    throw UnimplementedError('Not implemented');
  }

  Future<void> deleteFile() async {
    throw UnimplementedError('Not implemented');
  }

  Future<bool> isSignedIn() async {
    throw UnimplementedError('Not implemented');
  }
}

abstract class SecretSharingService {
  Future<void> shareSecret(String secret, AuthConfig authConfig);
  Future<String> recoverWalletWithRemoteSharesAndPassphrase(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  );
  Future<bool> hasExistingShares(String userEmail);
  Future<AuthProvider?> getAuthProviderFromShare(String userEmail);
}
