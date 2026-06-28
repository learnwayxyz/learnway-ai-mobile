import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';

class CryptographyService {
  // Argon2id default parameters (balanced UX/security)
  static const int _defaultArgon2Parallelism = 4;
  static const int _defaultArgon2MemoryKb = 65536;
  static const int _defaultArgon2Iterations = 3;
  static const int _defaultKeyLengthBytes = 32;
  static const int _saltLengthBytes = 32;
  static const int _nonceLengthBytes = 12;

  /// Derives a key using Argon2id algorithm
  Future<Uint8List> deriveKeyWithArgon2({
    required String passphrase,
    required Uint8List salt,
    int parallelism = _defaultArgon2Parallelism,
    int memoryKb = _defaultArgon2MemoryKb,
    int iterations = _defaultArgon2Iterations,
    int keyLengthBytes = _defaultKeyLengthBytes,
  }) async {
    final argon2 = Argon2id(
      parallelism: parallelism,
      memory: memoryKb,
      iterations: iterations,
      hashLength: keyLengthBytes,
    );
    final derivedKey = await argon2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
    final keyBytes = await derivedKey.extractBytes();
    return Uint8List.fromList(keyBytes);
  }

  /// Encrypts data with AES-GCM using the derived key
  Future<EncryptedData> encryptWithDerivedKey(
    Uint8List plaintext,
    Uint8List keyBytes, {
    required List<int> aad,
  }) async {
    final algorithm = AesGcm.with256bits();
    final nonce = generateSecureBytes(_nonceLengthBytes);
    final secretKey = SecretKey(keyBytes);

    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: secretKey,
      nonce: nonce,
      aad: aad,
    );

    return EncryptedData(
      cipherText: Uint8List.fromList(secretBox.cipherText),
      nonce: nonce,
      mac: secretBox.mac,
    );
  }

  /// Decrypts data with AES-GCM using the derived key
  Future<Uint8List> decryptWithDerivedKey(
    EncryptedData encryptedData,
    Uint8List keyBytes, {
    required List<int> aad,
  }) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(keyBytes);
    final secretBox = SecretBox(
      encryptedData.cipherText,
      nonce: encryptedData.nonce,
      mac: encryptedData.mac,
    );
    final decrypted = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
      aad: aad,
    );
    return Uint8List.fromList(decrypted);
  }

  Uint8List generateSecureBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Securely zeros out sensitive data from memory
  void secureZeroize(Uint8List bytes) {
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = 0;
    }
  }

  /// Gets the default salt length
  int get saltLengthBytes => _saltLengthBytes;

  /// Gets the default key length
  int get keyLengthBytes => _defaultKeyLengthBytes;
}
