import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';

class AuthConfig {
  final String userId;
  final String userEmail;
  final AuthProvider authProvider;
  final String? userPassphrase;
  final String? walletAddress;
  AuthConfig({
    required this.userId,
    required this.userEmail,
    required this.authProvider,
    this.userPassphrase,
    this.walletAddress,
  });
}

class RecoveryConfig {
  final String userEmail;
  final String recoveryKey;
  final DateTime createdAt;
  final AuthProvider? authProvider;

  RecoveryConfig({
    required this.userEmail,
    required this.recoveryKey,
    required this.createdAt,
    this.authProvider,
  });

  Map<String, dynamic> toJson() => {
    'userEmail': userEmail,
    'recoveryKey': recoveryKey,
    'createdAt': createdAt.toIso8601String(),
    if (authProvider != null) 'authProvider': authProvider!.name,
  };

  factory RecoveryConfig.fromJson(Map<String, dynamic> json) => RecoveryConfig(
    userEmail: json['userEmail'],
    recoveryKey: json['recoveryKey'],
    createdAt: DateTime.parse(json['createdAt']),
    authProvider:
        json['authProvider'] != null
            ? AuthProvider.values.firstWhere(
              (e) => e.name == json['authProvider'],
              orElse: () => AuthProvider.email,
            )
            : null,
  );
}

class EncryptedData {
  final Uint8List cipherText;
  final Uint8List nonce;
  final Mac mac;

  EncryptedData({
    required this.cipherText,
    required this.nonce,
    required this.mac,
  });

  Map<String, dynamic> toJson() => {
    'cipherText': base64Encode(cipherText),
    'nonce': base64Encode(nonce),
    'mac': base64Encode(mac.bytes),
  };

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      cipherText: base64Decode(json['cipherText']),
      nonce: base64Decode(json['nonce']),
      mac: Mac(base64Decode(json['mac'])),
    );
  }

  String toBase64String() => base64Encode(utf8.encode(jsonEncode(toJson())));

  static EncryptedData fromBase64String(String data) {
    final decoded = utf8.decode(base64Decode(data));
    final Map<String, dynamic> jsonData = jsonDecode(decoded);
    return EncryptedData.fromJson(jsonData);
  }
}

class RemoteShare {
  final String shareType;
  final String encryptedData;
  final Argon2Params argon2Params;

  RemoteShare({
    required this.shareType,
    required this.encryptedData,
    required this.argon2Params,
  });

  Map<String, dynamic> toJson() => {
    'shareType': shareType,
    'encryptedData': encryptedData,
    'argon2Params': argon2Params.toJson(),
  };
}

class Argon2Params {
  final Uint8List salt;
  final int parallelism;
  final int memoryKb;
  final int iterations;
  final int keyLengthBytes;

  Argon2Params({
    required this.salt,
    required this.parallelism,
    required this.memoryKb,
    required this.iterations,
    required this.keyLengthBytes,
  });

  Map<String, dynamic> toJson() => {
    'salt': base64Encode(salt),
    'parallelism': parallelism,
    'memoryKb': memoryKb,
    'iterations': iterations,
    'keyLengthBytes': keyLengthBytes,
  };

  factory Argon2Params.fromJson(Map<String, dynamic> json) => Argon2Params(
    salt: base64Decode(json['salt']),
    parallelism: json['parallelism'],
    memoryKb: json['memoryKb'],
    iterations: json['iterations'],
    keyLengthBytes: json['keyLengthBytes'],
  );
}
