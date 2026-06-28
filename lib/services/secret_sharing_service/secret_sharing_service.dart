import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/services/cloud/cloud_adapter.dart';
import 'package:learnwayv2/services/interfaces.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/envelope_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/share_processor.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/storage_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';
import 'package:slip39/slip39.dart';

abstract class BaseSecretSharingService implements SecretSharingService {
  BaseSecretSharingService({
    FlutterSecureStorage? secureStorage,
    required this.cloudService,
    EnvelopeService? envelopeService,
    StorageManager? storageManager,
    ShareProcessor? shareProcessor,
  }) : _envelopeService = envelopeService ?? EnvelopeService(),
       _storageManager =
           storageManager ??
           StorageManager(
             secureStorage: secureStorage,
             cloudService: cloudService,
           ),
       _shareProcessor = shareProcessor ?? ShareProcessor();

  final CloudServiceAdapter? cloudService;
  final EnvelopeService _envelopeService;
  final StorageManager _storageManager;
  final ShareProcessor _shareProcessor;

  @override
  Future<bool> hasExistingShares(String userEmail) async {
    try {
      final storedEmail = await _storageManager.getUserEmail();
      if (storedEmail != userEmail) return false;

      final cloudExists = await _storageManager.hasCloudBackup();
      final localExists = await _storageManager.hasLocalShare(userEmail);
      return cloudExists || localExists;
    } catch (e) {
      dev.log('Error checking existing shares: $e');
      return false;
    }
  }

  @override
  Future<void> shareSecret(String secret, AuthConfig authConfig) async {
    dev.log('Sharing secret for user: ${authConfig.userEmail}');

    final walletAddress =
        authConfig.walletAddress ??
        await LocalStorageService.getWalletAddress();
    final userPassphrase = authConfig.userPassphrase;
    if (walletAddress.isEmpty) {
      throw Exception('Wallet address is required for key generation');
    }
    if (userPassphrase == null || userPassphrase.isEmpty) {
      throw Exception('User passphrase is required for encryption');
    }

    try {
      await _storageManager.setUserEmail(authConfig.userEmail);

      final slipTree = {
        'name': 'user_secret',
        'threshold': 1,
        'shares': [
          {
            'name': 'device_storage',
            'threshold': 2,
            'shares': ['local_device', 'cloud_storage', 'backend_api'],
          },
        ],
      };

      final masterSecret = _shareProcessor.ensureEvenLength(secret);
      final slip = Slip39.from(
        slipTree,
        masterSecret: masterSecret,
        passphrase: '',
        iterationExponent: 1,
      );

      final localShare = getSingleShare(slip, 'r/0/0');
      final backendShare1 = getSingleShare(slip, 'r/0/1');
      final backendShare2 = getSingleShare(slip, 'r/0/2');

      await _storageManager.storeToSecureStorage(
        authConfig.userEmail,
        localShare,
        userPassphrase: userPassphrase,
        walletAddress: walletAddress,
      );

      final sharesToSend = <String, String>{};

      final backendEnvelope = await _envelopeService.buildEncryptedEnvelope(
        userEmail: authConfig.userEmail,
        walletAddress: walletAddress,
        userPassphrase: userPassphrase,
        shareType: 'backendShare1',
        sharePayload: {
          'version': '3.0',
          'userEmail': authConfig.userEmail,
          'wallet': walletAddress,
          'shareType': 'backendShare1',
          'share': backendShare1,
          'storedAt': DateTime.now().toIso8601String(),
          'authProvider': authConfig.authProvider.name,
        },
      );

      sharesToSend['backendShare1'] = jsonEncode(backendEnvelope);

      final cloudEnvelope = await _envelopeService.buildEncryptedEnvelope(
        userEmail: authConfig.userEmail,
        walletAddress: walletAddress,
        userPassphrase: userPassphrase,
        shareType: 'backendShare2',
        sharePayload: {
          'version': '3.0',
          'userEmail': authConfig.userEmail,
          'wallet': walletAddress,
          'shareType': 'backendShare2',
          'share': backendShare2,
          'storedAt': DateTime.now().toIso8601String(),
          'authProvider': authConfig.authProvider.name,
        },
      );

      sharesToSend['backendShare2'] = jsonEncode(cloudEnvelope);

      await _sendSharesToBackend(
        authConfig.userEmail,
        sharesToSend,
        userId: authConfig.userId,
      );
      dev.log('Secret shared successfully');
    } catch (e) {
      throw Exception('Failed to share secret: $e');
    }
  }

