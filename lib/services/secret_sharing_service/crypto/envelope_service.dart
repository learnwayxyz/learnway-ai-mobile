import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/cryptography_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/helpers.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';

class EnvelopeService {
  final CryptographyService _cryptoService;

  EnvelopeService({CryptographyService? cryptoService})
    : _cryptoService = cryptoService ?? CryptographyService();

  /// Builds an encrypted envelope for secure storage
  Future<Map<String, dynamic>> buildEncryptedEnvelope({
    required String userEmail,
    required String walletAddress,
    required String userPassphrase,
    required String shareType,
    required Map<String, dynamic> sharePayload,
  }) async {
    final normalizedEmail = userEmail.toLowerCase().trim();
    final normalizedWallet = walletAddress.toLowerCase().trim();

    // Context binding via AAD
    final aad = utf8.encode(
      'learnway_v3|$normalizedEmail|$normalizedWallet|$shareType',
    );

    final salt = _cryptoService.generateSecureBytes(
      _cryptoService.saltLengthBytes,
    );
    final argon2Params = Argon2Params(
      salt: salt,
      parallelism: 4,
      memoryKb: 65536,
      iterations: 3,
      keyLengthBytes: _cryptoService.keyLengthBytes,
    );

    // Derive key
    final keyMaterial = SecretHelpers.normalizeKeyMaterial(
      email: normalizedEmail,
      userPassphrase: userPassphrase,
      walletAddress: normalizedWallet,
    );

    final keyBytes = await _cryptoService.deriveKeyWithArgon2(
      passphrase: keyMaterial,
      salt: argon2Params.salt,
      parallelism: argon2Params.parallelism,
      memoryKb: argon2Params.memoryKb,
      iterations: argon2Params.iterations,
      keyLengthBytes: argon2Params.keyLengthBytes,
    );

    // Encrypt
    final plaintext = utf8.encode(jsonEncode(sharePayload));
    final encryptedData = await _cryptoService.encryptWithDerivedKey(
      Uint8List.fromList(plaintext),
      keyBytes,
      aad: aad,
    );

    _cryptoService.secureZeroize(keyBytes);

    return {
      'shareType': shareType,
      'encryptedData': encryptedData.toBase64String(),
      'argon2Params': argon2Params.toJson(),
      'authProvider': sharePayload['authProvider'],
    };
  }

  /// Encrypts a share with a user passphrase
  Future<({EncryptedData encryptedData, Argon2Params argon2Params})>
  encryptShareWithPassphrase(
    String userEmail,
    String shareData, {
    required String userPassphrase,
    required String walletAddress,
    String shareType = 'localShare',
  }) async {
    final normalizedEmail = userEmail.toLowerCase().trim();
    final normalizedWallet = walletAddress.toLowerCase().trim();
    final aad = utf8.encode(
      'learnway_v3|$normalizedEmail|$normalizedWallet|$shareType',
    );

    final salt = _cryptoService.generateSecureBytes(
      _cryptoService.saltLengthBytes,
    );
    final argon2Params = Argon2Params(
      salt: salt,
      parallelism: 4,
      memoryKb: 65536,
      iterations: 3,
      keyLengthBytes: _cryptoService.keyLengthBytes,
    );

    final keyMaterial = SecretHelpers.normalizeKeyMaterial(
      email: normalizedEmail,
      userPassphrase: userPassphrase,
      walletAddress: normalizedWallet,
    );

    final keyBytes = await _cryptoService.deriveKeyWithArgon2(
      passphrase: keyMaterial,
      salt: salt,
      parallelism: argon2Params.parallelism,
      memoryKb: argon2Params.memoryKb,
      iterations: argon2Params.iterations,
      keyLengthBytes: argon2Params.keyLengthBytes,
    );

    final plaintext = utf8.encode(shareData);
    final encryptedData = await _cryptoService.encryptWithDerivedKey(
      Uint8List.fromList(plaintext),
      keyBytes,
      aad: aad,
    );

    _cryptoService.secureZeroize(keyBytes);

    return (encryptedData: encryptedData, argon2Params: argon2Params);
  }

  /// Decrypts a share with a user passphrase
  Future<String?> decryptShareWithPassphrase(
    String userEmail,
    EncryptedData encryptedData,
    Argon2Params argon2Params, {
    required String userPassphrase,
    required String walletAddress,
    String shareType = 'localShare',
  }) async {
    try {
      final normalizedEmail = userEmail.toLowerCase().trim();
      final normalizedWallet = walletAddress.toLowerCase().trim();
      final aad = utf8.encode(
        'learnway_v3|$normalizedEmail|$normalizedWallet|$shareType',
      );

      final keyMaterial = SecretHelpers.normalizeKeyMaterial(
        email: normalizedEmail,
        userPassphrase: userPassphrase,
        walletAddress: normalizedWallet,
      );

      final keyBytes = await _cryptoService.deriveKeyWithArgon2(
        passphrase: keyMaterial,
        salt: argon2Params.salt,
        parallelism: argon2Params.parallelism,
        memoryKb: argon2Params.memoryKb,
        iterations: argon2Params.iterations,
        keyLengthBytes: argon2Params.keyLengthBytes,
      );

      final decrypted = await _cryptoService.decryptWithDerivedKey(
        encryptedData,
        keyBytes,
        aad: aad,
      );
      _cryptoService.secureZeroize(keyBytes);
      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint('Error decrypting share with passphrase: $e');
      return null;
    }
  }
}
