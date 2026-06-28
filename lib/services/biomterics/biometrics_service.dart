import 'package:biometric_storage/biometric_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:learnwayv2/services/secret_sharing_service/crypto/cryptography_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_entities.dart';

class BiometricService {
  static const String _passphraseStorageKey = 'wallet_passphrase';
  static const String _encryptionMetadataKey = 'encryption_metadata';

  final CryptographyService _cryptoService;
  BiometricStorageFile? _storage;
  BiometricStorageFile? _metadataStorage;

  BiometricService({CryptographyService? cryptoService})
    : _cryptoService = cryptoService ?? CryptographyService();

  Future<void> _initStorage() async {
    if (_storage != null && _metadataStorage != null) return;

    try {
      _storage = await BiometricStorage().getStorage(
        _passphraseStorageKey,
        options: StorageFileInitOptions(
          authenticationValidityDurationSeconds: 30,
          androidBiometricOnly: true,
        ),
        promptInfo: PromptInfo(
          androidPromptInfo: AndroidPromptInfo(
            title: 'Authenticate to access your wallet',
          ),
          iosPromptInfo: IosPromptInfo(
            accessTitle: 'Authenticate to access your wallet',
          ),
        ),
      );

      _metadataStorage = await BiometricStorage().getStorage(
        _encryptionMetadataKey,
        options: StorageFileInitOptions(
          authenticationValidityDurationSeconds: 30,
          androidBiometricOnly: true,
        ),
        promptInfo: PromptInfo(
          androidPromptInfo: AndroidPromptInfo(
            title: 'Authenticate to access your wallet',
          ),
          iosPromptInfo: IosPromptInfo(
            accessTitle: 'Authenticate to access your wallet',
          ),
        ),
      );
    } catch (e) {
      log('Error initializing biometric storage: $e');
      rethrow;
    }
  }

  Future<BiometricAvailability> checkBiometricAvailability() async {
    try {
      final response = await BiometricStorage().canAuthenticate();

      switch (response) {
        case CanAuthenticateResponse.success:
          return BiometricAvailability.available;
        case CanAuthenticateResponse.errorHwUnavailable:
        case CanAuthenticateResponse.errorNoHardware:
          return BiometricAvailability.notAvailable;
        case CanAuthenticateResponse.errorNoBiometricEnrolled:
          return BiometricAvailability.notEnrolled;
        case CanAuthenticateResponse.statusUnknown:
        case CanAuthenticateResponse.unsupported:
        default:
          return BiometricAvailability.error;
      }
    } catch (e) {
      log('Error checking biometric availability: $e');
      return BiometricAvailability.error;
    }
  }