  @override
  Future<String> recoverWalletWithRemoteSharesAndPassphrase(
    String userEmail,
    String remoteSharesData,
    String userPassphrase,
    String walletAddress,
  ) async {
    dev.log('Recovering wallet (remote shares) for: $userEmail');

    try {
      final remoteShares = _shareProcessor.parseRemoteShares(remoteSharesData);
      dev.log('Parsed ${remoteShares.length} remote shares');

      final localShareMnemonic = await _storageManager.getLocalShare(
        userEmail,
        userPassphrase,
        walletAddress,
      );

      final collectedShares = await _shareProcessor.collectSharesForRecovery(
        userEmail,
        userPassphrase,
        walletAddress,
        remoteShares,
        localShareMnemonic,
      );

      if (collectedShares.length < 2) {
        throw Exception(
          'Not enough shares. Found ${collectedShares.length}/3, need at least 2.',
        );
      }

      dev.log('Recovered ${collectedShares.length} shares');

      final recoveredSecret = Slip39.recoverSecret(collectedShares);
      await _storageManager.setUserEmail(userEmail);

      final result = _shareProcessor.recoverOriginalSecret(
        Uint8List.fromList(recoveredSecret),
      );
      dev.log('Wallet recovery successful');
      return result;
    } catch (e) {
      dev.log('Error in recoverWalletWithRemoteSharesAndPassphrase: $e');
      rethrow;
    }
  }

  @override
  Future<AuthProvider?> getAuthProviderFromShare(String userEmail) async {
    try {
      if (cloudService != null) {
        final envelopeStr = await cloudService!.download();
        if (envelopeStr != null) {
          final map = jsonDecode(envelopeStr);
          final authProviderName = map['authProvider'] as String?;
          if (authProviderName != null) {
            return AuthProvider.values.firstWhere(
              (e) => e.name == authProviderName,
              orElse: () => AuthProvider.email,
            );
          }
        }
      }
      return AuthProvider.email;
    } catch (e) {
      dev.log('Error getting auth provider from share: $e');
      return AuthProvider.email;
    }
  }

  String getSingleShare(Slip39 slip, String path) {
    final node = slip.fromPath(path);
    if (node.mnemonics.isEmpty) {
      throw Exception('Invalid SLIP39 path: $path');
    }
    return node.mnemonics.first;
  }

  Future<void> _sendSharesToBackend(
    String userEmail,
    Map<String, String> shares, {
    required String userId,
  }) async {
    try {
      final walletAddress = await LocalStorageService.getWalletAddress();
      if (walletAddress.isEmpty) {
        throw Exception('Wallet address is empty');
      }

      final structuredShares = <Map<String, dynamic>>[];
      for (final entry in shares.entries) {
        final envelope = jsonDecode(entry.value);
        structuredShares.add({
          'shareType': envelope['shareType'] ?? entry.key,
          'encryptedData': envelope['encryptedData'],
          'argon2Params': envelope['argon2Params'],
        });
      }

      final response = await locator<BaseApiClients>().patch(
        Endpoints.updateProfile,
        body: {
          'walletAddress': walletAddress,
          'halfPrivateKey': jsonEncode(structuredShares),
          'userEmail': userEmail,
          'userId': userId,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${await SharedPreferencesStore.getUserToken(userTokenKey)}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to store shares in backend: ${response.statusCode} - ${response.body}',
        );
      }

      dev.log('Structured shares successfully sent to backend');
    } catch (e) {
      throw Exception('Error sending shares to backend: $e');
    }
  }
}

class IOSSecretSharingService extends BaseSecretSharingService {
  IOSSecretSharingService({
    super.secureStorage,
    super.cloudService,
    super.envelopeService,
    super.storageManager,
    super.shareProcessor,
  });
}

class AndroidSecretSharingService extends BaseSecretSharingService {
  AndroidSecretSharingService({
    super.secureStorage,
    super.cloudService,
    super.envelopeService,
    super.storageManager,
    super.shareProcessor,
  });
}
