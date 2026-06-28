import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/envelope_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/helpers.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';

class ShareProcessor {
  final EnvelopeService _envelopeService;

  ShareProcessor({EnvelopeService? envelopeService})
    : _envelopeService = envelopeService ?? EnvelopeService();

  List<RemoteShare> parseRemoteShares(String remoteSharesData) {
    final shares = <RemoteShare>[];
    try {
      final structuredShares = List<Map<String, dynamic>>.from(
        jsonDecode(remoteSharesData),
      );
      debugPrint(
        'Parsing structured format with ${structuredShares.length} shares',
      );
      for (final shareData in structuredShares) {
        final shareType = (shareData['shareType'] as String);
        final encryptedData = shareData['encryptedData'] as String;
        final argon2ParamsMap =
            shareData['argon2Params'] as Map<String, dynamic>;
        final argon2Params = Argon2Params.fromJson(argon2ParamsMap);
        shares.add(
          RemoteShare(
            shareType: shareType,
            encryptedData: encryptedData,
            argon2Params: argon2Params,
          ),
        );
        debugPrint(
          'Parsed share: $shareType (encrypted data length: ${encryptedData.length})',
        );
      }
    } catch (e) {
      debugPrint('Error parsing remote shares: $e');
    }
    debugPrint('Successfully parsed ${shares.length} shares total');
    return shares;
  }

  Future<String?> decryptRemoteShare(
    String userEmail,
    RemoteShare remoteShare,
    String userPassphrase,
    String walletAddress,
  ) async {
    try {
      final encryptedData = EncryptedData.fromBase64String(
        remoteShare.encryptedData,
      );
      final decrypted = await _envelopeService.decryptShareWithPassphrase(
        userEmail,
        encryptedData,
        remoteShare.argon2Params,
        userPassphrase: userPassphrase,
        walletAddress: walletAddress,
        shareType: remoteShare.shareType,
      );
      if (decrypted == null) return null;
      final rawShare = SecretHelpers.extractRawShare(decrypted);
      if (rawShare == null) return null;
      return SecretHelpers.normalizeShare(rawShare);
    } catch (e) {
      return null;
    }
  }

  Uint8List ensureEvenLength(String secret) {
    final bytes = utf8.encode(secret);
    if (bytes.length % 2 == 1) {
      return Uint8List.fromList([...bytes, 0]);
    }
    return Uint8List.fromList(bytes);
  }

  String recoverOriginalSecret(Uint8List recoveredBytes) {
    final bytes = recoveredBytes.toList();
    final originalLength = bytes.length;
    while (bytes.isNotEmpty && bytes.last == 0) {
      bytes.removeLast();
    }
    debugPrint(
      'recoverOriginalSecret: Removed ${originalLength - bytes.length} padding bytes',
    );
    final result = utf8.decode(bytes);
    debugPrint(
      'recoverOriginalSecret: Recovered string length: ${result.length}',
    );
    return result;
  }

  Future<List<String>> collectSharesForRecovery(
    String userEmail,
    String userPassphrase,
    String walletAddress,
    List<RemoteShare> remoteShares,
    String? localShare,
  ) async {
    final collectedShares = <String>[];
    if (localShare != null) {
      collectedShares.add(localShare);
    }

    for (final remoteShare in remoteShares) {
      try {
        final decryptedShareMnemonic = await decryptRemoteShare(
          userEmail,
          remoteShare,
          userPassphrase,
          walletAddress,
        );
        if (decryptedShareMnemonic != null &&
            decryptedShareMnemonic.isNotEmpty) {
          collectedShares.add(decryptedShareMnemonic);
        }
      } catch (e) {
        throw Exception('Failed to decrypt remote share: $e');
      }
    }

    return collectedShares;
  }
}
