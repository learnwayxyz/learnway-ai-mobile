import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learnwayv2/services/cloud/cloud_adapter.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/envelope_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';

class StorageManager {
  final FlutterSecureStorage _secureStorage;
  final EnvelopeService _envelopeService;
  final CloudServiceAdapter? _cloudService;

  static const String _userEmailKey = 'user_email';
  static const String _encryptedShareKey = 'slip39_encrypted_share';

  StorageManager({
    FlutterSecureStorage? secureStorage,
    EnvelopeService? envelopeService,
    CloudServiceAdapter? cloudService,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _envelopeService = envelopeService ?? EnvelopeService(),
       _cloudService = cloudService;

  Future<void> storeToSecureStorage(
    String userEmail,
    String secret, {
    required String userPassphrase,
    required String walletAddress,
  }) async {
    final localShareData = {
      'version': '3.0',
      'userEmail': userEmail,
      'wallet': walletAddress,
      'shareType': 'localShare',
      'share': secret,
      'storedAt': DateTime.now().toIso8601String(),
    };

    final encryption = await _envelopeService.encryptShareWithPassphrase(
      userEmail,
      jsonEncode(localShareData),
      userPassphrase: userPassphrase,
      walletAddress: walletAddress,
      shareType: 'localShare',
    );

    await _secureStorage.write(
      key: _encryptedShareKey,
      value: jsonEncode({
        'shareType': 'localShare',
        'encryptedData': encryption.encryptedData.toBase64String(),
        'argon2Params': encryption.argon2Params.toJson(),
      }),
    );
  }

  Future<bool> hasLocalShare(String userEmail) async {
    try {
      final storedEmail = await _secureStorage.read(key: _userEmailKey);
      if (storedEmail != userEmail) return false;
      final encryptedDataString = await _secureStorage.read(
        key: _encryptedShareKey,
      );
      return encryptedDataString != null;
    } catch (e) {
      debugPrint('Error checking local share: $e');
      return false;
    }
  }

  Future<String?> getLocalShare(
    String userEmail,
    String userPassphrase,
    String walletAddress,
  ) async {
    try {
      final storedEmail = await _secureStorage.read(key: _userEmailKey);
      if (storedEmail != userEmail) return null;

      final envelopeStr = await _secureStorage.read(key: _encryptedShareKey);
      if (envelopeStr == null) return null;

      final envelope = jsonDecode(envelopeStr) as Map<String, dynamic>;
      final encData = EncryptedData.fromBase64String(
        envelope['encryptedData'] as String,
      );
      final argon2Params = Argon2Params.fromJson(
        envelope['argon2Params'] as Map<String, dynamic>,
      );

      final decryptedString = await _envelopeService.decryptShareWithPassphrase(
        userEmail,
        encData,
        argon2Params,
        userPassphrase: userPassphrase,
        walletAddress: walletAddress,
        shareType: (envelope['shareType'] as String?) ?? 'localShare',
      );

      if (decryptedString == null) return null;

      final decryptedData = jsonDecode(decryptedString);
      final share = (decryptedData is Map) ? decryptedData['share'] : null;
      if (share is List) {
        return List<String>.from(share).join(' ');
      }
      return null;
    } catch (e) {
      debugPrint('Error getting local share: $e');
      return null;
    }
  }

  Future<String?> getFromCloudDrive(
    String userEmail,
    String userPassphrase,
    String walletAddress,
  ) async {
    if (_cloudService == null) return null;

    try {
      final envelopeStr = await _cloudService.download();
      if (envelopeStr == null) return null;

      final envelope = jsonDecode(envelopeStr) as Map<String, dynamic>;
      final encData = EncryptedData.fromBase64String(
        envelope['encryptedData'] as String,
      );
      final argon2Params = Argon2Params.fromJson(
        envelope['argon2Params'] as Map<String, dynamic>,
      );
      final shareType = (envelope['shareType'] as String?) ?? 'cloudShare';

      final decrypted = await _envelopeService.decryptShareWithPassphrase(
        userEmail,
        encData,
        argon2Params,
        userPassphrase: userPassphrase,
        walletAddress: walletAddress,
        shareType: shareType,
      );
      if (decrypted == null) return null;

      final data = jsonDecode(decrypted);
      final share = data['share'];
      if (share is List) {
        return List<String>.from(share).join(' ');
      }
      return share is String ? share : null;
    } catch (e) {
      debugPrint('Error retrieving cloud share: $e');
      return null;
    }
  }

  Future<void> setUserEmail(String userEmail) async {
    await _secureStorage.write(key: _userEmailKey, value: userEmail);
  }

  Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _userEmailKey);
  }

  Future<bool> hasCloudBackup() async {
    return _cloudService?.hasBackup() ?? false;
  }
}
