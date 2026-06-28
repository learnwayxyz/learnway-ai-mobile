import 'dart:async';
import 'dart:developer' as dev;
import 'package:learnwayv2/services/secret_sharing_service/crypto/share_processor.dart';
import 'package:slip39/slip39.dart';

class IsolateRecoveryService {
  static final IsolateRecoveryService _instance =
      IsolateRecoveryService._internal();

  factory IsolateRecoveryService() => _instance;

  IsolateRecoveryService._internal();
  Future<List<int>> recovery(
    String remoteShares,
    String userName,
    String userEmail,
    String walletAddress,
    String userId,
    String pepAddress,
  ) async {
    final processor = ShareProcessor();
    final shares = processor.parseRemoteShares(remoteShares);
    final collectedShares = await processor.collectSharesForRecovery(
      userEmail,
      '$userEmail:$userId:$pepAddress',
      walletAddress,
      shares,
      null,
    );

    dev.log('Collected ${collectedShares.length} shares');

    if (collectedShares.length < 2) {
      throw Exception(
        'Not enough shares. Found ${collectedShares.length}/3, need at least 2.',
      );
    }
    dev.log('Recovered ${collectedShares.length} shares');
    final recoveredSecret = Slip39.recoverSecret(collectedShares);
    return recoveredSecret;
  }

  Future<List<int>> recoveryEntry(Map<String, dynamic> args) async {
    final service = IsolateRecoveryService();
    final recoveryArgs = RecoveryArgs.fromMap(args);

    return service.recovery(
      recoveryArgs.remoteShares,
      recoveryArgs.userName,
      recoveryArgs.userEmail,
      recoveryArgs.walletAddress,
      recoveryArgs.userId,
      recoveryArgs.pepAddress,
    );
  }
}

class RecoveryArgs {
  RecoveryArgs({
    required this.userPassPhraseBlob,
    required this.remoteShares,
    required this.userName,
    required this.userEmail,
    required this.walletAddress,
    required this.userId,
    required this.pepAddress,
  });

  final String userPassPhraseBlob;
  final String remoteShares;
  final String userName;
  final String userEmail;
  final String walletAddress;
  final String userId;
  final String pepAddress;

  Map<String, dynamic> toMap() => {
    'userPassPhraseBlob': userPassPhraseBlob,
    'remoteShares': remoteShares,
    'userName': userName,
    'userEmail': userEmail,
    'walletAddress': walletAddress,
    'userId': userId,
    'pepAddress': pepAddress,
  };

  factory RecoveryArgs.fromMap(Map<String, dynamic> map) => RecoveryArgs(
    userPassPhraseBlob: map['userPassPhraseBlob'],
    remoteShares: map['remoteShares'],
    userName: map['userName'],
    userEmail: map['userEmail'],
    walletAddress: map['walletAddress'],
    userId: map['userId'],
    pepAddress: map['pepAddress'],
  );
}
