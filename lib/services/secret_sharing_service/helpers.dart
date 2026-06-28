import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class SecretHelpers {
  static dynamic extractRawShare(String decrypted) {
    final data = jsonDecode(decrypted);
    return data is Map ? data['share'] : data;
  }

  static String? normalizeShare(dynamic rawShare) {
    if (rawShare == null) return null;

    if (rawShare is String) {
      final trimmed = rawShare.trim();
      if (trimmed.startsWith('[')) {
        try {
          final parsedList = List<String>.from(jsonDecode(trimmed));
          return parsedList.join(' ');
        } catch (_) {
          return trimmed;
        }
      }
      return trimmed;
    }

    if (rawShare is List) {
      return List<String>.from(rawShare).join(' ');
    }

    return rawShare.toString().trim();
  }

  static String normalizeKeyMaterial({
    required String email,
    required String userPassphrase,
    required String walletAddress,
  }) {
    return 'learnway_v3:$email:$userPassphrase:$walletAddress';
  }

  static Uint8List hashInput(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }
}