  Future<bool> storeBiometricPassphrase(String passphrase) async {
    try {
      await _initStorage();

      if (_storage == null || _metadataStorage == null) {
        log('Biometric storage not available');
        return false;
      }

      final salt = _cryptoService.generateSecureBytes(
        _cryptoService.saltLengthBytes,
      );

      final masterKey = _cryptoService.generateSecureBytes(32);
      final encryptionKey = await _cryptoService.deriveKeyWithArgon2(
        passphrase: base64Encode(masterKey),
        salt: salt,
      );

      final aad = utf8.encode('learnway_biometric_passphrase_v1');

      final encryptedPassphrase = await _cryptoService.encryptWithDerivedKey(
        utf8.encode(passphrase),
        encryptionKey,
        aad: aad,
      );

      final metadata = {
        'salt': base64Encode(salt),
        'nonce': base64Encode(encryptedPassphrase.nonce),
        'mac': base64Encode(encryptedPassphrase.mac.bytes),
        'masterKey': base64Encode(masterKey),
        'version': '1.0',
        'algorithm': 'argon2id-aes256gcm',
        'created': DateTime.now().toIso8601String(),
      };

      await _storage!.write(base64Encode(encryptedPassphrase.cipherText));
      await _metadataStorage!.write(jsonEncode(metadata));

      _cryptoService.secureZeroize(masterKey);
      _cryptoService.secureZeroize(encryptionKey);
      _cryptoService.secureZeroize(encryptedPassphrase.cipherText);

      log(
        'Passphrase stored with Argon2+AES-GCM encryption and biometric protection',
      );
      return true;
    } on AuthException catch (e) {
      log(
        'Authentication error while storing passphrase: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      log('Error storing encrypted biometric passphrase: $e');
      return false;
    }
  }

  Future<String?> getBiometricPassphrase() async {
    try {
      await _initStorage();

      if (_storage == null || _metadataStorage == null) {
        log('Biometric storage not available');
        return null;
      }

      final encryptedDataB64 = await _storage!.read();
      final metadataJson = await _metadataStorage!.read();

      if (encryptedDataB64 == null || metadataJson == null) {
        log('No stored passphrase data found');
        return null;
      }

      final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
      final salt = base64Decode(metadata['salt'] as String);
      final nonce = base64Decode(metadata['nonce'] as String);
      final macBytes = base64Decode(metadata['mac'] as String);
      final masterKey = base64Decode(metadata['masterKey'] as String);
      final cipherText = base64Decode(encryptedDataB64);

      final encryptionKey = await _cryptoService.deriveKeyWithArgon2(
        passphrase: base64Encode(masterKey),
        salt: salt,
      );

      final encryptedData = EncryptedData(
        cipherText: cipherText,
        nonce: nonce,
        mac: Mac(macBytes),
      );

      final aad = utf8.encode('learnway_biometric_passphrase_v1');

      final decryptedBytes = await _cryptoService.decryptWithDerivedKey(
        encryptedData,
        encryptionKey,
        aad: aad,
      );

      final decryptedPassphrase = utf8.decode(decryptedBytes);

      _cryptoService.secureZeroize(masterKey);
      _cryptoService.secureZeroize(encryptionKey);
      _cryptoService.secureZeroize(decryptedBytes);

      log(
        'Successfully retrieved and decrypted passphrase using biometric authentication',
      );
      return decryptedPassphrase;
    } on AuthException catch (e) {
      log('Authentication failed: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      log('Error retrieving encrypted biometric passphrase: $e');
      return null;
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      await _initStorage();

      if (_storage == null) return false;

      final hasData = await _storage!.read() != null;
      return hasData;
    } catch (e) {
      log('Error checking biometric enabled status: $e');
      return false;
    }
  }

  Future<bool> disableBiometric() async {
    try {
      await _initStorage();

      if (_storage == null || _metadataStorage == null) return false;

      await _storage!.delete();
      await _metadataStorage!.delete();
      log('Biometric authentication disabled');
      return true;
    } catch (e) {
      log('Error disabling biometric: $e');
      return false;
    }
  }

  Future<bool> testBiometricAuthentication() async {
    try {
      await _initStorage();

      if (_storage == null) return false;

      try {
        await _storage!.read();
        return true;
      } on AuthException catch (e) {
        if (e.code == AuthExceptionCode.userCanceled) {
          return false;
        }

        await _storage!.write('test');
        await _storage!.delete();
        return true;
      }
    } catch (e) {
      log('Biometric authentication test failed: $e');
      return false;
    }
  }

  String getBiometricTypeName() {
    return 'Biometric';
  }

  String getBiometricIconName() {
    return 'fingerprint';
  }

  Future<List<String>> getSupportedBiometricTypes() async {
    try {
      final canAuth = await BiometricStorage().canAuthenticate();
      if (canAuth == CanAuthenticateResponse.success) {
        return ['biometric'];
      }
      return [];
    } catch (e) {
      log('Error getting supported biometric types: $e');
      return [];
    }
  }
}

enum BiometricAvailability { available, notAvailable, notEnrolled, error }

class BiometricResult {
  final bool success;
  final String? passphrase;
  final String? errorMessage;

  const BiometricResult({
    required this.success,
    this.passphrase,
    this.errorMessage,
  });

  factory BiometricResult.success(String passphrase) {
    return BiometricResult(success: true, passphrase: passphrase);
  }

  factory BiometricResult.failure(String errorMessage) {
    return BiometricResult(success: false, errorMessage: errorMessage);
  }
}
