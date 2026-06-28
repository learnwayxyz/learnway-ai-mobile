import 'package:learnwayv2/services/interfaces.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_factory.dart';

class SecretSharingManager {
  late final SecretSharingService _service;

  SecretSharingManager({ICloudServices? cloudService}) {
    _service = SecretSharingServiceFactory.create(cloudService: cloudService);
  }

  Future<void> setupSecretSharing(String secret, AuthConfig authConfig) async {
    return await _service.shareSecret(secret, authConfig);
  }

  Future<String> recoverWithRemoteShares(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  ) async {
    return await _service.recoverWalletWithRemoteSharesAndPassphrase(
      userEmail,
      remoteSharesData,
      userPassphrase,
      walletAddress,
    );
  }

  Future<bool> hasBackup(String userEmail) async {
    return await _service.hasExistingShares(userEmail);
  }

  Future<bool> hasExistingShares(String userEmail) async {
    return await _service.hasExistingShares(userEmail);
  }

  Future<void> shareSecret(String secret, AuthConfig authConfig) async {
    await _service.shareSecret(secret, authConfig);
  }

  Future<String> recoverWalletWithRemoteSharesAndPassphrase(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  ) async {
    return await _service.recoverWalletWithRemoteSharesAndPassphrase(
      userEmail,
      remoteSharesData,
      userPassphrase,
      walletAddress,
    );
  }

  SecretSharingService get service => _service;
}
